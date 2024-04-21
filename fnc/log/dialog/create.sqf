
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create

Description:
    Fill me when you edit me !

Parameters:
    _create_obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_create_obj", btc_log_create_obj, [objNull]],
    ["_construction_array", btc_construction_array, [[]], 2],
    ["_log_point", btc_log_point_obj, [objNull]]
];

btc_log_namespace setVariable ["btc_log_create_obj", _create_obj];
btc_log_namespace setVariable ["btc_construction_array", _construction_array];
btc_log_namespace setVariable ["btc_log_point_obj", _log_point];

closeDialog 0;
if ([_log_point] call btc_fnc_checkArea) exitWith {};

disableSerialization;
closeDialog 0;
createDialog "btc_log_dlg_create";

waitUntil {dialog};

call btc_log_fnc_create_load;

private _class = lbData [72, lbCurSel 72];
private _selected = _class;
private _new = _class createVehicleLocal getPosASL _log_point;

while {dialog} do {
    if (_class != lbData [72, lbCurSel 72]) then {
        deleteVehicle _new;
        sleep 0.1;
        _class = lbData [72, lbCurSel 72];
        _selected = _class;
        _new = _class createVehicleLocal getPosASL _log_point;
        _new setDir getDir _log_point;
        _new setPosASL getPosASL _log_point;
        _new enableSimulation false;
        _new allowDamage false;
    };
    sleep 0.1;
};
deleteVehicle _new;
