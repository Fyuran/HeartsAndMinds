
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOBChance

Description:
   Random chance

Parameters:

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_city", objNull, [objNull]]
];

private _fobs = btc_fobs param [1, [], [[]]]; //btc_fobs syntax is [[markers...],[fob_structures..]...]
if(_fobs isEqualTo []) exitWith {
    ["btc_fobs is empty", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

// if (_city inArea [getMarkerPos "btc_base", btc_fob_minDistance, btc_fob_minDistance, 0, false]) exitWith {
//     [format["%1 is too close to btc_base, aborting", getPosASL _city], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
// };

private _nearCities = values btc_city_all select {
    (_x distance2D _structure) <= btc_fob_attackRadius && 
    {_x getVariable ["occupied", false]}
}; 
private _hideouts = _nearCities select {
    _x getVariable ["has_ho", false]
};

//in case only one hideout is found, make sure it is used to double the chance, 1 would be wasted in this specific case
private _hideoutsCount = if(count _hideouts isEqualTo 0) then {1} else {2 max (count _hideouts)};

//normalize both values into a 0-1 range
private _rep = linearConversion[0, btc_rep_level_high, btc_global_reputation, 0, 1, true];
private _cities = linearConversion[0, count values btc_city_all, count _nearCities * _hideoutsCount, 0, 1, true];

if(random[0, _cities, 1] > random[0, _rep, 1]) then {
    private _structure = [_fobs, _city] call BIS_fnc_nearestPosition;
    [_EVENT_FOB_ATTACK_, _structure] call btc_event_fnc_eventManager;
};