#include "..\script_macros.hpp"
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
    case DIK_T: {
        btc_log_yaw = 0;
        btc_log_roll = 0;
        btc_log_pitch = 0;
        btc_log_placing_h = ((ASLtoAGL (eyePos player))#2) - 0.5;
    };
    default {_keyPressed = false;};
};

if (_keyPressed) then {
    btc_log_placing_obj attachTo [player, [0, btc_log_placing_d, btc_log_placing_h]];
    [btc_log_placing_obj, [btc_log_yaw, btc_log_pitch, btc_log_roll]] call BIS_fnc_setObjectRotation;

    #ifdef BTC_DEBUG_LOG
    [["%1: key %2(turbo:%3) pressed, rotating by [%4, %5, %6], height set to [%7]", __FILE_NAME__, 
    _key, _turbo isEqualTo 1, btc_log_yaw, btc_log_pitch, btc_log_roll, btc_log_placing_h], 2, "log"] call FUNC(debug,message);
    #endif
};

_keyPressed
