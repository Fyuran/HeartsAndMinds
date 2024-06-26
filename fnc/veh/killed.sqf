
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_killed

Description:
    Create marker wreck and change reputation on vehicle destruction.

Parameters:
    _vehicle - Vehicle object. [Object]
    _killer - Killer. [Object]
    _instigator - Person who pulled the trigger. [Object]
    _useEffects - Same as useEffects in setDamage alt syntax. [Boolean]
    _allowRepChange - Allow reputation change. [Boolean]

Returns:

Examples:
    (begin example)
        [btc_veh_12] call btc_veh_fnc_killed;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_vehicle", objNull, [objNull]],
    ["_killer", objNull, [objNull]],
    ["_instigator", objNull, [objNull]],
    ["_useEffects", true, [false]],
    ["_allowRepChange", true, [false]]
];

private _marker = createMarkerLocal [format ["m_%1", _vehicle], getPos _vehicle];
_marker setMarkerTypeLocal "mil_box";
_marker setMarkerColor "ColorRed";
[_marker, "STR_BTC_HAM_O_EH_VEHKILLED_MRK", getText (configOf _vehicle >> "displayName")] remoteExecCall ["btc_fnc_set_markerTextLocal", [0, -2] select isDedicated, _marker]; // %1 wreck

_vehicle setVariable ["marker", _marker];
if (_allowRepChange) then {
    if (isServer) then {
        [_killer, _VEHICLE_LOST_] call btc_rep_fnc_change;
    } else {
        [_killer, _VEHICLE_LOST_] remoteExecCall ["btc_rep_fnc_change", 2];
    };
};
