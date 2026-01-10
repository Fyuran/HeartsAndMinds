#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_getPlayersClasses

Description:
    Retrieves all player units unique factions from mission.sqm

Parameters:
    _unit - Unit. [Object]

Returns:

Examples:
    (begin example)
        [] call btc_mil_fnc_getPlayersClasses;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
private _missionCfg = (missionconfigfile >> "mission" >> "Mission" >> "Entities");
if(!isClass _missionCfg) exitWith {
    #ifdef BTC_DEBUG_MIL
    [["%1: mission.sqm was not included in description.ext", __FILE_NAME__], 6, "mil"] call btc_debug_fnc_message;
    #endif
};

private _playerUnitsClasses = [];
private _playerUnitsFactions = [];

private _subClasses = _missionCfg call BIS_fnc_getCfgSubClasses;
_subClasses apply {
    private _isPlayable = getNumber(_missionCfg >> _x >> "Entities" >> "Item0" >> "Attributes" >> "isPlayable") isEqualTo 1;
    private _isPlayerSide = [getText(_missionCfg >> _x >> "side"), str btc_player_side, false] call BIS_fnc_inString;
    if(_isPlayable && {_isPlayerSide}) then {
        _playerUnitsClasses pushBackUnique getText(_missionCfg >> _x >> "Entities" >> "Item0" >> "type");
    };
};

private _cfg = configfile >> "CfgVehicles";
_playerUnitsClasses apply {
    _playerUnitsFactions pushBackUnique getText(_cfg >> _x >> "faction");
};

([_playerUnitsFactions] call btc_mil_fnc_class) select 1;