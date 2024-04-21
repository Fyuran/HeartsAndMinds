
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_sub_class_onLBSelChanged

Description:
    Manages sub class change on log create dialog

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_sub_class_onLBSelChanged;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_sub_class_ctrl", controlNull, [controlNull]], 
    ["_lbCurSel", 0, [0]], //Returns the index of the selected item
    ["_lbSelection", [], [[]]] //Returns Array of selected rows indices in the given listbox
];

disableSerialization;
if(isNull _sub_class_ctrl) exitWith {
    ["_sub_class_ctrl is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _log_point = btc_log_namespace getVariable ["btc_log_point_obj", objNull];
private _class = _sub_class_ctrl lbData _lbCurSel;

private _obj = btc_log_namespace getVariable ["btc_log_curSel_obj", objNull];
if(!isNull _obj) then {
    deleteVehicle _obj;
};

private _pos = getPosATL _log_point;
_pos set [2, 0];
private _obj = createVehicleLocal [_class, _log_point, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _log_point;
_obj setPosATL _pos;
_obj setVectorUp (surfaceNormal _pos);
_obj enableSimulation false;
_obj allowDamage false;

btc_log_namespace setVariable ["btc_log_curSel_obj", _obj];
