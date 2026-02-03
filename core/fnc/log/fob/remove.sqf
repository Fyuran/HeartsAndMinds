#include "..\..\script_macros.hpp"
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
    =BTC= Fyuran

---------------------------------------------------------------------------- */

params[
    ["_flag", objNull, [objNull]]
];

if(!alive _flag) exitWith {
    #ifdef BTC_DEBUG_LOG
    [["%1: _flag is null or not alive", __FILE_NAME__], 6, "log/fob"] call btc_debug_fnc_message;  
    #endif
};

private _create_obj = _flag getVariable ["btc_log_create_obj", objNull];
if(!alive _create_obj) exitWith {
    #ifdef BTC_DEBUG_LOG
    [["%1: _create_obj is null or not alive", __FILE_NAME__], 6, "log/fob"] call btc_debug_fnc_message;  
    #endif
};

btc_log_fob_create_objects deleteAt (btc_log_fob_create_objects find _create_obj);
publicVariable "btc_log_fob_create_objects";

(attachedObjects _create_obj) apply {deleteVehicle _x};
deleteVehicle _create_obj;

#ifdef BTC_DEBUG_LOG
[["%1: removed log_obj from %2", __FILE_NAME__, _flag getVariable["FOB_name", "UNKNOWN"]], 2, "log/fob"] call btc_debug_fnc_message;  
#endif