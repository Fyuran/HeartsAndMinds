
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

_vehicle = _array select 0; // add various check

_vehicle setdamage 0;
_vehicle setFuel 1;
_vehicle setVehicleAmmoDef 1; // works for local turret -> check and execute where's local?