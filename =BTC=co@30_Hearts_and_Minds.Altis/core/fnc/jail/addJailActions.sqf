
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_addCreateJailAction

Description:
	Adds action to manage FOBs jails

Parameters:
    _fob -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_jail_fnc_addJailActions;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_fob", objNull, [objNull]]
];

if(!alive _fob) exitWith {
    ["_fob is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _action = ["btc_jail_placeJail", localize "STR_BTC_HAM_ACTION_PLACE_JAIL", "core\img\jail_captive.paa", {
    [_player, _target] remoteExecCall ["btc_jail_fnc_createJail_s", [0, 2] select isMultiplayer];
}, {
    (isNull (_target getVariable ["btc_jail", objNull])) && {([_player, _target] call ace_common_fnc_canInteractWith)}
}] call ace_interact_menu_fnc_createAction;

[_fob, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

private _action = ["btc_jail_removeJail", localize "STR_BTC_HAM_ACTION_REMOVE_JAIL", "core\img\jail_captive_deny.paa", {
    [_player, _target] remoteExecCall ["btc_jail_fnc_removeJail_s", [0, 2] select isMultiplayer];
}, {
    (!isNull (_target getVariable ["btc_jail", objNull])) && {([_player, _target] call ace_common_fnc_canInteractWith)}
}] call ace_interact_menu_fnc_createAction;

[_fob, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

// private _handleRot = [{ //rotating arrow
//     _args params ["_jail"];

//     _theta = (cba_missionTime * 300);

//     _vectorUp = vectorUp _jail;
//     _vectorDir = vectorDir _jail;
    
// }, 0, _jail] call CBA_fnc_addPerFrameHandler;

// private _handleRot = [{ //rotating arrow 
//     _args params ["_arrow"];

//     _theta = 0.5; 
//     _vecDir = vectorDir _arrow;
//     _matrix = [
//         [cos _theta, -sin _theta, 0],
//         [sin _theta, cos _theta, 0],
//         [0, 0, 1]
//     ] matrixMultiply [
//         [ _vecDir select 0],
//         [_vecDir select 1],
//         [ _vecDir select 2]
//     ];
//     _matrix = flatten _matrix;

//     _arrow setVectorDir _matrix;

// }, 0, [_centerObjs#0]] call CBA_fnc_addPerFrameHandler;