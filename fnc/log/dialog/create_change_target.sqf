
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create_change_target

Description:
    Fill me when you edit me !

Parameters:
    _main_class - []
    _sub_class - []

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create_change_target;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

private _var = lbText [71, lbCurSel 71];
_construction_array = btc_log_namespace getVariable "btc_construction_array";
_construction_array params ["_main_class", "_sub_class"];
private _id = _main_class find _var;
private _category = _sub_class select _id;
lbClear 72;
for "_i" from 0 to ((count _category) - 1) do {
    private _class = _category select _i;
    private _display = getText (configFile >> "cfgVehicles" >> _class >> "displayName");
    private _sideID = getNumber (configFile >> "cfgVehicles" >> _class >> "side");
    if (not(_class isKindOf "Thing") && {not(_class isKindOf "Building")}) then { //some camo variations
        _display = format["%1(%2)", _display, _sideID call BIS_fnc_sideType];
    };
    private _index = lbAdd [72, _display];
    lbSetData [72, _index, _class];
    if (_i isEqualTo 0) then {lbSetCurSel [72, _index];};
};
