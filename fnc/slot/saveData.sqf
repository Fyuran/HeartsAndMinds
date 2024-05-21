
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_saveData

Description:
    Server saves player data into btc_slots_serialized global var

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_saveData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!params [
    ["_player", "", ["", objNull]]
]) exitWith {
    ["bad params", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};


private _data = createHashMapFromArray [
    ["previousPos", getPosASL _player],
    ["dir", getDir _player],
    ["loadout", getUnitLoadout _player],
    ["flagTexture", getForcedFlagTexture _player],
    ["isContaminated", _player in btc_chem_contaminated],
    ["medicalState", [_player] call btc_json_fnc_medical_serializeState],
    ["field_rations", [
        _player getVariable ["acex_field_rations_thirst", 0],
        _player getVariable ["acex_field_rations_hunger", 0]
    ]],
    ["hasEarPlugsIn", [_player] call ace_hearing_fnc_hasEarPlugsIn],
    ["uid", _uid]
];
btc_slots_serialized set [_uid, _data];


if(btc_debug) then {
    [format ["%1(%2) saving data", name _player, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
};

[_uid, _data]