
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_spawn_group

Description:
    Create group previously saved by btc_json_fnc_get_group.

Parameters:
    _data_unit - All data listed above. [Array]
        _type - Type of group (3: in house group, 4: civilian with weapon, 5: suicider ...). [Number]
        _array_pos - Position on units. [Array]
        _array_type - Type of units. [Array]
        _side - Side of the group. [Side]
        _array_dam - Damage of units. [Array]
        _behaviour - Behaviour of units. [Array]
        _array_wp - Waypoints of group. [Array]
        _array_veh - Vehicle occupied by the group. [Array, String]
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
//0:unit? VEH:1, 2:??? inHOUSE groups:3, CIVgetWeapons:4, suicider:5, CIV:6, drone:7
params [
    ["_data_unit", [], [createHashMap]],
    ["_city", objNull, [objNull]],
    ["_spawningRadius", 100, [0]]
];
(values _data_unit) params [
    ["_type", "VEHICLE", [""]],
    ["_array_pos", [], [[]]],
    ["_array_type", [], [[]]],
    ["_side", east, [east]],
    ["_array_veh", [], [[], ""]]
];

private _delay = 0;
if (_type isEqualTo "SUICIDER") exitWith {
    [[_city, _spawningRadius, _array_pos select 0, _array_type select 0], btc_ied_fnc_suicider_create] call btc_delay_fnc_exec;
    _delay + btc_delay_unit
};
if (_type isEqualTo "DRONE") exitWith {
    [[_city, _spawningRadius, _array_pos select 0], btc_ied_fnc_drone_create] call btc_delay_fnc_exec;
    _delay + btc_delay_unit
};

private _group = createGroup _side;
_group setVariable ["btc_city", _city];
if (_type isEqualTo "VEHICLE") then {
    _array_veh params ["_typeOf", "_posATL", "_dir", "_fuel", ["_vectorUp", []]];
    _delay = [_group, _typeOf, _array_type, _posATL, _dir, _fuel, _vectorUp] call btc_delay_fnc_createVehicle;
} else {
    for "_i" from 0 to (count _array_pos - 1) do {
        [_group, _array_type select _i, _array_pos select _i, "CAN_COLLIDE"] call btc_delay_fnc_createUnit;
        //_u setDamage (_array_dam select _i);
    };
};

[{
    params ["_data_unit", "_group"];
    _data_unit params [
        ["_type", "VEHICLE", [0]],
        ["_array_pos", [], [[]]],
        ["_array_type", [], [[]]],
        ["_side", east, [east]],
        ["_array_veh", [], [[], ""]]
    ];

    if !(_type in ["HOUSE", "CIVILIANS"]) then {
        [_group] call CBA_fnc_clearWaypoints;

    };
    if (_type isEqualTo "HOUSE") then {
        [_group, nearestObject [_array_pos select 0, _array_veh]] call btc_fnc_house_addWP;
        _group setVariable ["btc_inHouse", _array_veh];
    };
    if (_type isEqualTo "CIV_GETWEAPONS") then {[[0, 0, 0], 0, units _group] call btc_civ_fnc_get_weapons;};
    if (_type isEqualTo "CIVILIANS") then {
        [_group, _array_veh select 0] call btc_civ_fnc_addWP;
        _group setVariable ["btc_data_inhouse", _array_veh];
    };
}, [values _data_unit, _group], _delay] call btc_delay_fnc_waitAndExecute;

_delay
