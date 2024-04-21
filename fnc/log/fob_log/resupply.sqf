
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_resupply

Description:
    Manages resupply of logistic object

Parameters:

Returns:

Examples:
    (begin example)
        _result = [player] call btc_log_fob_fnc_resupply;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define DISTSQR 10*10

params[
    ["_target", objNull, [objNull]]
];

if(!alive _target) exitWith {
    ["_target is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _create_obj = btc_log_fob_create_objects select (btc_log_fob_create_objects findIf {(_target distanceSqr _x) <= DISTSQR});

private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
private _create_obj_resources = _create_obj getVariable ["btc_log_resources", 0];
private _resupply_resources  = _target getVariable ["btc_log_resources", 0];

// if create_obj required resources exceed supplies resources, just give back as much as it can
private _payment = (btc_log_fob_max_resources - _create_obj_resources) min _resupply_resources; 
_resupply_resources = _resupply_resources - _payment;
if(_resupply_resources <= 0) then {
    private _obj = createVehicle [btc_log_fob_create_obj_resupply#2, _target, [], 0, "CAN_COLLIDE"];
    _obj setPosATL getPosATL _target;
    [_obj, [vectorDir _target, vectorUp _target]] call btc_log_fob_fnc_resupply_init;
    btc_log_fob_supply_objects deleteAt (btc_log_fob_supply_objects find _target);
    publicVariable "btc_log_fob_supply_objects";

    _flag setVariable ["btc_log_resources", 0];

    (attachedObjects _target) apply {deleteVehicle _x};
    deleteVehicle _target;
};

_create_obj setVariable ["btc_log_resources", _create_obj_resources + _payment, true];
_target setVariable ["btc_log_resources", _resupply_resources, true];
_flag setVariable ["btc_log_resources", _create_obj_resources + _payment];

[
    ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
    [format [localize "STR_BTC_HAM_LOG_ACTION_REFUND", _payment], 1, [1,1,1,1]]
] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];