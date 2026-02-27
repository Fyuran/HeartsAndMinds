#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_killed

Description:
    Change reputation when a player kill a unit.

Parameters:
    _unit - Unit killed. [Object]
    _killer - Killer. [Object]

Returns:

Examples:
    (begin example)
        [cursorObject, player] call btc_rep_fnc_killed;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params ["_unit", "_causeOfDeath", "_killer", "_instigator"];

if (
    (side group _unit isNotEqualTo civilian) &&
    {!isAgent teamMember _unit}
) exitWith {};

if (
    isPlayer _instigator ||
    _killer isEqualTo btc_explosives_objectSide ||
    isPlayer _killer
) then {
    private _isAgent = isAgent teamMember _unit;
    if (isNull _instigator && isPlayer _killer) then {
        _instigator = _killer;
    };
    [
        _instigator,
        [_CIV_KILLED_, _ANIMAL_KILLED_] select _isAgent
    ] call FUNC(rep,change);
    if (btc_global_reputation < btc_rep_level_normal + 100) then {
        [getPos _unit] call FUNC(rep,eh_effects);
    };

    if !(_isAgent) then {
        private _city = (group _unit) getVariable ["btc_city", objNull];
        if !(isNull _city) then {
            private _civKilled = _city getVariable ["btc_rep_civKilled", []];
            _civKilled pushBack [getPosASL _unit, getDir _unit];
            _city setVariable ["btc_rep_civKilled", _civKilled];
        };
    };

    #ifdef BTC_DEBUG_REP
    [["%1: GREP %2 THIS = %3", __FILE_NAME__, btc_global_reputation, _this], 2, "rep"] call FUNC(debug,message);
    #endif
};
