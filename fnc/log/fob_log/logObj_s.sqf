
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_createLogObj_s

Description:
    Manages creation of logistics objects for FOBs server side

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject, getPos cursorObject] call btc_log_fob_fnc_createLogObj_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_flag", objNull, [objNull]],
    ["_pos", [0,0,0], [[]], 3],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2],
    ["_resources", btc_log_fob_max_resources, [0]]
];

if(!alive _flag) exitWith {
    ["_flag is null or not alive", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

_pos set [2, 0];
private _create_obj = createVehicle [btc_log_fob_create_obj, [0,0,0], [], 0, "CAN_COLLIDE"];
private _log_point = createVehicle ["Land_HelipadSquare_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_log_point attachTo [_create_obj, [8,8,0]];
_create_obj setVectorDirAndUp _vectorDirAndUp;
_create_obj setPos _pos;

_create_obj allowDamage false;
_log_point allowDamage false;
_create_obj enableSimulationGlobal false;

_create_obj setVariable ["btc_log_point_obj", _log_point];
_create_obj setVariable ["btc_log_isFobLogObj", true, true];

private _flag_resources = _flag getVariable ["btc_log_resources", -1]; //sync the fob resources to its create_obj
if(_flag_resources isNotEqualTo -1) then {
    _resources = _flag_resources;
};
_create_obj setVariable ["btc_log_resources", _resources, true];
[_create_obj, -1] call ace_cargo_fnc_setSize; //-1 to disable Load in Cargo
[_create_obj, 0] call ace_cargo_fnc_setSpace;

//flag
_flag setVariable ["btc_log_create_obj", _create_obj, true];
_create_obj setVariable ["btc_log_fob_flag", _flag];

btc_log_fob_create_objects pushBack _create_obj;
publicVariable "btc_log_fob_create_objects";

[_create_obj, _log_point] remoteExecCall ["btc_log_fob_fnc_logObjActions", [0, -2] select isDedicated, _create_obj];


[_create_obj, _log_point]