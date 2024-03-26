
/* ----------------------------------------------------------------------------
Function: btc_city_fnc_setPlayerTrigger

Description:
    Set trigger properties to detect player presence.

Parameters:
    _trigger - City. [Object]
    _cachingRadius - Radius of the location. [Number]

Returns:

Examples:
    (begin example)
        [_trigger, _cachingRadius] call btc_city_fnc_setPlayerTrigger;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_trigger", objNull, [objNull]],
    ["_cachingRadius", 0, [0]]
];

_trigger setTriggerArea [_cachingRadius + btc_city_radiusOffset, _cachingRadius + btc_city_radiusOffset, 0, false, 800];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
_trigger setTriggerStatements [btc_p_trigger, "thisTrigger call btc_city_fnc_activate", "thisTrigger call btc_city_fnc_de_activate"];