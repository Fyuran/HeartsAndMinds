
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_restoreVehicle

Description:
    Fill me when you edit me !

Parameters:
    _object - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_restoreVehicle;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_object", objNull, [objNull]]
];

private _array = (nearestObjects [_object, ["LandVehicle", "Air", "Ship"], 10]) select {!(
    _x isKindOf "ACE_friesBase" OR
    _x isKindOf "ace_fastroping_helper"
)};

if (_array isEqualTo []) exitWith {"No vehicles found nearby" call CBA_fnc_notify;};

private _vehicle = [_array, _object] call BIS_fnc_nearestPosition; // Function to find the nearest Object from a list.

[objNull, _vehicle] call ace_rearm_fnc_rearmEntireVehicleSuccess; //first arg is supposed to be an existing ammoSource such as an ammo truck
_vehicle setdamage 0;
_vehicle setFuel 1;