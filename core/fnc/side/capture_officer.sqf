#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_capture_officer

Description:
    Thanks DAP for inspiration.

Parameters:
    _taskID - Unique task ID. [String]
	_selectedPos - Position acquired from side missions menu available to admin only [Array]

Returns:

Examples:
    (begin example)
        [false, "capture_officer"] spawn btc_side_fnc_create;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
	["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose two Cities \\\\
private _usefuls = if (_selectedPos isEqualTo [0,0,0]) then {
	values btc_city_all select {
		!((_x getVariable ["type", ""]) in ["NameLocal", "Hill", "NameMarine", "StrongpointArea"]) &&
		!(_x getVariable ["occupied", false])
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

//// Find Road \\\\
private _worldArea = (getNumber (configFile >> "CfgWorlds" >> worldName >> "MapSize"))/4;
private _distantCities = values btc_city_all select {(_x distance2D _city) > _worldArea};
private _roads = (selectRandom _distantCities) nearRoads _S_RADIUS;
if (_roads isEqualTo []) exitWith {
	#ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no _roads", __FILE_NAME__, _taskID], 2, "side"] call FUNC(debug,message);
	#endif
	[] call FUNC(side,create);
};
private _road = selectRandom _roads;
private _pos1 = getPosATL _road;
private _pos2 = getPos _city;

[_taskID, 14, _city, _city getVariable "name"] call FUNC(task,create);
btc_side_taskIDs set ["capture_officer", (btc_side_taskIDs getOrDefault ["capture_officer", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call FUNC(debug,message);
#endif

//// Create markers \\\\
private _marker1 = createMarkerLocal [format ["sm_2_%1", _pos1], _pos1];
_marker1 setMarkerTypeLocal "hd_flag";
[_marker1, "str_a3_campaign_b_m06_marker01"] remoteExecCall ["btc_fnc_set_markerTextLocal", [0, -2] select isDedicated, _marker1]; // RemoteExec to localize on client, Convoy start
_marker1 setMarkerSize [0.6, 0.6];

private _marker2 = createMarkerLocal [format ["sm_2_%1", _pos2], _pos2];
_marker2 setMarkerTypeLocal "hd_flag";
[_marker2, "STR_BTC_HAM_SIDE_CONVOY_MRKEND"] remoteExecCall ["btc_fnc_set_markerTextLocal", [0, -2] select isDedicated, _marker2]; //Convoy end
_marker2 setMarkerSize [0.6, 0.6];

private _area = createMarkerLocal [format ["sm_%1", _pos2], _pos2];
_area setMarkerShapeLocal "ELLIPSE";
_area setMarkerBrushLocal "SolidBorder";
_area setMarkerSizeLocal [_S_RADIUS/2, _S_RADIUS/2];
_area setMarkerAlphaLocal 0.3;
_area setmarkerColor "colorBlue";

private _markers = [_marker1, _marker2, _area];

/// Show info path\\\
private _veh_types = btc_civ_type_veh select {!(_x isKindOf "air")};
private _agent = [FUNC(info,path), [_pos1, _pos2, _taskID, _veh_types select 0]] call CBA_fnc_directCall;
private _startingPath = time;

waitUntil {
	!isNil {_agent getVariable "btc_path"} ||
	{time > _startingPath + 10}
};

private _path = _agent getVariable ["btc_path", []];
if (count _path <= 35) exitWith {
	_markers append (allMapMarkers select {(_x select [0, count _taskID]) isEqualTo _taskID});
	[_markers, [_agent]]  call FUNC(common,delete);
	[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
};

//// Create convoy \\\\
private _group = createGroup btc_enemy_side;
_group setVariable ["no_cache", true];
_group setVariable ["acex_headless_blacklist", true];
[_group] call CBA_fnc_clearWaypoints;
private _convoyLength = 2 + round random 1;
private _listPositions = _path select [40, _convoyLength + 1];
reverse _listPositions;
[_group, ASLToAGL (_listPositions select 0), -1, "SENTRY", "SAFE", "RED", "LIMITED", "COLUMN"] call CBA_fnc_addWaypoint; // Make sure they don't move during spawn
private _delay = 0;
for "_i" from 1 to _convoyLength do {
	private _pos = _listPositions deleteAt 0;
	_delay = _delay + ([_group, ASLToAGL _pos, selectRandom _veh_types, (_listPositions select 0) getDir _pos] call FUNC(mil,createVehicle));
};

[{
	params ["_group"];

	_group call CBA_fnc_clearWaypoints;
	_this call CBA_fnc_addWaypoint;
	[12] remoteExecCall ["btc_fnc_show_hint", [0, -2] select isDedicated];

	private _vehs = (units _group) apply {assignedVehicle _x};
	{
		_x addCuratorEditableObjects [_vehs arrayIntersect _vehs, false];
	} forEach allCurators;
}, [
	_group, _pos2, -1, "MOVE", "SAFE", "RED", "LIMITED", "COLUMN",
	format ["['%1', 'FAILED'] call BIS_fnc_taskSetState;", _taskID], [0, 0, 0], _S_RADIUS/2
], _delay] call FUNC(delay,waitAndExecute);

[{
	params ["_group", "_taskID", "_trigger"];

	private _captive = leader _group;
	removeAllWeapons _captive;
	private _vehs = (units _group) apply {assignedVehicle _x};
	{
		_x addCuratorEditableObjects [_vehs arrayIntersect _vehs, false];
	} forEach allCurators;

	private _surrender_taskID = _taskID + "su";
	[[_surrender_taskID, _taskID], 24, objNull, typeOf _captive] call FUNC(task,create);
	private _handcuff_taskID = _taskID + "hc";
	private _back_taskID = _taskID + "bk";

	//// Create trigger \\\\
	private _trigger = createTrigger ["EmptyDetector", _captive, false];
	_trigger setVariable ["captive", _captive];
	_trigger setTriggerArea [15, 15, 0, false];
	_trigger setTriggerActivation [str btc_player_side, "PRESENT", true];
	_trigger setTriggerStatements ["this", format ["_captive = thisTrigger getVariable 'captive'; deleteVehicle thisTrigger; doGetOut _captive; doStop _captive; [_captive, true] call ace_captives_fnc_setSurrendered; ['%1', 'SUCCEEDED'] call BIS_fnc_taskSetState; [['%2', '%4'], 29, _captive] call btc_task_fnc_create; [['%3', '%4'], 21, btc_log_point_obj, typeOf btc_log_point_obj] call btc_task_fnc_create;", _surrender_taskID, _handcuff_taskID, _back_taskID, _taskID], ""];
	_trigger attachTo [_captive, [0, 0, 0]];

	["ace_captiveStatusChanged", {
		params ["_unit", "_state", "_type"];
		_thisArgs params ["_captive", "_handcuff_taskID"];

		if (isNull _captive) then {
			[_thisType, _thisId] call CBA_fnc_removeEventHandler;
		};
		if (_unit isEqualTo _captive && _type isEqualTo "SetHandcuffed") then {
			[_thisType, _thisId] call CBA_fnc_removeEventHandler;
			[_handcuff_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		};
		_this
	}, [_captive, _handcuff_taskID]] call CBA_fnc_addEventHandlerArgs;

	[{
		!alive (_this select 0) ||
		isNull (_this select 0)
	}, {
		[_this select 1, "FAILED"] call FUNC(task,setState);
		deleteVehicle (_this select 2);
	}, [_captive, _taskID, _trigger]] call CBA_fnc_waitUntilAndExecute;

	[{
		(_this select 0) inArea [getPosWorld btc_log_point_obj, 100, 100, 0, false] ||
		isNull (_this select 0)
	}, {
		[_this select 1, "SUCCEEDED"] call FUNC(task,setState);
	}, [_captive, _taskID]] call CBA_fnc_waitUntilAndExecute;
}, [
	_group,
	_taskID
], _delay] call FUNC(delay,waitAndExecute);

waitUntil {sleep 5; _taskID call BIS_fnc_taskCompleted};

_markers append (allMapMarkers select {(_x select [0, count _taskID]) isEqualTo _taskID});
private _vehs = (units _group) apply {assignedVehicle _x};
_vehs = (_vehs arrayIntersect _vehs);

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {
	[_markers, _vehs + [_group]] call FUNC(common,delete);
};

if (_taskID call BIS_fnc_taskState isEqualTo "FAILED") exitWith {
	_group setVariable ["no_cache", false];
	{
		private _group = createGroup btc_enemy_side;
		(crew _x) joinSilent _group;
		[FUNC(data,add_group), _group] call CBA_fnc_directCall;
	} forEach _vehs;
	[_markers] call FUNC(common,delete);
};

[_markers, _vehs + [_group]]  call FUNC(common,delete);

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};

[objNull, _SIDE_OFFICER_CAPTURED_] call FUNC(rep,change);
