#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_create_static

Description:
    Create a static.

Parameters:
    _pos - Position of creation. [Array]
    _statics_type - Type of static available. [Array]
    _dir - Direction of the static. [Number]
    _surfaceNormal - Surface normal. [Array]
    _city - City where the static is created. [Object]

Returns:
    _group - Created group. [Object]

Examples:
    (begin example)
        _group = [getPosATL player] call btc_mil_fnc_create_static;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_pos", [0, 0, 0], [[]]],
    ["_statics_type", btc_type_mg, [[]]],
    ["_dir", 0, [0]],
    ["_surfaceNormal", [], [[]]],
    ["_city", objNull, [objNull]]
];

private _group = createGroup btc_enemy_side;
_group setVariable ["btc_city", _city];
[_group] call CBA_fnc_clearWaypoints;
[_group, _pos, selectRandom _statics_type, _dir, _surfaceNormal] call FUNC(mil,createVehicle);

_group setBehaviour "COMBAT";
_group setCombatMode "RED";

#ifdef BTC_DEBUG_MIL
[["%1: POS %2", __FILE_NAME__, _pos], 2, "mil"] call FUNC(debug,message);
#endif
_group
