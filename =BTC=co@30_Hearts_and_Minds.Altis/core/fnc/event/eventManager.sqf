
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
    Fyuran

---------------------------------------------------------------------------- */
#define EVENT_FOB_ATTACK 0

params[
    ["_event", -1, [0]],
    ["_params", []]
];

if(btc_event_beingHandled) exitWith {false}; //avoid multiple event calls
if(btc_event_activeEvents >= btc_p_event_maxEvents) exitWith { //compared to btc_p_event_maxEvents
    ["Too many active events", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//private _en_cities = values btc_city_all select {_x getVariable ["occupied", false]};

btc_event_beingHandled = true;
btc_event_beingHandled = switch (_event) do {
    case EVENT_FOB_ATTACK : {
        if(btc_p_event_enable_fobAttack) then {_params call btc_event_fnc_attackFOB;}
    }; 
    default {
        [format["event type %1 is not implemented or wrong", _event], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
        false
    };
};

btc_event_beingHandled