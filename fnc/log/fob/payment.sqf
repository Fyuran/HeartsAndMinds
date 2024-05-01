
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_payment

Description:
    Manages payment of resources on create_s obj

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fob_fnc_payment;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_create_obj", objNull, [objNull]],
    ["_cost", 0, [0]]
];

private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(isNull _flag) exitWith {
    ["_flag is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _resources = _flag getVariable ["btc_log_resources", -1];
if(_cost > _resources) exitWith {
    [
        ["a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_exit_cross_ca.paa", 5, [1,0,0,1]], 
        [localize "STR_BTC_HAM_LOG_ACTION_INSUFFICIENT_FUNDS", 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];
    false
}; 

private _payment = (_resources - _cost) max 0;
_flag setVariable ["btc_log_resources", _payment, true];

[
    ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
    [format [localize "STR_BTC_HAM_LOG_ACTION_ACQUIRE", _cost], 1, [1,1,1,1]]
] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];

if(btc_debug) then {
    [format["paid %1 from %2", _payment, _flag getVariable["FOB_name", "UNKNOWN"]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;  
};

true