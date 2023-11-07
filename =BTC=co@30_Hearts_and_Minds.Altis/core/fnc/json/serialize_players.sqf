/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_serialize_players
	
	Description:
	    Serializes the medical state of a unit and stats
	    modified to not encode into json - Fyuran
	
	Parameters:
	    0: Unit <OBJECT>
	
	Returns:
	
	Examples:
	    (begin example)
	        [player] call btc_json_fnc_serialize_players
	    (end)
	
	Author:
	    ACE3 Team, Fyuran
---------------------------------------------------------------------------- */

params [["_player", objNull, [objNull]]];

private _state = createHashMap;

{
	_x params ["_key"];
	_state set [_key, _player getVariable _x];
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
    ["ace_medical_fractures", [0, 0, 0, 0, 0, 0]],

    ["ace_medical_tourniquets", [0, 0, 0, 0, 0, 0]],
    ["ace_medical_triageLevel", 0],
    ["ace_medical_triageCard", []],
    ["ace_medical_bodyPartDamage", [0, 0, 0, 0, 0, 0]]

];

private _medications = _player getVariable ["ace_medical_medications", []];
{
    _x set [1, _x#1 - CBA_missionTime];
} forEach _medications;
_state set ["ace_medical_medications", _medications];

private _currentState = [_player, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
_state set["ace_medical_statemachineState", _currentState];

createHashMapFromArray[
    ["uid", getPlayerUID _player],
    ["pos", getPosASL _player],
    ["direction", getDir _player],
    ["loadout", getUnitLoadout _player],
    ["ForcedFlagTexture", getForcedFlagTexture _player],
    ["chem_contaminated", _player in btc_chem_contaminated],
    ["acex_field_rations", [
        _player getVariable ["acex_field_rations_thirst", 0],
        _player getVariable ["acex_field_rations_hunger", 0]
    ]],
    ["medical_status", _state]
]