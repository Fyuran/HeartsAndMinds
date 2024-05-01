
/* ----------------------------------------------------------------------------
Function: btc_log_dialog_fnc_apply

Description:

Parameters:
    _log_point - Helipad where to create the object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_dialog_fnc_apply;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

private _create_obj = btc_log_dialog_namespace getVariable ["btc_log_create_obj", objNull];
private _log_point = btc_log_dialog_namespace getVariable ["btc_log_point_obj", objNull];

if(isNull _log_point) exitWith {
    ["_log_point is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _obj = btc_log_dialog_namespace getVariable ["btc_log_curSel_obj", objNull];
if(!isNull _obj) then {
    deleteVehicle _obj;
};

[{
    params [
        ["_lbData", [], [[]], 2], 
        ["_create_obj", objNull, [objNull]],
        ["_log_point", objNull, [objNull]]    
    ];
    _lbData params [
        ["_class", "", [""]], 
        ["_cost", 0, [0]]
    ];

    switch true do {
        case(_class isEqualTo btc_supplies_cargo): {
            btc_supplies_mat params ["_food", "_water"];
            _position_world = getPosWorld _log_point;
            [[
                btc_supplies_cargo,
                _position_world vectorAdd [0,0, 1.5], getDir _log_point,
                "",
                [selectRandom _food, selectRandom _water] apply {[_x, "", []]},
                [],
                [vectorDir _log_point, vectorUp _log_point]
            ]] remoteExecCall ["btc_db_fnc_loadObjectStatus", 2];
        };
        case(_class isEqualTo btc_log_fob_create_obj_resupply#0): {
            [objNull, getPosATL _log_point, [vectorDir _log_point, vectorUp _log_point]] remoteExecCall ["btc_log_supplies_fnc_create", [0, 2] select isMultiplayer];
        };
        default {
            [_class, _log_point, _create_obj, _cost] remoteExecCall ["btc_log_fnc_create_s", [0, 2] select isMultiplayer];
        };
    };

}, [[lbData [72, lbCurSel 72], lbValue [72, lbCurSel 72]], _create_obj, _log_point], 0.2] call CBA_fnc_waitAndExecute;

closeDialog 0;