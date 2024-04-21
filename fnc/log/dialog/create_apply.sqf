
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create_apply

Description:
    Fill me when you edit me !

Parameters:
    _log_point - Helipad where to create the object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create_apply;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_log_point", btc_log_namespace getVariable "btc_log_point_obj", [objNull]]
];

[{
    params ["_class", "_log_point"];

    if (_class isEqualTo btc_supplies_cargo) then {
        btc_supplies_mat params ["_food", "_water"];
        private _position_world = getPosWorld _log_point;
        _position_world params ["_xx", "_yy", "_zz"];
        [[
            btc_supplies_cargo,
            [_xx, _yy, _zz + 1.5], getDir _log_point,
            "",
            [selectRandom _food, selectRandom _water] apply {[_x, "", []]},
            [],
            [vectorDir _log_point, vectorUp _log_point]
        ]] remoteExecCall ["btc_db_fnc_loadObjectStatus", 2];
    } else {
        [_class, getPosASL _log_point] remoteExecCall ["btc_log_fnc_create_s", 2];
    };
}, [lbData [72, lbCurSel 72], _log_point], 0.2] call CBA_fnc_waitAndExecute;

closeDialog 0;
