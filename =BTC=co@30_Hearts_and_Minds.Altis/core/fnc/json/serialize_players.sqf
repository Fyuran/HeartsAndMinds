
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_serialize_players

Description:
    Serialize player slot.

Parameters:
    _player - Unit. [Object]

Returns:

Examples:
    (begin example)
        [allPlayers#0] call btc_json_fnc_serialize_players;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [ 
    ["_player", objNull, [objNull]] 
]; 
 
["uid", "pos", "direction", "loadout",   
        "ForcedFlagTexture", "btc_chem_contaminated", "vehicle",   
            "acex_field_rations"] createHashMapFromArray [ 
    getPlayerUID _player, 
    getPosASL _player, 
    getDir _player, 
    [getUnitLoadout _player, []], 
    getForcedFlagTexture _player, 
    _player in btc_chem_contaminated, 
    typeOf objectParent _player, 
    [ 
        _player getVariable ["acex_field_rations_thirst", 0], 
        _player getVariable ["acex_field_rations_hunger", 0] 
    ],
    [_player] call btc_json_fnc_serialize_medical_status
]; 
