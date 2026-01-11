#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_garrison_fnc_spawn

Description:
	Adds AI garrisons based on number of available building positions

Parameters:
    _building -
	_group -

Returns:

Examples:
    (begin example)
        [cursorObject, side player] call btc_garrison_fnc_spawn;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_building", objNull, [objNull]],
	["_side", btc_enemy_side, [east]],
	["_type_units", btc_type_units, [[]]],
	["_outsideOnly", false, [true]]
];
if(isNull _building) exitWith {
	#ifdef BTC_DEBUG_GARRISON
	[["%1: Invalid _building param", __FILE_NAME__], 6, "garrison"] call btc_debug_fnc_message;
	#endif};
if(_type_units isEqualTo []) exitWith {
	#ifdef BTC_DEBUG_GARRISON
	[["%1: _type_units is empty", __FILE_NAME__], 6, "garrison"] call btc_debug_fnc_message;
	#endif
};

if ((count (_building buildingPos -1)) <= 0) exitWith {
	#ifdef BTC_DEBUG_GARRISON
	[["%1: no suitable positions found for garrison", __FILE_NAME__], 6, "garrison"] call btc_debug_fnc_message;
	#endif
};

[[_side, _building, _type_units, _outsideOnly], {
	params ["_side", "_building", "_type_units", "_outsideOnly"];

	private _buildingPositions = _building buildingPos -1;
	if(_outsideOnly) then {
		_buildingPositions = _buildingPositions select {
			private _pos = ATLtoASL _x;
			private _surface = (lineIntersectsSurfaces [_pos, _pos vectorAdd [0,0,5], objNull, objNull, true, 1, "GEOM"]);
			_surface isEqualTo []
		};
		#ifdef BTC_DEBUG_GARRISON
		if(_buildingPositions isEqualTo []) then {
			[["%1: no suitable positions found for outside only garrison", __FILE_NAME__], 6, "garrison"] call btc_debug_fnc_message;
		};
		#endif
	};

	#ifdef BTC_DEBUG_GARRISON
	btc_garrison_buildingPos_debug_objects = [];
	(_building buildingPos -1) apply {
		private _sphere = createVehicle ["Sign_Sphere25cm_F", _x, [], 0, "CAN_COLLIDE"];
		private _pos = _x;
		private _higherPos = _pos vectorAdd [0,0,5];
		private _intersect = (lineIntersectsSurfaces [ATLtoASL _pos, ATLtoASL _higherPos, _sphere, objNull, true, 1, "GEOM"]) param[0, []];
		if (_intersect isNotEqualTo []) then {
			_sphere setVariable ["btc_debug_ceiling", ASLtoATL (_intersect#0)];
		};
		btc_garrison_buildingPos_debug_objects pushBack _sphere;
	};

	btc_garrison_buildingPos_debug_eh = addMissionEventHandler ["Draw3D", {
		btc_garrison_buildingPos_debug_objects apply {
			_pos = getPosATLVisual _x;
			_top = _pos vectorAdd [0,0,5];
			_ceiling = _x getVariable ["btc_debug_ceiling", []];
			if(_ceiling isNotEqualTo []) then {
				drawLine3D [_pos, _ceiling, [1,0,0,1]];
				_x setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0,0,1)'];
			} else {
				drawLine3D [_pos, _top, [0,1,0,1]];
				_x setObjectTextureGlobal [0,'#(argb,8,8,3)color(0,1,0,1)'];
			};
		};
	}];
	#endif
	private _group = createGroup _side;
	_buildingPositions apply {
		private _unit = _group createUnit [selectRandom _type_units, _x, [], 0, "CAN_COLLIDE"];
		doStop _unit;
		_unit setVariable["lambs_danger_disableAI", true];
		_unit setVariable["btc_mil_garrison_group", true];
		_unit setUnitPos "UP";
		_unit disableAI "PATH"; // This command causes AI to repeatedly attempt to crouch when engaged
	};

	_building setVariable["btc_mil_garrison_pos", _buildingPositions];
	_building setVariable["btc_mil_garrison_group", _group];
	//Static spawn
	// private _surface = [_building, 4, 3, false] call btc_fnc_find_highest_pos;
	// if(_surface isNotEqualTo [[0, 0, 0], 0]) then {
	// 	_surface params ["_highestPosATL", "_surfaceNormal"];
	// 	private _veh = createVehicle ["B_G_HMG_02_high_F", _highestPosATL, [], 0, "CAN_COLLIDE"];
	// 	_veh setVectorUp _surfaceNormal;

	// 	private _group = createGroup _side;
	// 	private _unit = _group createUnit [selectRandom _type_units, [0, 0, 0], [], 0, "CAN_COLLIDE"];
	// 	_unit moveinGunner _veh;
	// 	_unit assignAsGunner _veh;

	// 	(leader _group) setVariable ["acex_headless_blacklist", true];
	// } else {
	// 	#ifdef BTC_DEBUG_GARRISON
	// 	[format["No suitable positions found for static"], __FILE_NAME__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
	// 	#endif// 
	//};

	(leader _group) setVariable ["acex_headless_blacklist", true];

}] call btc_delay_fnc_exec;




