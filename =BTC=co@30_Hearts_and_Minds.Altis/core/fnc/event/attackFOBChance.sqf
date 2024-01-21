
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOBChance

Description:
   Random chance

Parameters:
    _activator - who activated this event [ObjNull]

Returns:
    [BOOLEAN] - returns false when it's not being handled anymore

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define EVENT_FOB_ATTACK 0

params[
    ["_city", objNull, [objNull]]
];
private _nearCities = values btc_city_all select {
    (_x distance2D _city) <= btc_fob_attackRadius && 
    {_x getVariable ["occupied", false]}
}; 
private _hideouts = _nearCities select {
    _x getVariable ["has_ho", false]
};
//in case only one hideout is found, make sure it is used to double the chance, 1 would be wasted in this specific case
private _hideoutsCount = if(count _hideouts isEqualTo 0) then {1} else {2 max (count _hideouts)};

//normalize both values into a 0-1 range
private _rep = linearConversion[0, btc_rep_level_high, btc_global_reputation, 0, 1, true];
private _cities = linearConversion[0, count values btc_city_all, count _nearCities * count _hideouts, 0, 1, true];

if(random[0, _cities, 1] > random[0, _rep, 1]) then {
    [EVENT_FOB_ATTACK, _city] call btc_event_fnc_eventManager;
};