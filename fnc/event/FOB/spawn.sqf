
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOBspawn

Description:
   Spawn units for FOB Attack Event.

Parameters:
    _building - FOB
    _nearCities - Locations to spawn enemies from

Returns:
    [BOOLEAN] - returns false when it's not being handled anymore

Examples:
    (begin example)
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#include "..\..\script_macros.hpp"

if(!params[
    ["_building", objNull, [objNull]],
    ["_nearCities", [], [[]]]
]) exitWith {["Bad params", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message; false};

private _nearCities = [_nearCities, [_building], { _input0 distance2D _x }, "ASCEND"] call BIS_fnc_sortBy;
private _countCities = count _nearCities;
private _maxGrps = ceil (1 + ((_countCities) * btc_p_mil_group_ratio));

private _groups = [];
for "_i" from 0 to _maxGrps do { 
    private _city = _nearCities select (_i % _countCities); //modulo % forbids from selecting out of range elements by looping back when it exceeds _countCities
    if(count _groups >= _FOB_MAX_GROUPS_) then {break;};

    _grp = [_city, _building, _FOB_ATTACK_PATROL_TYPE_] call btc_mil_fnc_send;
    _groups pushBack _grp;
    [format["%1 is being sent to %2, distance: %3", _grp, _building getVariable["FOB_name", ""], _city distance2D _building] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    
    if(count _groups >= _FOB_MAX_GROUPS_) then {break;};
    _grp = [_city, _building, _FOB_ATTACK_PATROL_TYPE_] call btc_mil_fnc_send;
    _groups pushBack _grp;
   
   [format["%1 is being sent to %2, distance: %3", _grp, _building getVariable["FOB_name", ""], _city distance2D _building] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    if(count _groups >= _FOB_MAX_GROUPS_) then {break;};
};

if (btc_global_reputation < btc_rep_level_veryLow) then {
    private _city = selectRandom _nearCities;
    _grp = [_city, _building] call btc_ied_fnc_suicider_fob_create;
    _groups pushBack _grp;
    [format["%1 SUICIDER is being sent to %2, distance: %3", _grp, _building getVariable["FOB_name", ""], _city distance2D _building] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

_groups