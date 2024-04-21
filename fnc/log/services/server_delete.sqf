
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_server_delete

Description:
    Delete object created by logistic point.

Parameters:
    _obj - Object to delete. [Object]
    _allowlist - Item can be deleted. [Array]

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_log_fnc_server_delete;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_obj", objNull, [objNull]],
    ["_create_obj", objNull, [objNull]]
];

private _allowlist = btc_log_obj_created + btc_log_fob_supply_objects;
if !(_obj in _allowlist) exitWith {
    [17] remoteExecCall ["btc_fnc_show_hint", remoteExecutedOwner];
};

private _isFobLogObj = _create_obj getVariable ["btc_log_isFobLogObj", false];
if(_isFobLogObj) then {
    _resources = _create_obj getVariable ["btc_log_resources", 0];

    private _class = typeOf _obj;
    private _cost = round(sizeOf _class)*2;
    [
        ["a3\ui_f\data\igui\rscingameui\rscunitinfoairrtdfull\ico_insp_ok_3_ca.paa", 5, [0,1,0,1]], 
        [format [localize "STR_BTC_HAM_LOG_ACTION_REFUND", _cost], 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];

    private _payment = (_resources + _cost) min btc_log_fob_max_resources;
    _create_obj setVariable ["btc_log_resources", _payment, true];
    private _flag = _create_obj getVariable ["btc_log_fob_flag", objNull];
    _flag setVariable ["btc_log_resources", _payment];
};

(attachedObjects _obj) apply {deleteVehicle _x};
[_obj getVariable ["ace_cargo_loaded", []], _allowlist deleteAt (_allowlist find _obj)] call CBA_fnc_deleteEntity;
