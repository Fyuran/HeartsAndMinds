
/* ----------------------------------------------------------------------------
Function: btc_info_fnc_jail

Description:
	Puts surrendered unit into jail and gives intelligence back

Parameters:
    _captive -
	_jail -

Returns:

Examples:
    (begin example)
        [cursorObject, remoteExecutedOwner] call btc_info_fnc_jail;
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
    ["_jail is null", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};
if(!alive _captive) exitWith {};
if(side _captive == btc_player_side) exitWith {
    ["_captive side is equal to player side", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

private _jailed = _jail getVariable ["btc_jailed", []];
if(_captive in _jailed) exitWith {
    [ 
        [localize"STR_BTC_HAM_INFO_ALREADY_JAILED", 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", [0, -2] select isDedicated];
};
_jailed pushBack _captive;
if(count _jailed > count _jailPositions) then { //remove all decorative captives and start from beggining
    _jailed apply {deleteVehicle _x;};
    _jailed = [];
};
_jail setVariable ["btc_jailed", _jailed];

private _jail_pos = getPosATL _jail;
private _cos_dir = cos direction _jail;
private _sin_dir = sin direction _jail;
private _jailPositions = [
    [1, 1, 0],
    [-2, -2, 0],
    [-2, 1, 0],
    [-2, 2, 0],
    [1, 2, 0],
    [2, 2, 0],
    [2, 1, 0],
    [2, -2, 0],
    [1, -2, 0]
] apply {
    _jail_pos vectorAdd [_x#0 * _cos_dir, _x#1 * _sin_dir, 0];
};



[_captive] joinSilent (createGroup btc_player_side);
_captive setVariable ["btc_info_isDetained", true, true]; //for ace_common_fnc_addCanInteractWithCondition in btc_int_fnc_add_actions
[_captive, true] call ACE_common_fnc_disableAI;
_captive setDir direction _jail;
_captive setPosATL (_jailPositions select (count _jailed % count _jailPositions));

[remoteExecutedOwner, selectRandom[81,96]] call btc_info_fnc_give_intel;
[_player, _CAPTIVE_DETAINED_] call btc_rep_fnc_change;

if(btc_debug) then {
	[format["%1 detained %2 to %3", _player, _captive, _jail_pos], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
};