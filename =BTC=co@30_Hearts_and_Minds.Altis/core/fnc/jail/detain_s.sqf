
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_detain_s

Description:
	Puts surrendered unit into jail and gives intelligence back

Parameters:
    _captive -
	_jail -

Returns:

Examples:
    (begin example)
        [cursorObject, remoteExecutedOwner] call btc_jail_fnc_detain_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_captive", objNull, [objNull]],
    ["_player", objNull, [objNull]],
    ["_jail", objNull, [objNull]]
];

if(isNull _jail) exitWith {
    ["_jail is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(!alive _captive) exitWith {
    ["_captive dead or null", __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
};
if(side _captive == btc_player_side) exitWith {
    ["_captive side is equal to player side", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _jailed = _jail getVariable ["btc_jailed", []];
if(_captive in _jailed) exitWith {
    [ 
        [localize"STR_BTC_HAM_JAIL_ALREADY_JAILED", 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", [0, -2] select isDedicated];
};

private _jailPositions = _jail getVariable ["btc_jail_positions", [_jail, 45] call btc_fnc_circlePosAroundObj];
_jailPositions pushBack getPosATL _jail; //add center of jail to list of available positions

if(count _jailed >= count _jailPositions) then { //remove all decorative captives and start from beggining
    _jailed apply {deleteVehicle _x;};
    _jailed = [];
};
_jail setVariable ["btc_jailed", _jailed];
_jailed pushBack _captive;


[_captive] joinSilent (createGroup btc_player_side);
_captive setVariable ["btc_info_isDetained", true, true]; //for ace_common_fnc_addCanInteractWithCondition in btc_int_fnc_add_actions
[_captive, true] call ACE_common_fnc_disableAI;
[_captive, "Acts_ExecutionVictim_Loop", 2] call ace_common_fnc_doAnimation;
_captive setDir (((direction _jail) + 135) % 360); //animation Acts_ExecutionVictim_Loop is offset from origin in pos and dir
_captive setPos (_jailPositions select (count _jailed % count _jailPositions));

[remoteExecutedOwner, selectRandom[81,96]] call btc_info_fnc_give_intel;
[_player, _CAPTIVE_DETAINED_] call btc_rep_fnc_change;

if(btc_debug) then {
	[format["%1 detained %2 to %3", _player, _captive, getPos _jail], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
};