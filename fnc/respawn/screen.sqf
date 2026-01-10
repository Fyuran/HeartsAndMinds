#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_respawn_fnc_screen

Description:
    If no tickets force the player to respawn and allow the use of spectator mode.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_respawn_fnc_screen;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

if (btc_p_respawn_ticketsAtStart isEqualTo -1) exitWith {};

if ([btc_player_side] call BIS_fnc_respawnTickets isEqualTo 0) then {
    [
        {btc_intro_done},
        btc_respawn_fnc_force
    ] call CBA_fnc_waitUntilAndExecute;
};

if !(btc_p_respawn_ticketsShare) then {
    [
        {[player] call BIS_fnc_respawnTickets isNotEqualTo -1},
        {
            #ifdef BTC_DEBUG_RESPAWN
            [["%1: _respawnTickets %2", __FILE_NAME__, [player] call BIS_fnc_respawnTickets], 2, "respawn"] call btc_debug_fnc_message;
            #endif
            if ([player] call BIS_fnc_respawnTickets > 0) exitWith {};
            [
                {btc_intro_done},
                btc_respawn_fnc_force
            ] call CBA_fnc_waitUntilAndExecute;
        }
    ] call CBA_fnc_waitUntilAndExecute;
};
