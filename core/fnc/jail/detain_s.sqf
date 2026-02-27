#include "..\script_macros.hpp"
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

params [
    ["_captive", objNull, [objNull]],
    ["_player", objNull, [objNull]],
    ["_jail", objNull, [objNull]]
];

if(isNull _jail) exitWith {
    #ifdef BTC_DEBUG_JAIL
    [["%1: _jail is null", __FILE_NAME__], 6, "jail"] call FUNC(debug,message);  
    #endif
};
if(!alive _captive) exitWith {
    #ifdef BTC_DEBUG_JAIL
    [["%1: _captive dead or null", __FILE_NAME__], 6, "jail"] call FUNC(debug,message);  
    #endif
};
if(side _captive == btc_player_side) exitWith {
    #ifdef BTC_DEBUG_JAIL
    [["%1: _captive side is equal to player side", __FILE_NAME__], 6, "jail"] call FUNC(debug,message);  
    #endif
};

private _jailed = _jail getVariable ["btc_jailed", []];
if(_captive in _jailed) exitWith {
    [ 
        [localize"STR_BTC_HAM_JAIL_ALREADY_JAILED", 1, [1,1,1,1]]
    ] remoteExecCall ["CBA_fnc_notify", remoteExecutedOwner];
};

private _jailPositions = _jail getVariable ["btc_jail_positions", [_jail, 45] call FUNC(common,circlePosAroundObj)];
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
_captive setDir ((direction _jail) + 135); //animation Acts_ExecutionVictim_Loop is offset from origin in pos and dir
_captive setPos (_jailPositions select (count _jailed % count _jailPositions));

[remoteExecutedOwner, selectRandom[81,96]] call FUNC(info,give_intel);
[_player, _CAPTIVE_DETAINED_] call FUNC(rep,change);

#ifdef BTC_DEBUG_JAIL
[["%1: %2 detained %3 to %4", __FILE_NAME__, _player, _captive, getPos _jail], 2, "jail"] call FUNC(debug,message);
#endif