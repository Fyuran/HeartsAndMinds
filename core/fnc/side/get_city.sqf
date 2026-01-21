#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_get_city

Description:
    Fill me when you edit me !

Parameters:
    _taskID - Unique task ID. [String]
    _selectedPos - Position acquired from side missions menu available to admin only [Array]

Returns:

Examples:
    (begin example)
        [false, "get_city"] spawn btc_side_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose a occupied City\\\\
private _usefuls = if (_selectedPos isEqualTo [0,0,0]) then {
	values btc_city_all select {
        _x getVariable ["occupied", false] &&
        !((_x getVariable ["type", ""]) in ["NameLocal", "Hill", "NameMarine", "StrongpointArea"])
	};
} else {
	private _temp = values btc_city_all select {(_x distance2D _selectedPos) <= _S_RADIUS && {_x getVariable ["occupied", false]}};
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

[_taskID, 6, _city, _city getVariable "name"] call btc_task_fnc_create;
btc_side_taskIDs set ["get_city", (btc_side_taskIDs getOrDefault ["get_city", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call btc_debug_fnc_message;
#endif

_city setVariable ["spawn_more", true];

waitUntil {sleep 5; 
    _taskID call BIS_fnc_taskCompleted ||
    !(_city getVariable ["occupied", false])
};

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};

[objNull, _SIDE_CITY_TAKEN_] call btc_rep_fnc_change;

[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
