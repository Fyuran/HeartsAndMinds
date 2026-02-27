#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_drone_active

Description:
    Create a trigger to allow drone to fire on player side presence.

Parameters:
    _driver_drone - Driver of the drone. [Object]

Returns:
	_trigger - Trigger to allow drone to fire on player side presence. [Object]

Examples:
    (begin example)
        _trigger = [driver] call btc_ied_fnc_drone_active;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_driver_drone", objNull, [objNull]]
];

[group _driver_drone] call CBA_fnc_clearWaypoints;

private _trigger = createTrigger ["EmptyDetector", getPos _driver_drone, false];
_trigger setTriggerArea [10, 10, 0, false, -60];
_trigger setTriggerActivation [str btc_player_side, "PRESENT", true];
_trigger setTriggerStatements ["this", "[thisTrigger] call btc_ied_fnc_drone_fire;", ""];
_trigger setVariable ["btc_ied_drone", _driver_drone];

_trigger attachTo [vehicle _driver_drone, [0, 0, 0]];

#ifdef BTC_DEBUG_IED
[["%1: _driver_drone = %2 POS %3 START LOOP", __FILE_NAME__, _driver_drone, getPos _driver_drone], 2, "ied"] call FUNC(debug,message);
#endif
(group _driver_drone) setBehaviour "CARELESS";
(group _driver_drone) setSpeedMode "LIMITED";

_trigger
