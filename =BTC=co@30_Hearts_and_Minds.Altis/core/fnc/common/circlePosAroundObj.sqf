
/* ----------------------------------------------------------------------------
Function: btc_fnc_circlePosAroundObj

Description:
	Get positions anticlockwise around object transformed to its direction 

Parameters:
    _captive -
	_object -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_fnc_circlePosAroundObj;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_object", objNull, [objNull]],
    ["_angle", 90, [90]], //negate angle to turn clockwise
    ["_radius", 2, [0]]
];

if(isNull _object) exitWith {
    ["_object is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
    []
};
if(_radius <= 0) then {
    ["invalid _radius equal or below zero", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
    _radius = 2;
};

private _positions = [];
private _vectorDir = vectorDir _object;

for "_i" from 1 to round(360/(abs _angle)) do {
    
    private _theta = _angle * _i;
    
    private _rotated_vector = [        
        [_vectorDir select 0, _vectorDir select 1],
        _theta
    ] call BIS_fnc_rotateVector2D;
    _rotated_vector set [2, 0];

    _positions pushBackUnique _rotated_vector; //prevent overlap
};

private _pos = getPosATL _object;
_positions = _positions apply {
    _pos vectorAdd (_x vectorMultiply _radius);
};

_object setVariable ["btc_jail_positions", _positions, true]; //store positions for later use

_positions