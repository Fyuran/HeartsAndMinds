
/* ----------------------------------------------------------------------------
Function: btc_fnc_isAreaOccupied

Description:
    Check if the area is clear.

Parameters:
    _pos - Object or Position to check around. [Object, Array]
    _distance - Distance around the object. [Number]

Returns:
    _isNotClear - Is not clear. [Boolean]

Examples:
    (begin example)
        _isNotClear = [btc_log_create_obj] call btc_fnc_isAreaOccupied;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_pos", [], [objNull, []]],
    ["_distance", 5, [0]]
];

if(_pos isEqualTo []) then {
    ["_pos is invalid", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _obj = objNull;
if(_pos isEqualType objNull) then {
    _obj = _pos; //hold ref to obj
    _pos = _pos modelToWorld [0,0,0]; //AGL
};

private _array = (nearestObjects [_pos, ["LandVehicle", "CAManBase", "Building", "ThingX"], _distance]) - [_obj];

if (  
    count _array > 0
) exitWith {
    (localize "STR_BTC_HAM_LOG_BASICS_CLEARAREA") call CBA_fnc_notify;
    true
};

false
