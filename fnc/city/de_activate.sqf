
/* ----------------------------------------------------------------------------
Function: btc_city_fnc_de_activate

Description:
    Deactivate the city by storing all groups present inside and clean up dead bodies.

Parameters:
    _city - City to deactivate. [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_city_fnc_de_activate;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_city", objNull, [objNull]]
];

if !(_city getVariable ["active", false]) exitWith {};

if (btc_debug) then {
    private _id = _city getVariable "id";
    [str _id, __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//Save all and delete
private _cachingRadius = _city getVariable ["cachingRadius", 0];
private _has_en = _city getVariable ["occupied", false];

if (_has_en) then {
    private _trigger = _city getVariable ["enTrigger", objNull];
    deleteVehicle _trigger;
};

private _pos_city = getPosWorld _city;
private _data_units = [];
private _has_suicider = false;
allGroups apply {
    if (
        (leader _x) inArea [_pos_city, _cachingRadius, _cachingRadius, 0, false] &&
        {side _x != btc_player_side} &&
        {!(_x getVariable ["no_cache", false])} &&
        {_x getVariable ["btc_city", _city] in [_city, objNull]}
    ) then {
        private _data_group = _x call btc_data_fnc_get_group;
        _data_units pushBack _data_group;

        if ((_data_group select 0) in [5, 7]) then {_has_suicider = true;};
    };
};

private _data_animals = [];
agents apply {
    private _agent = agent _x;
    if (
        _agent inArea [_pos_city, _cachingRadius, _cachingRadius, 0, false] &&
        {alive _agent} &&
        {!(_x getVariable ["no_cache", false])} &&
        {_x getVariable ["btc_city", _city] in [_city, objNull]}
    ) then {
        _data_animals pushBack [
            typeOf _agent,
            getPosATL _agent
        ];
        _agent call CBA_fnc_deleteEntity;
    };
};

private _data_tags = [];
(btc_tags_server inAreaArray [_pos_city, _cachingRadius, _cachingRadius]) apply {
    if (_x getVariable ["btc_city", _city] isEqualTo _city) then {
        private _pos = getPos _x;
        _pos set [2, 0];
        _data_tags pushBack [
            _pos,
            [vectorDir _x, vectorUp _x],
            _x getVariable "btc_texture",
            typeOf _x
        ];
        _x call CBA_fnc_deleteEntity;
    };
};
btc_tags_server = btc_tags_server - [objNull];

(btc_vehicles inAreaArray [_pos_city, _cachingRadius, _cachingRadius]) apply {
    [_x] call btc_tag_fnc_vehicle; 
};

(_city getVariable ["btc_city_intels", []]) call CBA_fnc_deleteEntity;
(_city getVariable ["btc_civ_flowers", []]) call CBA_fnc_deleteEntity;

private _supplies = _city getVariable ["supplies", []];
_supplies apply {
    (attachedObjects _x) apply {deleteVehicle _x};
    deleteVehicle _x
};
_city setVariable ["supplies", []];


if (btc_debug_log) then {
    [format ["count data_units = %1", count _data_units], __FILE__, [false]] call btc_debug_fnc_message;
    [format ["count data_animals = %1", count _data_animals], __FILE__, [false]] call btc_debug_fnc_message;
    [format ["count data_tags = %1", count _data_tags], __FILE__, [false]] call btc_debug_fnc_message;
    [format ["count data_supplies = %1", count (_city getVariable ["data_supplies", []])], __FILE__, [false]] call btc_debug_fnc_message;
};

_city setVariable ["has_suicider", _has_suicider];
_city setVariable ["data_units", _data_units];
_city setVariable ["data_animals", _data_animals];
_city setVariable ["data_tags", _data_tags];
_city setVariable ["active", false];

[] call btc_mil_fnc_check_cap;

[] call btc_city_fnc_cleanUp;
