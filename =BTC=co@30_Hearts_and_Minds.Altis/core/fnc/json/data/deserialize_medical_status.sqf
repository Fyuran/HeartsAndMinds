/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_deserialize_medical_status
	
	Description:
	    Serialize player slot.
	
	Parameters:
	    _player - Unit. [Object]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_deserialize_medical_status;
	    (end)
	
	Author:
	    BaerMitUmlaut ACE3
	
---------------------------------------------------------------------------- */

params [
	["_state", createHashMap, [createHashMap]]
];

if (isNull player) exitWith {
	[format["Tried to deserialize a null player"], __FILE__, nil, true] call btc_debug_fnc_message;
};

// if unit is not initialized yet, wait until event is raised
if !(player getVariable ["ace_medical_initialized", false]) exitWith {
	["ace_medical_status_initialized", {
		params ["_unit"];
		_thisArgs params ["_target", "_state"];

		if (_unit == _target) then {
			[_state] call btc_json_fnc_deserialize_medical_status;
			[_thisType, _thisId] call CBA_fnc_removeEventHandler;
		};
	}, [player, _state]] call CBA_fnc_addEventHandlerArgs;
};

// set medical variables
_state apply {
	player setVariable [_x, _y, true];
};

// Reset timers
player setVariable ["ace_medical_lastWakeUpCheck", nil];

// Convert medications offset to time
private _medications = _state getOrDefault ["ace_medical_medications", []];
{
	_x set [1, _x#1 + CBA_missionTime];
} forEach _medications;
player setVariable ["ace_medical_medications", _medications, true];

// Update effects
[player] call ace_medical_engine_fnc_updateDamageEffects;
[player] call ace_medical_status_fnc_updateWoundBloodLoss;

// Transition within statemachine
private _currentState = [player, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
private _targetState = _state getOrDefault ["ace_medical_statemachineState", "Default"];
[player, ace_medical_STATE_MACHINE, _currentState, _targetState] call CBA_statemachine_fnc_manualTransition;

// Manually call wake up tranisition if necessary
if (_currentState in ["Unconscious", "CardiacArrest"] && {
	_targetState in ["Default", "Injured"]
}) then {
	[player, false] call ace_medical_status_fnc_setUnconsciousState;
};