#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_hack

Description:
    https://forums.bistudio.com/forums/topic/186316-how-to-open-the-land_dataterminal_01_f-data-terminal-nexus-update/
    http://killzonekid.com/arma-scripting-tutorials-uav-r2t-and-pip/
    http://killzonekid.com/arma-scripting-tutorials-scripted-charges/

Parameters:
    _taskID - Unique task ID. [String]
    _selectedPos - Position acquired from side missions menu available to admin only [Array]
    
Returns:

Examples:
    (begin example)
        [false, "hack"] spawn btc_side_fnc_create;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose a City\\\\
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
private _house = selectRandom (([_pos, 100] call FUNC(common,getHouses)) select 0);
if (isNil "_house") exitWith {[] call FUNC(side,create);};
_pos = selectRandom (_house buildingPos -1);

[_taskID, 16, _city, _city getVariable "name"] call FUNC(task,create);
btc_side_taskIDs set ["hack", (btc_side_taskIDs getOrDefault ["hack", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call FUNC(debug,message);
#endif

_city setVariable ["spawn_more",true];

//// Create terminal \\\\
private _terminalType = "Land_DataTerminal_01_F";
private _terminal = createVehicle [_terminalType, [_pos, ASLToATL _pos] select surfaceIsWater _pos, [], 0, "CAN_COLLIDE"];
_pos = [[_pos, 100] call FUNC(common,randomize_pos), 50, 500, 30, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos;
private _launchsite = createVehicle ["Land_PenBlack_F", _pos, [], 0, "FLY"];
private _terminal_taskID = _taskID + "ter";
[[_terminal_taskID, _taskID], 17, _terminal, _terminalType] call FUNC(task,create);

//// Add interaction on Terminal \\\\
_terminal setVariable ["btc_terminal_taskID", _terminal_taskID, true];
[_terminal] remoteExecCall ["btc_int_fnc_terminal", [0, -2] select isDedicated, _terminal];

waitUntil {sleep 5; (_terminal_taskID call BIS_fnc_taskCompleted)};
if (_terminal_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {
    [[], [_terminal]] call FUNC(common,delete);
};

private _defend_taskID = _taskID + "df";
[[_defend_taskID, _taskID], 22, _terminal, _terminalType, true] call FUNC(task,create);

private _groups = [];
private _closest = [_city, values btc_city_all select {!(_x getVariable ["active", false])}, false] call FUNC(common,find_closecity);
for "_i" from 1 to (2 + round random 1) do {
    _groups pushBack ([FUNC(mil,send), [_closest, getPos _terminal, 1, selectRandom btc_type_motorized]] call CBA_fnc_directCall);
};

{
    _x setBehaviour "CARELESS"
} forEach _groups;

[_terminal, _launchsite modelToWorld [0, 100, 10]] remoteExecCall ["btc_log_fnc_place_create_camera", [0, -2] select isDedicated];

waitUntil {sleep 5; 
    _defend_taskID call BIS_fnc_taskCompleted ||
    grpNull in _groups ||
    !(_city getVariable ["active", false])
};

if (_defend_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {
    [[], [_terminal]] call FUNC(common,delete);
};

if !(_city getVariable ["active", false]) exitWith {
    [_taskID, "FAILED"] call FUNC(task,setState);
    [[], [_terminal]] call FUNC(common,delete);
};

//// Launch the hacked missile \\\\
_pos params ["_x", "_y"];
private _altitude = 20;
while {_altitude < 500} do {
    _altitude = _altitude + 3;
    (createVehicle ["DemoCharge_Remote_Ammo_Scripted", [_x, _y, _altitude], [], 0, "CAN_COLLIDE"]) setDamage 1;
    sleep 0.1;
};
private _rocket = createVehicle ["ace_rearm_Missile_AGM_02_F", [_x, _y, _altitude], [], 0, "CAN_COLLIDE"];
private _fx = createVehicle ["test_EmptyObjectForSmoke", [_x, _y, _altitude], [], 0, "CAN_COLLIDE"];
_fx attachTo [_rocket, [0, 0, 0]];

[[], [_rocket, _terminal, _fx]] call FUNC(common,delete);

[objNull, _SIDE_TERMINAL_HACKED_] call FUNC(rep,change);

[_taskID, "SUCCEEDED"] call FUNC(task,setState);
