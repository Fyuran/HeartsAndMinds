
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_suicider_fob_create

Description:
    Create a suicider on vehicle that will move towards the fob.

Parameters:
    _city - City where the suicider is created. [Object]
    _area - Area around the city the suicider is created randomly. [Number]
    _rpos - Create the suicider at this position. [Array]
    _type_units - Type of units. [Group]

Returns:
    _suicider - Created suicider. [Object]

Examples:
    (begin example)
        _suicider = [allplayers select 0, 100] call btc_ied_fnc_suicider_create;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_city", objNull, [objNull]],
	["_structure", objNull, [objNull]],
    ["_type_units", "", [""]]
];

if (_type_units isEqualTo "") then {
    _type_units = selectRandom btc_civ_type_units;
};

private _pos = getPosASL _city;

private _group = createGroup [civilian, true];
//_group setVariable ["btc_city", _city]; btc_rep_fnc_killed will check if CIVgroup has an assigned city to deduct rep.
_group setVariable ["acex_headless_blacklist", true];
_group setVariable ["suicider", true];
_group setVariable ["btc_patrol_id", btc_civilian_id, btc_debug];
btc_civilian_id = btc_civilian_id - 1;
_group deleteGroupWhenEmpty true;

//Vehicle
private _veh_type = selectRandom [
	"C_Van_02_vehicle_F",
	"C_Van_02_service_F",
	"C_Van_02_medevac_F",
	"C_Van_02_transport_F",
	"C_Truck_02_covered_F",
	"C_Truck_02_fuel_F",
	"C_Truck_02_box_F"
];
private _safe_pos = [];
private _roads = _pos nearRoads 500;
_roads = _roads select {isOnRoad _x};
if (_roads isEqualTo []) then {
    _safe_pos = [_pos, 0, 500, 13, 0, 60 * (pi / 180), 0] call BIS_fnc_findSafePos;
    _safe_pos = [_safe_pos select 0, _safe_pos select 1, 0]; 
} else {
    _safe_pos = getPos (selectRandom _roads);
};
private _veh = createVehicle [_veh_type, _safe_pos, [], 0, "CAN_COLLIDE"];

private _suicider = _group createUnit [_type_units, _pos, [], 0, "CAN_COLLIDE"];
_suicider moveinDriver _veh;
_suicider assignAsDriver _veh;
_suicider setVariable ["btc_target_fob", _structure]; //necessary for WP in new group correction.

//Waypoints and Range check
[_group] call CBA_fnc_clearWaypoints;
[_group, _structure, -1, "MOVE", "CARELESS", "BLUE", "FULL", "NO CHANGE", "this spawn btc_ied_fnc_suicider_fobCountdown", nil, 150] call CBA_fnc_addWaypoint;

//EH killed
_suicider addEventHandler ["Killed", {
	params ["_unit"];
	for "_i" from 0 to 6 do {
		_bomb = createVehicle ["Bo_GBU12_LGB", (objectParent _unit) getPos [10, random 360], [], 0, "CAN_COLLIDE"]; 
		_bomb setDamage 1;
		hideObjectGlobal _bomb; 
	};
	
	[format["FOB suicider %1 blew sky fucking high", _suicider], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
}];

if (btc_debug) then {
	private _marker = createMarker [format ["btc_ied_fob_suicider%1", _suicider], _safe_pos];
	_marker setMarkerType "mil_warning";
	_marker setMarkerColor "ColorOrange";
	_marker setMarkerText "FOB Suicider";
	_marker setMarkerSize [0.8, 0.8];
};

_group
