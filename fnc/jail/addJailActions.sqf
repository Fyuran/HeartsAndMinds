
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_addCreateJailAction

Description:
	Adds action to manage FOBs jails

Parameters:
    _target -

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
    ["_target", objNull, [objNull]]
];

if(!alive _target) exitWith {
    ["_target is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _action = ["btc_jail_placeJail", localize "STR_BTC_HAM_ACTION_PLACE_JAIL", "core\img\jail_captive.paa", {
    [_player, _target] spawn btc_jail_fnc_createJail;
}, {
    (isNull (_target getVariable ["btc_jail", objNull])) && {([_player, _target] call ace_common_fnc_canInteractWith)}
}] call ace_interact_menu_fnc_createAction;

[_target, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["btc_jail_removeJail", localize "STR_BTC_HAM_ACTION_REMOVE_JAIL", "core\img\jail_captive_deny.paa", {
    [_target] remoteExecCall ["btc_jail_fnc_removeJail_s", [0, 2] select isMultiplayer];
}, {
    (!isNull (_target getVariable ["btc_jail", objNull])) && {([_player, _target] call ace_common_fnc_canInteractWith)}
}] call ace_interact_menu_fnc_createAction;

[_target, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;