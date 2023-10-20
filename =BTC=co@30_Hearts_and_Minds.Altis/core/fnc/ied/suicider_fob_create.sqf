
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
#define TRG_RANGE 150

params [
    ["_city", objNull, [objNull]],
	["_structure", objNull, [objNull]],
    ["_type_units", "", [""]]
];

if (_type_units isEqualTo "") then {
    _type_units = selectRandom btc_civ_type_units;
};

private _pos = getPosASL _city;

private _group = createGroup [btc_enemy_side, true];
_group setVariable ["btc_city", _city];
_group setVariable ["acex_headless_blacklist", true];
_group setVariable ["suicider", true];

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
[_suicider] joinSilent _group;
_suicider moveinDriver _veh;
_suicider assignAsDriver _veh;
_suicider setVariable ["btc_target_fob", _structure]; //necessary for WP correction.

//Waypoints and Range check
[_group] call CBA_fnc_clearWaypoints;
[_group, _structure, -1, "MOVE", "CARELESS", "BLUE", "FULL", "NO CHANGE", "this call btc_ied_fnc_suicider_fobLoop", nil, TRG_RANGE] call CBA_fnc_addWaypoint;

//EH killed
_suicider addEventHandler ["Killed", {
	params ["_unit"];

	_pos = getPos (objectParent _unit);

	for "_i" from 0 to 6 do {
		_bomb = createVehicle ["Bo_GBU12_LGB_MI10", _pos getPos [10, random 360], [], 0, "CAN_COLLIDE"]; 
		_bomb setDamage 1;
		hideObjectGlobal _bomb; 
	};

	(attachedObjects _unit) call CBA_fnc_deleteEntity;
	[_pos] call btc_deaf_fnc_earringing;
	[_pos] remoteExecCall ["btc_ied_fnc_effects", [0, -2] select isDedicated];

	[format["FOB suicider %1 blew sky fucking high", _suicider], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
}];

//Eye-candy
_suicider addItem "ACE_DeadManSwitch"; //For RP purposes, toDo: might connect this to real explosives in the future
private _expl1 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl1 attachTo [_suicider, [-0.1, 0.1, 0.15], "Pelvis", true];
private _expl2 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl2 attachTo [_suicider, [0, 0.15, 0.15], "Pelvis", true];
private _expl3 = "DemoCharge_Remote_Ammo" createVehicle (position _suicider);
_expl3 attachTo [_suicider, [0.1, 0.1, 0.15], "Pelvis", true];
[_expl1, _expl2, _expl3] remoteExecCall ["btc_ied_fnc_belt", 0];

if (btc_debug) then {
	private _marker = createMarker [format ["btc_ied_fob_suicider%1", _suicider], _safe_pos];
	_marker setMarkerType "mil_warning";
	_marker setMarkerColor "ColorOrange";
	_marker setMarkerText "FOB Suicider";
	_marker setMarkerSize [0.8, 0.8];
};

_group
