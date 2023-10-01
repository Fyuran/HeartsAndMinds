
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_suicider_fobCountdown

Description:
    Elapse time then blow shit up

Parameters:
    _suicider - Suicider created. [Object]

Returns:

Examples:
    (begin example)
        [_suicider] call btc_ied_fnc_suicider_fobCountdown;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#define TIME_TO_KABOOM 8
#define KABOOM_RANGE 80

params [
    ["_suicider", objNull, [objNull]]
];

if(!canSuspend) exitWith {
	[format["has to be in a suspendable envinronment(spawn)"], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};
if(!alive _suicider) exitWith {};

_structure =  _suicider getVariable ["btc_target_fob", objNull];
if(isNull _structure) then {
	_countdown = -1;
	[format["FOB suicider %1 no FOB found, blowing up", _suicider], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//New enemy group
_group = createGroup btc_enemy_side;
_group deleteGroupWhenEmpty true;
_group setVariable ["suicider", true];
_group setVariable ["acex_headless_blacklist", true];
[_suicider] joinSilent _group;

//Waypoints and Range check
[_group] call CBA_fnc_clearWaypoints;
[_group, _structure, -1, "MOVE", "COMBAT", "BLUE", "FULL", "NO CHANGE", nil, nil, 1] call CBA_fnc_addWaypoint;

_veh = objectParent _suicider;
waitUntil{(_veh distance2D _structure) <= KABOOM_RANGE};

//Countdown setup
_time = CBA_missionTime + TIME_TO_KABOOM;
_countdown = _time - TIME_TO_KABOOM;

while{_countdown > 0} do {
	if(!alive _suicider) then {break;};
	playSound3D ["A3\Sounds_F\weapons\horns\truck_horn_2.wss", objNull, false, _veh, 5, 1, 500]; 
	sleep 0.8;
	_countdown = _time - CBA_missionTime; 
	[format["FOB suicider activated, explosion in %1 seconds", ceil _countdown], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
}; 

_suicider setDamage 1; //Explosion is handled by Killed EH