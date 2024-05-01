
/* ----------------------------------------------------------------------------
Function: btc_log_dialog_fnc_subClass_LBSelChanged

Description:
    Manages sub class change on log create dialog

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_dialog_fnc_subClass_LBSelChanged;
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

private _log_point = btc_log_dialog_namespace getVariable ["btc_log_point_obj", objNull];
private _class = _sub_class_ctrl lbData _lbCurSel;

private _obj = btc_log_dialog_namespace getVariable ["btc_log_curSel_obj", objNull];
if(!isNull _obj) then {
    deleteVehicle _obj;
};

//avoid TFAR_antennas_fnc_initRadioTower from triggering until it's ready to be deployed
if(_class in ((btc_construction_array select 1) select 8)) then {
    private _cfg = configFile >> "CfgVehicles"; 
    private _sourceAddonList = configSourceAddonList (_cfg >> _class);

    if("tfar_antennas" in _sourceAddonList) then {
        _class = configName (inheritsFrom (_cfg >> _class)); //get the parent class it's derived from
    };
};
private _obj = createVehicleLocal [_class, _log_point, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _log_point;
_pos = getPosATL _log_point;
_pos set [2,0]; //make sure it's sitting level to ground
_obj setVectorUp (surfaceNormal _pos);
_obj setPosATL _pos;

btc_log_dialog_namespace setVariable ["btc_log_curSel_obj", _obj];
