
/* ----------------------------------------------------------------------------
Function: btc_log_resupply_fnc_doResupply

Description:
    Manages resupply of logistic object

Parameters:

Returns:

Examples:
    (begin example)
        _result = [player] call btc_log_resupply_fnc_doResupply;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define _DIST_ 10

params[
    ["_supply", objNull, [objNull]]
];

if(!alive _supply) exitWith {
    ["_supply is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _index = btc_log_fob_create_objects findIf {(_supply distance _x) <= _DIST_};
if(_index isEqualTo -1) exitWith {};
private _create_obj = btc_log_fob_create_objects select _index;

private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
private _resupply_resources = _supply getVariable ["btc_log_resources", -1];
private _fob_resources = _flag getVariable ["btc_log_resources", -1];

// if create_obj required resources exceed supplies resources, just give back as much as it can
private _payment = (btc_log_fob_max_resources - _fob_resources) min _resupply_resources; 
if((_resupply_resources - _payment) <= 0) then {
    private _obj = createVehicle [btc_log_fob_create_obj_resupply#2, _supply, [], 0, "CAN_COLLIDE"];
    _obj setPosATL getPosATL _supply;
    _obj setDir getDir _supply;
    btc_log_fob_supply_objects deleteAt (btc_log_fob_supply_objects find _supply);
    publicVariable "btc_log_fob_supply_objects";

    [_obj, {
        params["_obj"];  
          
        //discard
        _action = ["btc_log_resupply_discard", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY_DISCARD", "DBUG\pictures\reload.paa", {
            [_target] remoteExecCall ["btc_log_resupply_fnc_delete", [0, 2] select isMultiplayer];
        }, {
            (btc_log_fob_create_objects findIf {(_target distance _x) <= _DIST_}) != -1
        }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
        [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    }] remoteExecCall ["call", [0, -2] select isDedicated, _obj];

    (attachedObjects _supply) apply {deleteVehicle _x};
    deleteVehicle _supply;
};

if(!isNull _supply) then { //avoid useless broadcast
    _supply setVariable ["btc_log_resources", _resupply_resources - _payment, true];
};
_flag setVariable ["btc_log_resources", _fob_resources + _payment, true];

[
    ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
    [format [localize "STR_BTC_HAM_LOG_ACTION_REFUND", _payment], 1, [1,1,1,1]]
] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];

if(btc_debug) then {
    [format["%1 resupplied to %2", _payment, _flag getVariable["FOB_name", "UNKNOWN"]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;  
};