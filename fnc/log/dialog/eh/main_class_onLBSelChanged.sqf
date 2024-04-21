
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_main_class_onLBSelChanged

Description:
    Fill me when you edit me !

Parameters:
    _main_class - []
    _sub_class - []

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_main_class_onLBSelChanged;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */
params [
    ["_main_class_ctrl", controlNull, [controlNull]], 
    ["_lbCurSel", 0, [0]], //Returns the index of the selected item
    ["_lbSelection", [], [[]]] //Returns Array of selected rows indices in the given listbox
];

disableSerialization;
if(isNull _main_class_ctrl) exitWith {
    ["_main_class_ctrl is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _display = ctrlParent _main_class_ctrl;
private _sub_class_ctrl = _display displayCtrl 72;

private _create_obj = btc_log_namespace getVariable ["btc_log_create_obj", objNull];
private _isFobLogObj = _create_obj getVariable ["btc_log_isFobLogObj", false];

(btc_log_namespace getVariable ["btc_construction_array", []]) params [
    ["_main_class", [], [[]]], 
    ["_sub_class", [], [[]]]
];

private _var = _main_class_ctrl lbText _lbCurSel;
private _id = _main_class find _var;
private _category = _sub_class select _id;
lbClear _sub_class_ctrl;

_lbData = [];
_category apply {
    private _displayName = getText (configFile >> "cfgVehicles" >> _x >> "displayName");
    private _sideID = getNumber (configFile >> "cfgVehicles" >> _x >> "side");
    if (not(_x isKindOf "Thing") && {not(_x isKindOf "Building")}) then { //some camo variations
        _displayName = format["%1(%2)", _displayName, _sideID call BIS_fnc_sideType];
    };
    private _cost = 0;
    if(_isFobLogObj) then {
        private _obj = createVehicleLocal [_x, [0,0,0], [], 0, "CAN_COLLIDE"];
        //sizeOf At least one object of the given classname has to be present in the current mission otherwise zero will be returned.
        _cost = round(sizeOf _x)*2;
        _displayName = _displayName insert [-1, format[" cost: %1", _cost]];
        deleteVehicle _obj;
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
