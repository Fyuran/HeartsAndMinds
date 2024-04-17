/* ----------------------------------------------------------------------------
	Function: btc_ied_fnc_suicider_fobLoop
	
	Description:
	    When within range blow everything sky fucking high.
	
	Parameters:
	    _suicider - Suicider created. [Object]
	
	Returns:
	
	Examples:
	    (begin example)
	        [_suicider] call btc_ied_fnc_suicider_fobLoop;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
#define _KABOOM_RANGE 25
#define _TRG_RANGE 100

params [
	["_suicider", objNull, [objNull]]
];

if (!alive _suicider) exitWith {};

_building = _suicider getVariable ["btc_target_fob", objNull];

// waypoints and Range check
_group = group _suicider;
[_group] call CBA_fnc_clearWaypoints;
[_group, _building, -1, "MOVE", "CARELESS", "BLUE", "FULL", "NO CHANGE", nil, nil, 1] call CBA_fnc_addWaypoint;

// Explosion on death is handled by Killed EH in btc_ied_fnc_suicider_fob_create
if (alive _building) then {
	[format["FOB %1 suicider %2 activated", _building getVariable["FOB_name",""], _suicider], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;

	[_suicider, _building] spawn {
		params [
			["_suicider", objNull, [objNull]],
			["_building", objNull, [objNull]]
		];
		_veh = objectParent _suicider;
		while { alive _suicider && {!isNull _veh} } do {
			if((_veh distance2D _building) <= _TRG_RANGE) then {
				playSound3D ["A3\Sounds_F\weapons\horns\truck_horn_2.wss", objNull, false, _veh, 5, 1, 500];
			};
			sleep 0.8;
		};
	};

	[{
		isNull (objectParent (_this select 0)) || {((objectParent (_this select 0)) distance2D (_this select 1)) <= _KABOOM_RANGE}
	}, {
		playSound3d [getMissionPath "core\sounds\allahu_akbar.ogg", (objectParent (_this select 0)), false, getPosASL (objectParent (_this select 0)), 5, random [0.9, 1, 1.2], 100];
		(_this select 0) setDamage 1;
	}, [_suicider, _building]] call CBA_fnc_waitUntilAndExecute;
	
} else {
	_suicider setDamage 1;
};

