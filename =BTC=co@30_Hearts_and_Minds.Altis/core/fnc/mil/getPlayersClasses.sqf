
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
    [format["mission.sqm was not included in description.ext"], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

private _playerUnitsClasses = [];
private _playerUnitsFactions = [];

private _subClasses = _missionCfg call BIS_fnc_getCfgSubClasses;
_subClasses apply {
    private _isPlayable = getNumber(_missionCfg >> _x >> "Entities" >> "Item0" >> "Attributes" >> "isPlayable") isEqualTo 1;
    if(_isPlayable) then {
        _playerUnitsClasses pushBackUnique getText(_missionCfg >> _x >> "Entities" >> "Item0" >> "type");
    };
};

private _cfg = configfile >> "CfgVehicles";
_playerUnitsClasses apply {
    _playerUnitsFactions pushBackUnique getText(_cfg >> _x >> "faction");
};

([_playerUnitsFactions] call btc_mil_fnc_class) select 1;