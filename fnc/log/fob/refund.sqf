
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_refund

Description:
    Manages refund of resources on delete obj

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fob_fnc_refund;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_create_obj", objNull, [objNull]],
    ["_obj", objNull, [objNull]]
];

private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(isNull _obj) exitWith {
    ["_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(isNull _flag) exitWith {
    ["_flag is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _resources = _flag getVariable ["btc_log_resources", -1];
private _tables = missionNamespace getVariable ["btc_log_dialog_tables", createHashMap];
private _cost = (_tables getOrDefault [typeOf _obj, ["nil", -1], true]) select 1;
[
    ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
    [format [localize "STR_BTC_HAM_LOG_ACTION_REFUND", _cost], 1, [1,1,1,1]]
] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];

private _payment = (_resources + _cost) min btc_log_fob_max_resources;
_flag setVariable ["btc_log_resources", _payment, true];

if(btc_debug) then {
    [format["refunded %1 to %2", _payment, _flag getVariable["FOB_name", "UNKNOWN"]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;  
};