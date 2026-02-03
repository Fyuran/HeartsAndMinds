#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_eventManager

Description:
   Handles events
Parameters:

Returns:

Examples:
    (begin example)
        [0, cursorObject] call btc_event_fnc_eventManager;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */

params[
    ["_event", -1, [0]],
    ["_params", []]
];

if(btc_event_cooldown > CBA_missionTime) exitWith {
    #ifdef BTC_DEBUG_EVENT
    [format["%1: Not ready yet: CD:%2, CBA_missionTime: %3, Remaining: %4", __FILE_NAME__, 
        btc_event_cooldown, CBA_missionTime, btc_event_cooldown - CBA_missionTime], 2, "event"] call btc_debug_fnc_message;
    #endif
    false
};

if(btc_event_beingHandled) exitWith {false}; //avoid multiple event calls
if(btc_event_activeEvents >= btc_p_event_maxEvents) exitWith { //compared to btc_p_event_maxEvents
    #ifdef BTC_DEBUG_EVENT
    [["%1: Too many active events", __FILE_NAME__], 2, "event"] call btc_debug_fnc_message;
    #endif
};

btc_event_beingHandled = true;
btc_event_beingHandled = switch (_event) do {
    case _EVENT_FOB_ATTACK_ : {
        if(btc_p_event_enable_fobAttack) then {_params call btc_event_fnc_canFOBBeAttacked;}
    }; 
    default {
        #ifdef BTC_DEBUG_EVENT
        [["%1: event type %2 is not implemented or wrong", __FILE_NAME__, _event], 6, "event"] call btc_debug_fnc_message;
        #endif
        false
    };
};

btc_event_beingHandled