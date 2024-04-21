
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_resupplyActions

Description:
    Adds resupply actions to obj

Parameters:

Returns:

Examples:
(begin example)
    _result = [getPos player] call btc_log_fob_fnc_resupplyActions;
(end)

Author:
Fyuran

---------------------------------------------------------------------------- */
#define DISTSQR 10*10

params [
    ["_obj", objNull, [objNull]]
];

if(!alive _obj) exitWith {
    ["_obj is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

//place
private _action_place = ["Place", localize "STR_ACE_Dragging_Carry", "\z\ace\addons\dragging\UI\icons\box_carry.paa", {
    [_target] call btc_log_fnc_place;
    _target setVariable ["btc_fob_log_isClaimed", true, [0, 2] select isMultiplayer];
}, 
{!btc_log_placing && !(player getVariable ["ace_dragging_isCarrying", false])}, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
[_obj, 0, ["ACE_MainActions"], _action_place] call ace_interact_menu_fnc_addActionToObject;

//resupply
private _action_resupply = ["btc_log_resupply", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY", "a3\ui_f\data\igui\cfg\holdactions\holdaction_loaddevice_ca.paa", {
    [_target] remoteExecCall ["btc_log_fob_fnc_resupply", [0, 2] select isMultiplayer];
}, {
    (btc_log_fob_create_objects findIf {(_target distanceSqr _x) <= DISTSQR}) != -1
}] call ace_interact_menu_fnc_createAction;

//pack
private _action_pack = ["btc_log_pack", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY_PACK", "a3\ui_f\data\igui\cfg\holdactions\holdaction_loaddevice_ca.paa", {
    [_target] remoteExecCall ["btc_log_fob_fnc_resupply_packed", [0, 2] select isMultiplayer];
}, {
    [_player, _target] call ace_common_fnc_canInteractWith
}] call ace_interact_menu_fnc_createAction;

//unpack
private _action_unpack = ["btc_log_unpack", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY_UNPACK", "a3\ui_f\data\igui\cfg\holdactions\holdaction_loaddevice_ca.paa", {
    params["", "", "_actionParams"];

    [_target, _actionParams] remoteExecCall ["btc_log_fob_fnc_resupply_unpacked", [0, 2] select isMultiplayer];
}, {
    [_player, _target] call ace_common_fnc_canInteractWith
}, {}, [_action_resupply, _action_pack]] call ace_interact_menu_fnc_createAction;
[_obj, 0, ["ACE_MainActions"], _action_unpack] call ace_interact_menu_fnc_addActionToObject;