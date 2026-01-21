#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_underwater_generator

Description:
    Fill me when you edit me !

Parameters:
    _taskID - Unique task ID. [String]
    _selectedPos - Position acquired from side missions menu available to admin only [Array]
    
Returns:

Examples:
    (begin example)
        [false, "underwater_generator"] spawn btc_side_fnc_create;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose a Marine location occupied\\\\
private _usefuls = if (_selectedPos isEqualTo [0,0,0]) then {
	values btc_city_all select {
        _x getVariable ["occupied", false] &&
        _x getVariable ["type", ""] isEqualTo "NameMarine"
	};
} else {
	private _temp = values btc_city_all select {(_x distance2D _selectedPos) <= _S_RADIUS && {_x getVariable ["type", ""] isEqualTo "NameMarine"}};
	[_temp, [_selectedPos], {_x distance2D _input0}] call BIS_fnc_sortBy;
};
if (_usefuls isEqualTo []) exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no _usefuls", __FILE_NAME__, _taskID], 2, "side"] call btc_debug_fnc_message;
	#endif
	[] call btc_side_fnc_create;
};

private _city = if (_selectedPos isEqualTo [0,0,0]) then {
	selectRandom _usefuls;
} else {
	_usefuls#0;
};
if(isNil "_city") exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no valid _city", __FILE_NAME__, _taskID], 2, "side"] call btc_debug_fnc_message;
	#endif
	[] call btc_side_fnc_create;
};

//// Choose a random position \\\\
private _objects = nearestObjects [getPos _city, [], 200];

_objects = _objects select {
    (str (_x) find "wreck") isNotEqualTo -1 ||
    (str (_x) find "broken") isNotEqualTo -1 ||
    (str (_x) find "rock") isNotEqualTo -1
};
_objects = _objects select {(getPos _x select 2 < -3) && (((str (_x) find "car") isEqualTo -1) || ((str (_x) find "uaz") isEqualTo -1))};
private _wrecks = _objects select {(str (_x) find "rock") isEqualTo -1};

private _pos = [];
if (_wrecks isEqualTo []) then {
    if (_objects isEqualTo []) then {
        ([getPos _city, 0, 100, 13, 2, 60 * (pi / 180), 0] call BIS_fnc_findSafePos) params ["_x", "_y"];
        _pos = [_x, _y, getTerrainHeightASL [_x, _y]];
    } else {
        _pos = getPos (selectRandom _objects);
    };
} else {
    _pos = getPos (selectRandom _wrecks);
};

_city setVariable ["spawn_more", true];

//// Create underwater generator \\\\
private _generator = (selectRandom btc_type_generator) createVehicle _pos;
_pos params ["_x", "_y", "_z"];
private _storagebladder = (selectRandom btc_type_storagebladder) createVehicle [_x + 5, _y, _z];

[_taskID, 11, _generator, [_city getVariable "name", typeOf _generator]] call btc_task_fnc_create;
btc_side_taskIDs set ["underwater_generator", (btc_side_taskIDs getOrDefault ["underwater_generator", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call btc_debug_fnc_message;
#endif

private _group = [_pos, 8, 1 + round random 5, "PATROL"] call btc_mil_fnc_create_group;
[_pos, 20, 2 + round random 4, "PATROL"] call btc_mil_fnc_create_group;

_pos = getPosASL _generator;
(leader (_group select 0)) setPosASL [_x, _y, _z + 1 + random 1];

waitUntil {sleep 5;
    _taskID call BIS_fnc_taskCompleted ||
    !alive _generator
};

[[], [_generator, _storagebladder]] call btc_fnc_delete;

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};

[objNull, _SIDE_UNDERWATER_GENERATOR_DESTROYED_] call btc_rep_fnc_change;

[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
