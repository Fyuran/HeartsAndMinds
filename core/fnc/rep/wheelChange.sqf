#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_wheelChange

Description:
    Change reputation when a player change a wheel of a civilian car.

Parameters:
    _object - Vehicle. [Object]
    _hitPoint - Hitpoint. [String]
    _damage - Damage value. [Number]

Returns:

Examples:
    (begin example)
        [cursorObject, "", 1] call btc_rep_fnc_wheelChange;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    "_object",
    "_hitPoint",
    "_damage"
];

if (
    _damage < 1 ||
    {_object in btc_veh_respawnable} ||
    {_object in btc_vehicles} ||
    {getNumber(configOf _object >> "side") isNotEqualTo 3}
) exitWith {};

private _instigator = nearestObject [_object, btc_player_type];
[
    _instigator,
    _CIV_WHEEL_CHANGED_
] call FUNC(rep,change);

#ifdef BTC_DEBUG_REP
[["%1: THIS = %2 _instigator = %3", __FILE_NAME__, _this, _instigator], 2, "rep"] call FUNC(debug,message);
#endif