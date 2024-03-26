
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_place_key_down

Description:
    https://community.bistudio.com/wiki/DIK_KeyCodes

Parameters:
    _display - [Display]
    _key - [Number]
    _shift - [Boolean]
    _ctrl - [Boolean]
    _alt - [Boolean]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_place_key_down;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_display", displayNull, [displayNull]],
    ["_key", 16, [0]],
    ["_shift", false, [false]],
    ["_ctrl", false, [false]],
    ["_alt", false, [false]]
];

if(_display != (findDisplay 46)) exitWith {};
private _turbo = [0, 1] select _shift;
private _keyPressed = true;

switch (_key) do
{
    case DIK_Q: {
        if !(btc_log_placing_h > 30) then {
            btc_log_placing_h = btc_log_placing_h + 0.1 + _turbo/2;
        };
    };
    case DIK_Z: {
        if !(btc_log_placing_h < - 30) then {
            btc_log_placing_h = btc_log_placing_h - 0.1 - _turbo/2;   
        };
    };
    case DIK_X: {btc_log_yaw = btc_log_yaw + 0.5 + _turbo;};
    case DIK_C: {btc_log_yaw = btc_log_yaw - 0.5 - _turbo;};
    case DIK_F: {btc_log_roll = btc_log_roll + 0.5 + _turbo;};
    case DIK_R: {btc_log_roll = btc_log_roll - 0.5 - _turbo;};
    case DIK_N: {btc_log_setToNormal = true};
    case DIK_T: {
        btc_log_yaw = 0;
        btc_log_roll = 0;
        btc_log_pitch = 0;
        btc_log_placing_h = 0;
    };
    default {_keyPressed = false;};
};

if (_keyPressed) then {
    if(!btc_log_setToNormal) then {
        [btc_log_placing_obj, [btc_log_yaw, btc_log_pitch, btc_log_roll]] call BIS_fnc_setObjectRotation;
    } else {
        _pos = getPosASL btc_log_placing_obj;
        _intersect = lineIntersectsSurfaces [_pos, [_pos#0, _pos#1, 0], btc_log_placing_obj];
        _intersect#0 params ["_intersectPosASL", "_surfaceNormal"];
        if(_intersect isEqualTo []) exitWith {};
        btc_log_placing_obj setVectorUp _surfaceNormal;

        _playerPosASL = getPosASL player;
        btc_log_placing_h = (_intersectPosASL vectorDiff _playerPosASL)#2;
        if(((ASLtoAGL _intersectPosASL) select 2) < 0) then {btc_log_placing_h = 0};
        btc_log_placing_obj attachTo [player, [0, btc_log_placing_d, btc_log_placing_h]];
        btc_log_setToNormal = false;
    };
    
    btc_log_placing_obj attachTo [player, [0, btc_log_placing_d, btc_log_placing_h]];

    if(btc_debug) then {
        [format["key %1(turbo:%2) pressed, rotating by [%3, %4, %5], height set to [%6]", 
        _key, _turbo isEqualTo 1, btc_log_yaw, btc_log_pitch, btc_log_roll, btc_log_placing_h],
        __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
};

_keyPressed
