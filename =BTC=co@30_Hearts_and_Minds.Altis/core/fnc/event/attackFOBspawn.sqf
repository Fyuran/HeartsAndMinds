
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOBspawn

Description:
   Spawn units for FOB Attack Event.

Parameters:
    _activator - who activated this event [ObjNull]

Returns:
    [BOOLEAN] - returns false when it's not being handled anymore

Examples:
    (begin example)
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

#define FOB_ATTACK_PATROL_TYPE 2

private _structure = param [0];

private _nearCities = values btc_city_all select {
    (_x distance2D _structure) <= btc_fob_attackRadius && 
    {_x getVariable ["occupied", false] && !(_x getVariable ["active", false])}
}; 
if (_nearCities isEqualTo []) exitWith {
    [format["_nearCities is empty, skipping FOB: %1", _structure getVariable["FOB_name", ""]] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};
_nearCities = [_nearCities, [_structure], { _input0 distance2D _x }, "ASCEND"] call BIS_fnc_sortBy;

private _maxGrps = ceil (1 + ((count _nearCities) * btc_p_mil_group_ratio)); //toDo: scale amount of groups on formula btc_global_reputation and occupied(enemy) cities
for "_i" from 0 to _maxGrps do { 
    private _city = _nearCities select (_i % count _nearCities); //modulo % forbids from selecting out of range elements by looping back when it exceeds count _nearCities
    _grp = [_city, _structure, FOB_ATTACK_PATROL_TYPE] call btc_mil_fnc_send;
    [format["%1 is being sent to %2, distance: %3", _grp, _structure getVariable["FOB_name", ""], _city distance2D _structure] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};