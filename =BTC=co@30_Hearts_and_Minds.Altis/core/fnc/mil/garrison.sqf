
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_garrison

Description:
	Adds AI garrisons based on number of available building positions

Parameters:
    _structure -
	_group -

Returns:

Examples:
    (begin example)
        [cursorObject, side player] call btc_mil_fnc_garrison;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_building", objNull, [objNull]],
	["_side", btc_enemy_side, [east]],
	["_type_units", btc_type_units, [[]]]
];
if(isNull _building) exitWith {["Invalid _building param", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};
if(_type_units isEqualTo []) exitWith {["_type_units is empty", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

if ((count (_building buildingPos -1)) <= 0) exitWith {
	if(btc_debug) then {
		[format["No suitable positions found for garrison"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
	};
};

[[_side, _building, _type_units], {
	params ["_side", "_building", "_type_units"];
	private _group = createGroup _side;

	private _buildingPositions = _building buildingPos -1;
	private _buildingCenter = getPosWorld _building;
	private _buildingPositionsInside = _buildingPositions select {!(lineIntersects [_x, (_x vectorAdd [0, 0, 10])])};
	
	_buildingPositions apply {
		private _unit = _group createUnit [selectRandom _type_units, _x, [], 0, "CAN_COLLIDE"];
		// _directionPos = _building getRelPos [100, _buildingCenter getDir _x];
		// _unit doWatch _directionPos;
		doStop _unit;

		if(!(_x in _buildingPositionsInside)) then { //disallow outside units from crouching or moving
			_unit setUnitPos "UP";
			_unit disableAI "PATH"; // This command causes AI to repeatedly attempt to crouch when engaged
		};
	};

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
	// 	if(btc_debug) then {
	// 		[format["No suitable positions found for static"], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
	// 	};
	// };

	(leader _group) setVariable ["acex_headless_blacklist", true];

}] call btc_delay_fnc_exec;




