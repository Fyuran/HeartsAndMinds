/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_medical_serializeState
	
	Description:
	    Serializes ace medical state into a simple array
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [ace_player] call btc_json_fnc_medical_serializeState;
	    (end)
	
	Author: BaerMitUmlaut, Fyuran
	
---------------------------------------------------------------------------- */

params [["_unit", objNull, [objNull]]];

private _state = [];
private _vars = [];
[
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
    ["ace_medical_occludedMedications", []],
    ["ace_medical_ivBags", []],
    ["ace_medical_triageLevel", 0],
    ["ace_medical_triageCard", []],
    ["ace_medical_bodyPartDamage", [0,0,0,0,0,0]]
    
    
] apply {
    _x params ["_var"];
    private _var = _unit getVariable _x;
    if(_var isEqualType createHashMap) then {
        _var = _var toArray false;
    };
    _vars pushBack _var;
};
_state pushBack _vars;

private _medications = _unit getVariable ["ace_medical_medications", []];
_medications apply {
    if(count _x >= 1) then {
        _x set [1, _x#1 - CBA_missionTime];
    };
};
_state pushBack [_medications];


private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
_state pushBack _currentState;

_state
