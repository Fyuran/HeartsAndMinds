
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
    ["_class is invalid", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _log_point) exitWith {
    ["_log_point is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _create_obj) exitWith {
    ["_create_obj is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _canAfford = true;
if(_create_obj in btc_log_fob_create_objects) then {
    _canAfford = [_create_obj, _cost] call btc_log_fob_fnc_payment;
};
if(!_canAfford) exitWith {};

private _obj = createVehicle [_class, _log_point, [], 0, "CAN_COLLIDE"];
_obj setDir getDir _log_point;
_pos = getPosATL _log_point;
_pos set [2,0]; //make sure it's sitting level to ground
_obj setVectorUp (surfaceNormal _pos);
_obj setPosATL _pos;

if (unitIsUAV _obj) then {
    createVehicleCrew _obj;
};

[_obj] call btc_log_fnc_init;

