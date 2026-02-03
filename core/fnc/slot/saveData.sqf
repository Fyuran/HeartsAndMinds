#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_saveData

Description:
    Server saves player data into btc_slots_serialized global var

Parameters:

Returns:

Examples:
    (begin example)
        [getPlayerUID player, player] call btc_slot_fnc_saveData;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */

if(!params [
    ["_uid", "", [""]],
    ["_player", objNull, [objNull]]

]) exitWith {
    #ifdef BTC_DEBUG_SLOT
    [["%1: bad params", __FILE_NAME__], 6, "slot"] call btc_debug_fnc_message;  
    #endif
};
if(isNull _player) then {
    _player = _uid call BIS_fnc_getUnitByUID;
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
    ["uid", _uid],
    ["name", name _player],
    ["btc_scoreboard",  _player getVariable["btc_scoreboard", createHashMap]]
];
btc_slots_serialized set [_uid, _data];


#ifdef BTC_DEBUG_SLOT
[["%1: %2(%3) saving data", __FILE_NAME__, name _player, _uid], 2, "slot"] call btc_debug_fnc_message;
#endif
[_uid, _data]