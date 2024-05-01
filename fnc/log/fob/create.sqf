
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_create

Description:
    Manages creation of logistics objects for FOBs on client side via a vehicleLocal

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] spawn btc_log_fob_fnc_create;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_flag", objNull, [objNull]]
];

if(!alive _flag) exitWith {
    ["_flag is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(!canSuspend) exitWith {
    ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _create_obj = createVehicleLocal [btc_log_fob_create_obj, [0,0,0], [], 0, "CAN_COLLIDE"];
private _log_point = createVehicleLocal ["Land_HelipadSquare_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_log_point attachTo [_create_obj, [8,8,0]];

private _eyeDir = eyeDirection player;
private _pos_ATL = getPosATL _create_obj;
_create_obj setPosATL (_pos_ATL vectorAdd (_eyeDir vectorMultiply 2));

[_create_obj] call btc_log_fnc_place;

waitUntil {!btc_log_placing};

[_flag, getPosATL _create_obj, [vectorDir _create_obj, vectorUp _create_obj]] remoteExecCall ["btc_log_fob_fnc_create_s", [0, 2] select isMultiplayer];

(attachedObjects _create_obj) apply {deleteVehicle _x};
(attachedObjects _log_point) apply {deleteVehicle _x};
deleteVehicle _create_obj;