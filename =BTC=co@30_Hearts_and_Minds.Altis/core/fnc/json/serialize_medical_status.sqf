 
 /* ----------------------------------------------------------------------------
Function: btc_json_fnc_serialize_medical_status

Description:
    Serializes the medical state of a unit into a string.

    modified to not encode into json - Fyuran

Parameters:
    0: Unit <OBJECT>

Returns:

Examples:
    (begin example)
        [player] call btc_json_fnc_serialize_medical_status
    (end)

Author:
    ACE3 Team
---------------------------------------------------------------------------- */

params [["_unit", objNull, [objNull]]];

private _state = createHashMap;


{
    _x params ["_key"];
    _state set [_key, _unit getVariable _x];
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
    ["ace_medical_occludedMedications", 0],
    ["ace_medical_ivBags", 0],
    ["ace_medical_triageLevel", 0],
    ["ace_medical_triageCard", []],
    ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]
    
];


private _medications = _unit getVariable ["ace_medical_medications", []];
{
    _x set [1, _x#1 - CBA_missionTime];
} forEach _medications;
_state set ["ace_medical_medications", _medications];


private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
_state set["ace_medical_statemachineState", _currentState];

_state
