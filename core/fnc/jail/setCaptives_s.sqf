#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_setCaptives_s

Description:
	Adds ACE actions to unit to manage detention

Parameters:
    _unit -

Returns:

Examples:
    (begin example)
        [cursorObject] spawn btc_jail_fnc_setCaptives_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define _DIST_ 10

params [
    ["_remainEnemyUnits", [], [[], objNull]]
];

if(!canSuspend) exitWith {
  [["%1: must be called with spawn", __FILE_NAME__], 6, "jail"] call FUNC(debug,message);  
};

if(_remainEnemyUnits isEqualTo []) exitWith {};
if(_remainEnemyUnits isEqualType objNull) then {
    _remainEnemyUnits = [_remainEnemyUnits];
};

private _groups = [];
_remainEnemyUnits apply {_groups pushBackUnique group _x};
if (_groups isEqualTo []) exitWith {
    #ifdef BTC_DEBUG_JAIL
    [["%1: no groups found", __FILE_NAME__], 6, "jail"] call FUNC(debug,message);  
    #endif
};
_groups apply {
    if(!local _x) then { //in case group has been transfered to headless client, give it back to server
        _x setGroupOwner ([0, 2] select isDedicated);
        waitUntil { local _x };
    };
    _x setVariable ["no_cache", true, true];
};


[_remainEnemyUnits, {
    _this apply {
        _action = ["btc_jail_captive", localize "STR_BTC_HAM_ACTION_DETAIN", "core\img\jail_captive.paa", {
            _jail = btc_jails select (btc_jails findIf {(_target distance _x) <= _DIST_ });

            [_target, _player, _jail] remoteExecCall ["btc_jail_fnc_detain_s", [0, 2] select isMultiplayer];
            [_target, 0, ["ACE_MainActions","btc_jail_captive"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject", [0, -2] select isMultiplayer];
        }, {
            btc_jails findIf {(_target distance _x) <= _DIST_ } != -1
        }] call ace_interact_menu_fnc_createAction;

        [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
        _x setSpeaker "NoVoice";
    };

}] remoteExecCall ["call", [0, -2] select isDedicated];

_remainEnemyUnits apply {
    private _unit = _x;     
    private _currentWeapon = currentWeapon _unit;
    if(_currentWeapon isNotEqualTo "") then {
        private _weaponHolder = createVehicle ["GroundWeaponHolder", _unit, [], 0, "CAN_COLLIDE"];
        _weaponHolder addWeaponCargoGlobal [_currentWeapon, 1];
        _weaponHolder setVectorDir [random [-1,0,1], random [-1,0,1], 0];
        _weaponHolder setPosATL getPosATL _weaponHolder; ////required to sync dir https://community.bistudio.com/wiki/setDir#Notes
    };
    (weapons _unit) apply {_unit removeWeaponGlobal _x};
    
    _unit setVariable ["acex_headless_blacklist", true];
    [_unit, true] call ace_captives_fnc_setSurrendered;
};

#ifdef BTC_DEBUG_JAIL
[["%1: setting captive to %2", __FILE_NAME__, _remainEnemyUnits], 2, "jail"] call FUNC(debug,message);
#endif