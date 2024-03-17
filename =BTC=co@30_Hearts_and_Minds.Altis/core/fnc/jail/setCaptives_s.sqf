
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
#define DISTSQR (10 * 10)

params [
    ["_remainEnemyUnits", [], [[], objNull]]
];

if(!canSuspend) exitWith {
  ["must be called with spawn", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

if(_remainEnemyUnits isEqualTo []) exitWith {};
if(_remainEnemyUnits isEqualType objNull) then {
    _remainEnemyUnits = [_remainEnemyUnits];
};

private _groups = [];
_remainEnemyUnits apply {_groups pushBackUnique group _x};
if (_groups isEqualTo []) exitWith {["no groups found", __FILE__, [false, true, true], true] call btc_debug_fnc_message;};
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
            _jail = btc_jails select (btc_jails findIf {(_target distanceSqr _x) <= DISTSQR });

            [_target, _player, _jail] remoteExecCall ["btc_jail_fnc_detain_s", [0, 2] select isMultiplayer];
            [_target, 0, ["ACE_MainActions","btc_jail_captive"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject", [0, -2] select isMultiplayer];
        }, {
            btc_jails findIf {(_target distanceSqr _x) <= DISTSQR } != -1
        }] call ace_interact_menu_fnc_createAction;

        [_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
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

if(btc_debug) then {
	[format["setting captive to %1", _remainEnemyUnits], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
};