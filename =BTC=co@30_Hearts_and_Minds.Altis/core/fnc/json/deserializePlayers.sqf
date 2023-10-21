
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_deserializePlayers

Description:
    Serialize player slot.

Parameters:
    _player - Unit. [Object]

Returns:

Examples:
    (begin example)
        [allPlayers#0] call btc_json_fnc_deserializePlayers;
    (end)

Author:
    BaerMitUmlaut ACE3

---------------------------------------------------------------------------- */
             
params [
	["_state", createHashMap, [createHashMap]],
	["_unit", objNull, [objNull]]
];

if (isNull _unit) exitWith {};
if (!local _unit) exitWith { diag_log text format ["[%1] (%2) %3: %4", toUpper "ace", "medical", "ERROR", format["unit [%1] is not local", _unit]] };


if !(_unit getVariable ["ace_medical_initialized", false]) exitWith {
    ["ace_medical_status_initialized", {
        params ["_unit"];
        _thisArgs params ["_target"];

        if (_unit == _target) then {
            _thisArgs call ace_medical_fnc_deserializeState;
            [_thisType, _thisId] call CBA_fnc_removeEventHandler;
        };
    }, _this] call CBA_fnc_addEventHandlerArgs;
};

{
    if ((_state getVariable [_x, createHashMap]) isEqualType []) then {
        private _migratedWounds = createHashMap;

        {
            _x params ["_class", "_bodyPartIndex", "_amountOf", "_bleeding", "_damage"];

            private _partWounds = _migratedWounds getOrDefault [["head", "body", "leftarm", "rightarm", "leftleg", "rightleg"] select _bodyPartIndex, [], true];
            _partWounds pushBack [_class, _amountOf, _bleeding, _damage];
        } forEach (_state getVariable _x);

        _state setVariable [_x, _migratedWounds];
    };
} forEach ["ace_medical_openWounds", "ace_medical_bandagedWounds", "ace_medical_stitchedWounds"];


{
    _x params ["_var", "_default"];
    private _value = _state getVariable _x;

    
    if (typeName _value == "LOCATION") then {
        private _keys = allVariables _value;
        private _values = _keys apply {_value getVariable _x};
        _value = _keys createHashMapFromArray _values;
    };

    
    if (_value isEqualTo objNull) then {
        _value = _default;
    };

    _unit setVariable [_var, _value, true];
} forEach [
    ["ace_medical_bloodVolume", 6.0 ],
    ["ace_medical_heartRate", 80],
    ["ace_medical_bloodPressure", [80, 120]],
    ["ace_medical_peripheralResistance", 100],
    
    
    ["ace_medical_hemorrhage", 0],
    ["ace_medical_pain", 0],
    ["ace_medical_inPain", false],
    ["ace_medical_painSuppress", 0],
    ["ace_medical_openWounds", createHashMap],
    ["ace_medical_bandagedWounds", createHashMap],
    ["ace_medical_stitchedWounds", createHashMap],
    ["ace_medical_fractures", [0,0,0,0,0,0]],
    
    
    ["ace_medical_tourniquets", [0,0,0,0,0,0]],
    ["ace_medical_occludedMedications", nil],
    ["ace_medical_ivBags", nil],
    ["ace_medical_triageLevel", 0],
    ["ace_medical_triageCard", []],
    ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]
    
    
];


_unit setVariable ["ace_medical_lastWakeUpCheck", nil];


private _medications = _state getVariable ["ace_medical_medications", []];
{
    _x set [1, _x#1 + CBA_missionTime];
} forEach _medications;
_unit setVariable ["ace_medical_medications", _medications, true];


[_unit] call ace_medical_engine_fnc_updateDamageEffects;
[_unit] call ace_medical_status_fnc_updateWoundBloodLoss;


private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
private _targetState = _state getVariable ["ace_medical_statemachineState", "Default"];
[_unit, ace_medical_STATE_MACHINE, _currentState, _targetState] call CBA_statemachine_fnc_manualTransition;


if (_currentState in ["Unconscious", "CardiacArrest"] && {_targetState in ["Default", "Injured"]}) then {
    [_unit, false] call ace_medical_status_fnc_setUnconsciousState;
};

_state