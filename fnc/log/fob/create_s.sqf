
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_create_s

Description:
    Manages creation of logistics objects for FOBs server side

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject, getPos cursorObject] call btc_log_fob_fnc_create_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_flag", objNull, [objNull]],
    ["_pos", [0,0,0], [[]], 3],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2]
];

if(!alive _flag) exitWith {
    ["_flag is null or not alive", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

_pos set [2, 0];
private _create_obj = createVehicle [btc_log_fob_create_obj, _pos, [], 0, "CAN_COLLIDE"];
private _log_point = createVehicle ["Land_HelipadSquare_F", _pos, [], 0, "CAN_COLLIDE"];
_log_point attachTo [_create_obj, [8,8,0]];
_create_obj setVectorDirAndUp _vectorDirAndUp;

[_create_obj, -1] call ace_cargo_fnc_setSize; //-1 to disable Load in Cargo
[_create_obj, 0] call ace_cargo_fnc_setSpace;

_flag setVariable ["btc_log_create_obj", _create_obj, true];
_create_obj setVariable ["btc_log_fob_flag", _flag, true];

btc_log_fob_create_objects pushBack _create_obj;
publicVariable "btc_log_fob_create_objects";

[_create_obj, _log_point] remoteExecCall ["btc_log_fob_fnc_actions", [0, -2] select isDedicated, _create_obj];

if(btc_debug) then {
    [format["created log_obj at %1", _flag getVariable["FOB_name", "UNKNOWN"]], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;  
};

_create_obj