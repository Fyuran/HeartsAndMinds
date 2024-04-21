
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_logObjRemove_s

Description:
    Removes Log Obj safely

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] call btc_log_fob_fnc_logObjRemove_s;
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

private _create_obj = _flag getVariable ["btc_log_create_obj", objNull];
private _resources = _create_obj getVariable ["btc_log_resources", 0];
_flag setVariable ["btc_log_resources", _resources];

private _log_point = _create_obj getVariable ["btc_log_point_obj", objNull];
if(!alive _create_obj) exitWith {
    ["_create_obj is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

//for drawIcon3D
btc_log_fob_create_objects deleteAt (btc_log_fob_create_objects find _create_obj);
publicVariable "btc_log_fob_create_objects";

deleteVehicle _create_obj;
deleteVehicle _log_point;