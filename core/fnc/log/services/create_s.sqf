#include "..\..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_create_s

Description:
    Creates vehicle with server ownership

Parameters:
    ["_class", "", [""]],
    ["_log_point", objNull, [objNull]]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_create_s;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_class", "", [""]],
    ["_log_point", objNull, [objNull]],
    ["_create_obj", objNull, [objNull]],
    ["_cost", 0, [0]]
];

if(_class isEqualTo "") exitWith {
    #ifdef BTC_DEBUG_LOG
    [["%1: _class is invalid", __FILE_NAME__], 6, "log/services"] call btc_debug_fnc_message;  
    #endif
};
if(isNull _log_point) exitWith {
    #ifdef BTC_DEBUG_LOG
    [["%1: _log_point is null", __FILE_NAME__], 6, "log/services"] call btc_debug_fnc_message;  
    #endif
};
if(isNull _create_obj) exitWith {
    #ifdef BTC_DEBUG_LOG
    [["%1: _create_obj is null", __FILE_NAME__], 6, "log/services"] call btc_debug_fnc_message;  
    #endif
};

private _canAfford = true;
if(_create_obj in btc_log_fob_create_objects) then {
    _canAfford = [_create_obj, _cost] call btc_log_fob_fnc_payment;
};
if(!_canAfford) exitWith {};

private _obj = createVehicle [_class, _log_point, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _log_point;
private _startPos = getPosASL _log_point;
private _firstLineIntersect = (lineIntersectsSurfaces [_startPos vectorAdd [0, 0, 100], _startPos vectorAdd [0, 0, -50], _obj, _log_point, true, 1, "GEOM", "FIRE", true]) select 0;
_obj setPosASL (_firstLineIntersect)#0;

if (unitIsUAV _obj) then {
    createVehicleCrew _obj;
};

[_obj] call btc_log_fnc_init;

