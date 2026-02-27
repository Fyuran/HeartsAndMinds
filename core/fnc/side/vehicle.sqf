#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_vehicle

Description:
    Fill me when you edit me !

Parameters:
    _taskID - Unique task ID. [String]
    _selectedPos - Position acquired from side missions menu available to admin only [Array]
    
Returns:

Examples:
    (begin example)
        [false, "vehicle"] spawn btc_side_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose a City\\\\
private _usefuls = if (_selectedPos isEqualTo [0,0,0]) then {
	values btc_city_all select {
        !((_x getVariable ["type", ""]) in ["NameMarine", "StrongpointArea"])
	};
} else {
	private _temp = values btc_city_all select {(_x distance2D _selectedPos) <= _S_RADIUS};
	[_temp, [_selectedPos], {_x distance2D _input0}] call BIS_fnc_sortBy;
};
if (_usefuls isEqualTo []) exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no _usefuls", __FILE_NAME__, _taskID], 2, "side"] call FUNC(debug,message);
	#endif
	[] call FUNC(side,create);
};

private _city = if (_selectedPos isEqualTo [0,0,0]) then {
	selectRandom _usefuls;
} else {
	_usefuls#0;
};
if(isNil "_city") exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no valid _city", __FILE_NAME__, _taskID], 2, "side"] call FUNC(debug,message);
	#endif
	[] call FUNC(side,create);
};

private _pos = [getPos _city, 100] call FUNC(common,randomize_pos);
private _roads = _pos nearRoads 300;
if (_roads isNotEqualTo []) then {_pos = getPos (selectRandom _roads);};

private _veh_type = selectRandom btc_civ_type_veh;
private _veh = createVehicle [_veh_type, _pos, [], 0, "NONE"];
(_veh call ace_common_fnc_getWheelHitPointsWithSelections) params ["_wheelHitPoints", "_wheelHitPointSelections"];
_veh setDir (random 360);
_veh setDamage 0.7;
private _damagedWheel = 1 + round random (count _wheelHitPointSelections - 1);
_wheelHitPointSelections = (_wheelHitPointSelections call BIS_fnc_arrayShuffle) select [0, _damagedWheel];
{
    _veh setHit [_x, 1];
} forEach _wheelHitPointSelections;

[_taskID, 5, _veh, [_city getVariable "name", _veh_type]] call FUNC(task,create);
btc_side_taskIDs set ["vehicle", (btc_side_taskIDs getOrDefault ["vehicle", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call FUNC(debug,message);
#endif

waitUntil {sleep 5;
    _taskID call BIS_fnc_taskCompleted ||
    ({_x} count (_wheelHitPointSelections apply {_veh getHit _x < 1})) isEqualTo _damagedWheel ||
    !alive _veh
};

[[], [_veh]] call FUNC(common,delete);

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};
if (!alive _veh) exitWith {
    [_taskID, "FAILED"] call BIS_fnc_taskSetState;
};

[(- btc_rep_malus_wheelChange * _damagedWheel), _SIDE_VEHICLE_REPAIRED_] call FUNC(rep,change);

[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
