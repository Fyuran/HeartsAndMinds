
/* ----------------------------------------------------------------------------
Function: btc_body_fnc_createMarker

Description:
    Create a KIA marker on dead body.

Parameters:
    _deadBody - Dead body. [Object]

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_body_fnc_createMarker;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit) exitwith {};

private _marker = createMarkerLocal [
    format ["btc_body_dead_%1", {"btc_body_dead" in _x} count allMapMarkers],
    _unit
];
_marker setMarkerTypeLocal "KIA";
_marker setMarkerSizeLocal [0.5, 0.5];
_marker setMarkerAlpha 0.5;
_unit setVariable ["btc_body_deadMarker", _marker];
