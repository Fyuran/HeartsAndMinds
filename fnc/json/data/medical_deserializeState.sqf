/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_medical_deserializeState
	
	Description:
	    Deserializes ace medical state to a unit
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [
                ace_player,
                [[5.89533,98.4275,[95,142],100,1,0.468805,true,0,[["rightleg",[[11,1,0.0485834,0.883525]]]],[],[],[0,0,0,0,0,0],[0,0,0,0,0,36.1055],0,[["ACE_tourniquet",1,36.1055]],[0,0,0,0,0,0.883525]],[[]],"Injured"]
            ] call btc_json_fnc_medical_deserializeState;
	    (end)
	
	Author: BaerMitUmlaut, Fyuran
	
---------------------------------------------------------------------------- */

params [
    ["_unit", objNull, [objNull]], 
    ["_state", [], [[]]]
];
_state params [
    ["_vars", [], [[]], 18],
    ["_medications", [], [[]]],
    ["_targetState", "Default", [""]]
];

if (canSuspend) exitWith {
    [btc_json_fnc_medical_deserializeState, _this] call CBA_fnc_directCall
};

if (isNull _unit) exitWith {};
if (!local _unit) exitWith { diag_log text format ['[%1] (%2) %3: %4', toUpper 'ace', 'JSON medical', 'ERROR', format["unit [%1] is not local", _unit]] };

if !(_unit getVariable ["ace_medical_initialized", false]) exitWith {
    ["ace_medical_status_initialized", {
        params ["_unit"];
        _thisArgs params ["_target"];

        if (_unit == _target) then {
            _thisArgs call btc_json_fnc_medical_deserializeState;
            [_thisType, _thisId] call CBA_fnc_removeEventHandler;
        };
    }, _this] call CBA_fnc_addEventHandlerArgs;
};

_vars set [8, createHashMapFromArray (_vars#8)];
_vars set [9, createHashMapFromArray (_vars#9)];
_vars set [10, createHashMapFromArray (_vars#10)];

{
    private _value = _vars select _forEachindex;

    _unit setVariable [_x, _value, true];
} forEach [
    "ace_medical_bloodVolume", "ace_medical_heartRate",
    "ace_medical_bloodPressure", "ace_medical_peripheralResistance",
    "ace_medical_hemorrhage", "ace_medical_pain",
    "ace_medical_inPain", "ace_medical_painSuppress",
    "ace_medical_openWounds", "ace_medical_bandagedWounds",
    "ace_medical_stitchedWounds", "ace_medical_fractures",
    "ace_medical_tourniquets", "ace_medical_occludedMedications",
    "ace_medical_ivBags", "ace_medical_triageLevel",
    "ace_medical_triageCard", "ace_medical_bodyPartDamage" 
];


_unit setVariable ["ace_medical_lastWakeUpCheck", nil];

{
    if(count _x >= 1) then {
        _x set [1, _x#1 + CBA_missionTime];
    };
} forEach _medications;
_unit setVariable ["ace_medical_medications", _medications, true];


[_unit] call ace_medical_engine_fnc_updateDamageEffects;
[_unit] call ace_medical_status_fnc_updateWoundBloodLoss;


private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
[_unit, ace_medical_STATE_MACHINE, _currentState, _targetState] call CBA_statemachine_fnc_manualTransition;

if (_currentState in ["Unconscious", "CardiacArrest"] && {_targetState in ["Default", "Injured"]}) then {
    [_unit, false] call ace_medical_status_fnc_setUnconsciousState;
};