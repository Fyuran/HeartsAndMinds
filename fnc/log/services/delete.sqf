
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_delete

Description:
    Delete object created by logistic point.

Parameters:
    _log_point - Helipad where the object to delete is. [Object]

Returns:

Examples:
    (begin example)
        [btc_log_point_obj] call btc_log_fnc_delete;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_create_obj", objNull, [objNull]],
    ["_log_point", objNull, [objNull]]
];

private _blackList = [btc_log_create_obj, _create_obj];

private _array = ((nearestObjects [_log_point, flatten (btc_construction_array select 1), 10]) select {!(
    _x isKindOf "ACE_friesBase" OR
    _x isKindOf "ace_fastroping_helper"
)}) - _blackList;

if (_array isEqualTo []) exitWith {
    [
        [localize "STR_BTC_HAM_LOG_DELETE"],
        ["<img size='1' image='\z\ace\addons\arsenal\data\iconClearContainer.paa' align='center'/>"]
    ] call CBA_fnc_notify;
};

[_array select 0, _create_obj] remoteExecCall ["btc_log_fnc_server_delete", [2]];
