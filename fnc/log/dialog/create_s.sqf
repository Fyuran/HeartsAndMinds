
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create_s

Description:
    Creates vehicle with server ownership

Parameters:
    ["_class", "", [""]],
    ["_log_point", objNull, [objNull]]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create_s;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_class", "", [""]],
    ["_log_point", objNull, [objNull]],
    ["_create_obj", objNull, [objNull]],
    ["_cost", 0, [0]]
];

if(_class isEqualTo "") exitWith {
    ["_class is invalid", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _log_point) exitWith {
    ["_log_point is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _resources = _create_obj getVariable ["btc_log_resources", 0];
if(_cost > _resources) exitWith {
    [
        ["a3\ui_f\data\gui\rsc\rscdisplayarcademap\icon_exit_cross_ca.paa", 5, [1,0,0,1]], 
        [localize "STR_BTC_HAM_LOG_ACTION_INSUFFICIENT_FUNDS", 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];
}; 

private _isFobLogObj = _create_obj getVariable ["btc_log_isFobLogObj", false];
if(_isFobLogObj) then {
    [
        ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
        [format [localize "STR_BTC_HAM_LOG_ACTION_ACQUIRE", _cost], 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];
    private _payment = (_resources - _cost) max 0;
    _create_obj setVariable ["btc_log_resources", _payment, true];
    private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
    _flag setVariable ["btc_log_resources", _payment];
};

private _obj = createVehicle [_class, _log_point, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _log_point;
_pos = getPosATL _log_point;
_obj setVectorUp (surfaceNormal _pos);
_obj setPosATL _pos;

if (unitIsUAV _obj) then {
    createVehicleCrew _obj;
};

[_obj] call btc_log_fnc_init;
