
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_hh

Description:
    Change reputation when a player heal.

Parameters:
    _healer - Player healing. [Object]

Returns:

Examples:
    (begin example)
        [player] call btc_rep_fnc_hh;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_healer", objNull, [objNull]]
];

if (isPlayer _healer) then {
    [_healer, _CIV_HEALED_] call btc_rep_fnc_change;

    if (btc_debug_log) then {
        [format ["GREP %1 THIS = %2", btc_global_reputation, _this], __FILE__, [false]] call btc_debug_fnc_message;
    };
};
