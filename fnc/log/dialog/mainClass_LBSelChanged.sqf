
/* ----------------------------------------------------------------------------
Function: btc_log_dialog_fnc_mainClass_LBSelChanged

Description:
    Fill me when you edit me !

Parameters:
    _main_classes - []
    _sub_classes - []

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_dialog_fnc_mainClass_LBSelChanged;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */
params [
    ["_main_class_ctrl", controlNull, [controlNull]], 
    ["_lbCurSel", 0, [0]], //Returns the index of the selected item
    ["_lbSelection", [], [[]]] //Returns Array of selected rows indices in the given listbox
];
if(!canSuspend) exitWith {
    ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

[{//retrieve tables
    remoteExecutedOwner publicVariableClient "btc_log_dialog_tables";
}] remoteExecCall ["call", [0, 2] select isMultiplayer];
waitUntil {!isNil "btc_log_dialog_tables"};

disableSerialization;
if(isNull _main_class_ctrl) exitWith {
    ["_main_class_ctrl is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _display = ctrlParent _main_class_ctrl;
private _sub_class_ctrl = _display displayCtrl 72;

private _create_obj = btc_log_dialog_namespace getVariable ["btc_log_create_obj", objNull];
(btc_log_dialog_namespace getVariable ["btc_construction_array", []]) params [
    ["_main_classes", [], [[]]], 
    ["_sub_classes", [], [[]]]
];

private _var = _main_class_ctrl lbText _lbCurSel;
private _id = _main_classes find _var;
private _category = _sub_classes select _id;
lbClear _sub_class_ctrl;

private _lbData = [];
_category apply {
    (btc_log_dialog_tables getOrDefault [_x, ["nil", -1]]) params ["_displayName", "_cost"];
    if(_create_obj in btc_log_fob_create_objects) then {
        _displayName = _displayName insert [-1, format[" cost: %1", _cost]];
    };
    _lbData pushBackUnique [_displayName, _x, _cost];
};

_lbData apply {
    _x params ["_displayName", "_class", "_cost"];
    private _i = _sub_class_ctrl lbAdd _displayName;
    _sub_class_ctrl lbSetData [_i, _class];
    _sub_class_ctrl lbSetValue [_i, _cost];
};
_sub_class_ctrl lbSetCurSel 0
