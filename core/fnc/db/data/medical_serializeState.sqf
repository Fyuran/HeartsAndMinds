#include "..\..\script_macros.hpp"
#include "\x\cba\addons\main\script_macros_mission.hpp"
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

#include "\z\ace\addons\medical\script_component.hpp"

params [["_unit", objNull, [objNull]]];

private _state = createHashMap;

[
    [VAR_BLOOD_VOL, DEFAULT_BLOOD_VOLUME],
    [VAR_HEART_RATE, DEFAULT_HEART_RATE],
    [VAR_BLOOD_PRESS, [80, 120]],
    [VAR_PERIPH_RES, DEFAULT_PERIPH_RES],
    // State transition should handle this
    // [VAR_CRDC_ARRST, false],
    [VAR_HEMORRHAGE, 0],
    [VAR_PAIN, 0],
    [VAR_IN_PAIN, false],
    [VAR_PAIN_SUPP, 0],
    [VAR_OPEN_WOUNDS, createHashMap],
    [VAR_BANDAGED_WOUNDS, createHashMap],
    [VAR_STITCHED_WOUNDS, createHashMap],
    [VAR_FRACTURES, DEFAULT_FRACTURE_VALUES],
    // State transition should handle this
    // [VAR_UNCON, false],
    [VAR_TOURNIQUET, DEFAULT_TOURNIQUET_VALUES],
    [QEGVAR(medical,occludedMedications), nil],
    [QEGVAR(medical,ivBags), nil],
    [QEGVAR(medical,triageLevel), 0],
    [QEGVAR(medical,triageCard), []],
    [QEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]
    // Time needs to be converted
    // [VAR_MEDICATIONS, []]
] apply {
	_x params ["_key", "_value"];
	_state set[_key, _unit getVariable _x];
};


private _medications = _unit getVariable [VAR_MEDICATIONS, []];
_medications apply {
	_x set[1, _x#1 - CBA_missionTime];
};
_state set[VAR_MEDICATIONS, _medications];


private _currentState = [_unit, GVAR(STATE_MACHINE)] call CBA_statemachine_fnc_getCurrentState;
_state set[QGVAR(statemachineState), _currentState];


_state