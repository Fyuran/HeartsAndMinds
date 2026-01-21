#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_hideout_fnc_create

Description:
    Create hideout randomnly or with defined position.

Parameters:
    _pos - Position of the hideout. [Array]
    _id_hideout - Id of the hideout. [Number]
    _rinf_time - Not used. [Number]
    _cap_time - Time for next capture of city around. [Number]
    _id - Id of the city where the hideout is. [Number]
    _markers_saved - Markers found by players. [Array]

Returns:

Examples:
    (begin example)
        [] call btc_hideout_fnc_create;
    (end)
    (begin example)
        selectMin (btc_hideouts apply {
            private _ho = _x;
            selectMin ((btc_hideouts - [_ho]) apply {_x distance _ho})
        })
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_pos", [], [[]]],
    ["_id_hideout", count btc_hideouts, [0]],
    ["_rinf_time", time, [0]],
    ["_cap_time", time - btc_hideout_cap_time, [0]],
    ["_id", 0, [0]],
    ["_markers_saved", [], [[]]]
];

private _city = objNull;
if (_pos isEqualTo []) then {
    private _useful = values btc_city_all select {
        !(_x getVariable ["active", false]) &&
        {_x distance (getMarkerPos btc_respawn_marker) > btc_hideout_safezone} &&
        {!(_x getVariable ["has_ho", false])} &&
        {_x getVariable ["type", ""] in ["NameLocal", "Hill", "NameVillage", "Airport"]}
    };
    private _inHoRange = values btc_city_all select {
        private _city = _x;
        (selectMin (btc_hideouts apply {_x distance _city})) < btc_hideout_minRange
    };
    private _usefulRange = _useful - _inHoRange;
    if (_usefulRange isEqualTo []) then {
        _city = selectRandom _useful;
    } else {
        _city = selectRandom _usefulRange;
    };

    private _cachingRadius = _city getVariable ["cachingRadius", 0];
    private _random_pos = [getPos _city, _cachingRadius/2] call btc_fnc_randomize_pos;
    _pos = [_random_pos, 0, 100, 2, false] call btc_fnc_findsafepos;

    _id = _city getVariable ["id", 0];
} else {
    _city = btc_city_all get _id;
};
_city setVariable ["occupied", true];
_city setVariable ["has_ho", true];
_city setVariable ["ho_units_spawned", false];

if(isNil "_city" || isNull _city) exitWith {
    #ifdef BTC_DEBUG_HIDEOUT
	[["%1: _city is null with args: %2", __FILE_NAME__, _this], 6, "hideout"] call btc_debug_fnc_message;
    #endif
};

_city setVariable ["city_realPos", getPos _city];
_city setPos _pos;

[_city, btc_hideouts_radius] call btc_city_fnc_setPlayerTrigger;
[{
    (_this select 0) findEmptyPositionReady (_this select 1)
}, {}, [_pos, [0, _city getVariable ["cachingRadius", 100]]], 5 * 60] call CBA_fnc_waitUntilAndExecute;

private _hideout = [_pos] call btc_hideout_fnc_create_composition;
clearWeaponCargoGlobal _hideout;
clearItemCargoGlobal _hideout;
clearMagazineCargoGlobal _hideout;
clearBackpackCargoGlobal _hideout;

_hideout setVariable ["id", _id_hideout];
_hideout setVariable ["rinf_time", _rinf_time];
_hideout setVariable ["cap_time", _cap_time];
_hideout setVariable ["assigned_to", _city];

_hideout addEventHandler ["HandleDamage", btc_hideout_fnc_hd];
_hideout setVariable ["ace_cookoff_enable", false, true];

private _markers = [];
{
    _x params ["_pos", "_marker_name"];

    private _marker = createMarkerLocal [format ["%1", _pos], _pos];
    _marker setMarkerTypeLocal "hd_warning";
    _marker setMarkerTextLocal _marker_name;
    _marker setMarkerSizeLocal [0.5, 0.5];
    _marker setMarkerColor "ColorRed";
    _markers pushBack _marker;
} forEach _markers_saved;

_hideout setVariable ["markers", _markers];

#ifdef BTC_DEBUG_HIDEOUT
[["%1: _this = %2 ; POS %3 ID %4", __FILE_NAME__, _this, _pos, count btc_hideouts], 2, "hideout"] call btc_debug_fnc_message;
#endif
btc_hideouts pushBack _hideout;
publicVariable "btc_hideouts";

true
