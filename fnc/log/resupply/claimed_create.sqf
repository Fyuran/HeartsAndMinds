
/* ----------------------------------------------------------------------------
Function: btc_log_resupply_fnc_claimed_create

Description:
    Manages claimed logistic object

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_resupply_fnc_claimed_create;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define _DIST_ 10

params[
    ["_pos", [0,0,0], [[]], 3],
    ["_dir", 0, [0]],
    ["_resources", -1, [0]],
    ["_class", btc_log_fob_create_obj_resupply#1, [""]]
];

private _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
_obj setVectorUp (surfaceNormal _pos);
_obj setDir _dir;
[_obj, 2] call ace_cargo_fnc_setSize; //-1 to disable Load in Cargo
[_obj, 0] call ace_cargo_fnc_setSpace;
_obj setVariable ["btc_log_resources", _resources, true];

private _marker_flag = createVehicle ["ace_marker_flags_blue", [0,0,0], [], 0, "CAN_COLLIDE"];
_marker_flag attachTo [_obj, [0,0,1]];

btc_log_fob_supply_objects pushBack _obj;
publicVariable "btc_log_fob_supply_objects";

playSound3D ["a3\missions_f_bootcamp\data\sounds\assemble_target.wss", _obj, false, ATLtoASL _pos, 5, 1, 10];

[_obj, {

    params["_obj"];
    //place
    private _action = ["Place", localize "STR_ACE_Dragging_Carry", "\z\ace\addons\dragging\UI\icons\box_carry.paa", {
        [_target] call btc_log_fnc_place;
    }, {
        !btc_log_placing && !(player getVariable ["ace_dragging_isCarrying", false])
    }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
    [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    //resupply
    _action = ["btc_log_resupply", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY", "a3\ui_f\data\igui\cfg\holdactions\holdaction_loaddevice_ca.paa", {
        [_target] remoteExecCall ["btc_log_resupply_fnc_doResupply", [0, 2] select isMultiplayer];
    }, {
        (btc_log_fob_create_objects findIf {(_target distance _x) <= _DIST_}) != -1
    }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
    [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    //discard
    _action = ["btc_log_resupply_discard", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY_DISCARD", "DBUG\pictures\reload.paa", {
        [_target, _player] remoteExecCall ["btc_log_resupply_fnc_delete", [0, 2] select isMultiplayer];
    }, {
        (btc_log_fob_create_objects findIf {(_target distance _x) <= _DIST_}) != -1
    }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
    [_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

}] remoteExecCall ["call", [0, -2] select isDedicated, _obj];

if(btc_debug) then {
    [format["created CLAIMED supply at [%1]r:%2", _pos, _resources], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;  
};

_obj