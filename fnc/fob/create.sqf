
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_create

Description:
    Create user interface for FOB creation.

Parameters:
    _mat - Object "containing" the FOB. [Object]

Returns:

Examples:
    (begin example)
        [cursorObject] spawn btc_fob_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_mat", objNull, [objNull]]
];

if(!canSuspend) exitWith {
    if(btc_debug) then {
        ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

//if (((position _mat) isFlatEmpty [1, 0, 0.9, 1, 0, false, _mat]) isEqualTo []) exitWith {(localize "STR_BTC_HAM_O_FOB_CREATE_H_AREA") call CBA_fnc_notify;};

if (_mat inArea [getMarkerPos "btc_base", btc_fob_minDistance, btc_fob_minDistance, 0, false]) exitWith {(localize "STR_BTC_HAM_O_FOB_CREATE_H_DBASE") call CBA_fnc_notify;};

if ((nearestObjects [position _mat, ["LandVehicle", "Air"], 10]) findIf {!(_x isKindOf "ace_fastroping_helper")} != -1) exitWith {
    (format [localize "STR_BTC_HAM_O_FOB_CREATE_H_CAREA", (nearestObjects [position _mat, ["LandVehicle", "Air"], 10]) apply {typeOf _x}]) call CBA_fnc_notify
};

closeDialog 0;

btc_fob_dlg = false;

createDialog "btc_fob_create";

waitUntil {dialog};

while {!btc_fob_dlg} do {
    if !(dialog) then {
        (localize "STR_BTC_HAM_O_FOB_CREATE_H_ESC") call CBA_fnc_notify;
        createDialog "btc_fob_create";
    };
    sleep 0.1;
};

if (ctrlText 777 == "") exitWith {
    closeDialog 0;
    (localize "STR_BTC_HAM_O_FOB_CREATE_H_NAME") call CBA_fnc_notify;
    _mat spawn btc_fob_fnc_create;
};

private _name = ctrlText 777;
private _hasFOBinString = ["FOB", _name, false] call BIS_fnc_inString;
if (!_hasFOBinString) then {
    _name = "FOB " + _name;
};

private _name_to_check = toUpper _name;
private _array_markers = allMapMarkers apply {toUpper _x};

if (_name_to_check in _array_markers) exitWith {
    closeDialog 0;
    (localize "STR_BTC_HAM_O_FOB_CREATE_H_NAMENOTA") call CBA_fnc_notify;
    _mat spawn btc_fob_fnc_create;
};

//(localize "STR_BTC_HAM_O_FOB_CREATE_H_WIP") call CBA_fnc_notify;

closeDialog 0;

if (isNull _mat) exitWith {};
deleteVehicle _mat;

private _building = createVehicleLocal[btc_fob_structure, getPosATL _mat, [], 0, "CAN_COLLIDE"];

[_building] call btc_log_fnc_place;
waitUntil {!btc_log_placing};

private _pos = getPosATL _building;
private _direction = direction _building;
deleteVehicle _building;

[_pos, _direction, _name] remoteExecCall ["btc_fob_fnc_create_s", 2];
[7, _name] remoteExecCall ["btc_fnc_show_hint", [0, -2] select isDedicated];