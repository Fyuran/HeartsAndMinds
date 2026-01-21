#include "..\script_macros.hpp"
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

params [
    ["_healer", objNull, [objNull]]
];

if (isPlayer _healer) then {
    [_healer, _CIV_HEALED_] call btc_rep_fnc_change;

    #ifdef BTC_DEBUG_REP
    [["%1: GREP %2 THIS = %3", __FILE_NAME__, btc_global_reputation, _this], 2, "rep"] call btc_debug_fnc_message;
    #endif
};
