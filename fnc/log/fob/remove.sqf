
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_remove

Description:
    Removes Log Obj safely

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] call btc_log_fob_fnc_remove;
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
if(!alive _create_obj) exitWith {
    ["_create_obj is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

btc_log_fob_create_objects deleteAt (btc_log_fob_create_objects find _create_obj);
publicVariable "btc_log_fob_create_objects";

(attachedObjects _create_obj) apply {deleteVehicle _x};
deleteVehicle _create_obj;

if(btc_debug) then {
    [format["removed log_obj from %1", _flag getVariable["FOB_name", "UNKNOWN"]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;  
};