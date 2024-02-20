
/* ----------------------------------------------------------------------------
Function: btc_db_fnc_enabled_city_save

Description:
    Correctly saves data on activated cities 
    and making sure nothing is deleted unlike from city_deactivate.

Parameters:
    _city - City to deactivate. [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_db_fnc_enabled_city_save;
    (end)

Author:
    Giallustio & Fyuran

---------------------------------------------------------------------------- */

params [
    ["_city", objNull, [objNull]]
];

if (btc_debug) then {
    private _id = _city getVariable "id";
    [str _id, __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//Save all
private _cachingRadius = _city getVariable ["cachingRadius", 0];

private _pos_city = getPosWorld _city;
private _data_units = [];
private _has_suicider = false;
{
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
} forEach allGroups;

private _data_animals = [];
{
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
    };
} forEach agents;

private _data_tags = [];
{
    if (_x getVariable ["btc_city", _city] isEqualTo _city) then {
        private _pos = getPos _x;
        _pos set [2, 0];
        _data_tags pushBack [
            _pos,
            [vectorDir _x, vectorUp _x],
            _x getVariable "btc_texture",
            typeOf _x
        ];
    };
} forEach (btc_tags_server inAreaArray [_pos_city, _cachingRadius, _cachingRadius]);

if (btc_debug_log) then {
    [format ["count data_units = %1", count _data_units], __FILE__, [false]] call btc_debug_fnc_message;
    [format ["count data_animals = %1", count _data_animals], __FILE__, [false]] call btc_debug_fnc_message;
    [format ["count data_tags = %1", count _data_tags], __FILE__, [false]] call btc_debug_fnc_message;
};

_city setVariable ["has_suicider", _has_suicider];
_city setVariable ["data_units", _data_units];
_city setVariable ["data_animals", _data_animals];
_city setVariable ["data_tags", _data_tags];