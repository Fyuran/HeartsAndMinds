/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_spawn_group
	
	Description:
	    Create group previously saved by btc_json_fnc_get_group_data.
	
	Parameters:
	    _data_unit - All data listed above. [Array]
	        _type_db - type of group (3: in house group, 4: civilian with weapon, 5: suicider ...). [Number]
	        _array_pos - position on units. [Array]
	        _array_type - type of units. [Array]
	        _side - side of the group. [side]
	        _array_dam - damage of units. [Array]
	        _behaviour - behaviour of units. [Array]
	        _array_wp - waypoints of group. [Array]
	        _array_veh - vehicle occupied by the group. [Array, String]
	    _city - City. [Object]
	    _spawningRadius - Spawning radius. [Number]
	
	Returns:
	    _delay - Delay due to vehicle spawn. [Number]
	
	Examples:
	    (begin example)
	        _result = [] call btc_json_fnc_spawn_group;
	    (end)
	
	Author:
	    Giallustio
	
---------------------------------------------------------------------------- */
// 0:unit? VEH:1, 2:??? inHOUSE groups:3, CIVgetWeapons:4, suicider:5, CIV:6, drone:7

params [
	["_data_unit", [], [createHashMap]],
	["_city", objNull, [objNull]],
	["_spawningRadius", 100, [0]]
];

(values _data_unit) params ((keys _data_unit) apply {"_" + _x}); //keys lack the local scope definer '_'

if(typeName _side == "STRING") then {
	_side = switch(_side) do {
		case"EAST": {east};
		case"WEST": {west};
		case"CIV": {civilian};
		case"GUER": {independent};

		default {btc_enemy_side};
	};
};

private _delay = 0;
if (_type_db isEqualTo "SUICIDER") exitWith {
	[[_city, _spawningRadius, _pos, _array_type select 0], btc_ied_fnc_suicider_create] call btc_delay_fnc_exec;
	_delay + btc_delay_unit
};
if (_type_db isEqualTo "DRONE") exitWith {
	[[_city, _spawningRadius, _pos], btc_ied_fnc_drone_create] call btc_delay_fnc_exec;
	_delay + btc_delay_unit
};

private _group = createGroup _side;
_group setVariable ["btc_city", _city];
if (_type_db isEqualTo "VEHICLE") then {
	_array_veh params ["_typeOf", "_posATL", "_dir", "_fuel", ["_vectorUp", []]];
	_delay = [_group, _typeOf, _array_type, _posATL, _dir, _fuel, _vectorUp] call btc_delay_fnc_createVehicle;
} else {
	_array_type apply {
		[_group, _x, _pos, "CAN_COLLIDE"] call btc_delay_fnc_createUnit;
	};
};

[{
	params ["_data_unit", "_group", "_spawningRadius", "_city"];
	(values _data_unit) params ((keys _data_unit) apply {"_" + _x});
	if(btc_debug) then {
		[format ["json_spawn_group = %1 of %2", _this, _city getVariable ["name", "noName"]], __FILE__, [false]] call btc_debug_fnc_message;
	};

	switch(_type_db) do {
		case "SURRENDERED": {
			(units _group) apply {[_x, true] call ace_captives_fnc_setSurrendered;};
		};
		case "CIVILIANS": {
			[_group, _array_veh select 0] call btc_civ_fnc_addWP;
			_group setVariable ["btc_data_inhouse", _array_veh];
		};
		case "CIV_GETWEAPONS": {
			[[0, 0, 0], 0, units _group] call btc_civ_fnc_get_weapons;
		};
		case "HOUSE": {
			[_group, nearestObject [_pos, _array_veh]] call btc_fnc_house_addWP;
			_group setVariable ["btc_inHouse", _array_veh];
		};
		default {
			[_group] call CBA_fnc_clearWaypoints;
			[_group, _city, _spawningRadius, _wp_type] call btc_mil_fnc_addWP;
		};
	};

}, [_data_unit, _group, _spawningRadius, _city], _delay] call btc_delay_fnc_waitAndExecute;

_delay