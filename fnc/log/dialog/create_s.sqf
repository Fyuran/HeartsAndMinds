
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create_s

Description:
    Fill me when you edit me !

Parameters:
    _object_type - [String]
    _pos - [Array]
    _vector - [Array]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create_s;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_object_type", "", [""]],
    ["_log_point", btc_log_namespace getVariable "btc_log_point_obj", [objNull]]
];

private _obj = _object_type createVehicle [0, 0, 0];
private _pos = getPosASL _log_point;
private _vector = surfaceNormal _pos;
_obj setVectorUp _vector;
_obj setDir getDir btc_log_point_obj;
_obj setPosASL _pos;

if (unitIsUAV _obj) then {
    createVehicleCrew _obj;
};

[_obj] call btc_log_fnc_init;
