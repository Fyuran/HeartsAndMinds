
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_eventManager

Description:
   Handles random events across the map, this fnc is first called in init_server.sqf
   btc_event_activated is defined in mission.sqf;
Parameters:

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
private _en_cities = values btc_city_all select {_x getVariable ["occupied", false]};
private _delay = 30; //toDo: delay should scale based on remaining _en_cities and btc_global_reputation

[{
    if(btc_event_activated) exitWith {
        [] call btc_event_fnc_eventManager;
        ["btc_event_fnc_eventManager event is already on... returning", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    };
    switch (round random 0) do {
        case 0 : {btc_event_activated = [] call btc_event_fnc_attackFOB;};
    };
    ["btc_event_fnc_eventManager delay over", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;

}, [], _delay] call CBA_fnc_waitAndExecute;

["btc_event_fnc_eventManager called", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;