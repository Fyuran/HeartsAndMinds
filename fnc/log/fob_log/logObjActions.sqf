
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_logObjActions

Description:
    Adds logistic actions to object for FOBs

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] call btc_log_fob_fnc_logObjActions;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_create_obj", objNull, [objNull]],
    ["_log_point", objNull, [objNull]]
];

if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(isNull _log_point) exitWith {
    ["_log_point is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};


private _action = ["Logistic_FOB", localize "STR_BTC_HAM_ACTION_LOC_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\L_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Require_object", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQOBJ", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\D_ca.paa", {
    params ["_target", "", "_params"];
    _params params ["_construction_array", "_log_point"];
    _pos = getPosATL _log_point;
    _pos set [2, 0]; //make sure helipad Z level is set to ground
    _log_point setPosATL _pos;
    [_target, _construction_array, _log_point] call btc_log_fnc_create;
}, {true}, {}, [btc_fob_construction_array, _log_point], [0, 0, 1], 5] call ace_interact_menu_fnc_createAction;
[_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Require_delete", localize "STR_3DEN_Delete", "\z\ace\addons\arsenal\data\iconClearContainer.paa", {
    params ["_target", "", "_params"];
    [_target, _params] call btc_log_fnc_delete
}, {true}, {}, _log_point, [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
[_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["Place", localize "STR_ACE_Dragging_Carry", "\z\ace\addons\dragging\UI\icons\box_carry.paa", {[_target] call btc_log_fnc_place}, 
{!btc_log_placing && !(player getVariable ["ace_dragging_isCarrying", false])}, {}, [], [0,0,0], 10] call ace_interact_menu_fnc_createAction;
[_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;