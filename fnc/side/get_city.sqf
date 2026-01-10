#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_get_city

Description:
    Fill me when you edit me !

Parameters:
    _taskID - Unique task ID. [String]

Returns:

Examples:
    (begin example)
        [] spawn btc_side_fnc_get_city;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], [2,3]]
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
	["No valid occupied city found"] remoteExecCall ["hint", remoteExecutedOwner];
};

private _city = if (_selectedPos isEqualTo [0,0,0]) then {
	selectRandom _usefuls;
} else {
	_usefuls#0;
};
if(isNil "_city") exitWith {
	["No valid cities found"] remoteExecCall ["hint", remoteExecutedOwner];
};

[_taskID, 6, _city, _city getVariable "name"] call btc_task_fnc_create;

_city setVariable ["spawn_more", true];

waitUntil {sleep 5; 
    _taskID call BIS_fnc_taskCompleted ||
    !(_city getVariable ["occupied", false])
};

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};

[objNull, _SIDE_CITY_TAKEN_] call btc_rep_fnc_change;

[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
