
/* ----------------------------------------------------------------------------
Function: btc_log_dialog_fnc_createDialog

Description:
    Fill me when you edit me !

Parameters:
    _create_obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_dialog_fnc_createDialog;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_create_obj", btc_log_create_obj, [objNull]],
    ["_construction_array", btc_construction_array, [[]], 2],
    ["_log_point", btc_log_point_obj, [objNull]]
];

btc_log_dialog_namespace setVariable ["btc_log_create_obj", _create_obj];
btc_log_dialog_namespace setVariable ["btc_construction_array", _construction_array];
btc_log_dialog_namespace setVariable ["btc_log_point_obj", _log_point];

closeDialog 0;
if ([_log_point] call btc_fnc_isAreaOccupied) exitWith {};
private _display = createDialog ["btc_log_dlg_create", false];
private _main_class_ctrl = _display displayCtrl 71;
private _sub_class_ctrl = _display displayCtrl 72;
lbClear _main_class_ctrl;
lbClear _sub_class_ctrl;

private _main_class = _construction_array param[0, [], [[]]];
_main_class apply {
    _main_class_ctrl lbAdd _x;
};
_main_class_ctrl lbSetCurSel 0;