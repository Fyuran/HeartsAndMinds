
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_delete

Description:
    Delete object created by logistic point.

Parameters:
    _obj - Object to delete. [Object]
    _whiteList - Item can be deleted. [Array]

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_log_fnc_delete;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_create_obj", objNull, [objNull]],
    ["_log_point", objNull, [objNull]]
];

if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _log_point) exitWith {
    ["_log_point is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _whiteList = btc_log_obj_created + btc_log_fob_supply_objects;
private _blackList = [btc_log_create_obj, _create_obj];

private _array = nearestObjects [_log_point, flatten (btc_construction_array select 1), 10] select {
    if !(_x in _whiteList) exitWith {
        [17] remoteExecCall ["btc_fnc_show_hint", remoteExecutedOwner];
        false
    };
    true
};
_array = _array - _blackList;

if (_array isEqualTo []) exitWith {
    [
        [localize "STR_BTC_HAM_LOG_DELETE"],
        ["<img size='1' image='\z\ace\addons\arsenal\data\iconClearContainer.paa' align='center'/>"]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];
};

private _obj = _array#0; //delete first object found
if(_create_obj in btc_log_fob_create_objects) then {
    [_create_obj, _obj] call btc_log_fob_fnc_refund;
};

[_obj getVariable ["ace_cargo_loaded", []], attachedObjects _obj, _obj] call CBA_fnc_deleteEntity;
