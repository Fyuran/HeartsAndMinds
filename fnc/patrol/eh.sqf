#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_patrol_fnc_eh

Description:
    Remove events and delete entity.

Parameters:
    _veh - Object to delete. [Object, Group]

Returns:

Examples:
    (begin example)
        [cursorTarget] call btc_patrol_fnc_eh;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_veh", objNull, [objNull, grpNull]]
];

if (_veh getVariable ["btc_patrol_fnc_eh_fired", false]) exitWith {};
_veh setVariable ["btc_patrol_fnc_eh_fired", true, true];

#ifdef BTC_DEBUG_PATROL
[["%1: %2, isRE %3", __FILE_NAME__, _veh, isRemoteExecuted], 2, "patrol"] call btc_debug_fnc_message;
#endif
private _group = if (_veh isEqualType grpNull) then {
    _veh
} else {
    _veh getVariable ["btc_crews", grpNull]
};

if !(
    _group in btc_patrol_active ||
    _group in btc_civ_veh_active
) exitWith {};

if (_veh isEqualType objNull) then {
    #ifdef BTC_DEBUG_PATROL
    deleteMarker format ["Patrol_fant_%1", _group getVariable ["btc_patrol_id", 0]];
    #endif
    [[], [_veh, _group]] call btc_fnc_delete;
} else {
    private _vehicle = assignedVehicle leader _veh;
    _vehicle setVariable ["btc_patrol_fnc_eh_fired", true, true];
    [[], [_vehicle, _veh]] call btc_fnc_delete;
};
