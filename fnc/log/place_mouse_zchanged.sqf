
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_place_mouse_zchanged

Description:

Parameters:
    _display - [Display]
    _scroll - [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_place_mouse_zchanged;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_display", displayNull, [displayNull]], 
    ["_scroll", 0, [0]]
];

if(_display != (findDisplay 46)) exitWith { 0 };
if(_scroll isEqualTo 0) exitWith { 0 };

if(_scroll > 0) then {
    btc_log_placing_d = btc_log_placing_d + 0.5;
}else {
    btc_log_placing_d = btc_log_placing_d - 0.5;
};

if(btc_log_placing_d < 4) then {btc_log_placing_d = 4;}; //avoid collision with player
if(btc_log_placing_d > 30) then {btc_log_placing_d = 30;}; //maximum distance
btc_log_placing_obj attachTo [player, [0, btc_log_placing_d, btc_log_placing_h]];

if(btc_debug) then {
    [format[
        "scrolled %1 moving by [0, %2, %3]", _scroll, btc_log_placing_d, btc_log_placing_h
    ], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
};

_scroll