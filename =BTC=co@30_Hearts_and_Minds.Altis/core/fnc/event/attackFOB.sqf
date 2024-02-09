
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOB

Description:
   Initiates a check that will determine if this FOB is a potential target for the FOB Attack Event.

Parameters:
    _activator - who activated this event [ObjNull]

Returns:
    [BOOLEAN] - returns false when it's not being handled anymore

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define FOB_ATTACK_TASK_TYPE 42
#define EVENT_COOLDOWN 600

if(!params[
	["_structure", ObjNull, [ObjNull]]
]) exitWith {
    ["_structure is null", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message; 
    false
};
private _return = false; //used to tell eventmanager event is not being handled anymore

private _isUnderAttack = _structure getVariable ["FOB_Event", false];
if(_isUnderAttack) exitWith { //avoids multiple FOB events
    [format["event fob attack already active on %1", _structure getVariable["FOB_name", ""]], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    _return
};

private _nearCities = values btc_city_all select {
    (_x distance2D _structure) <= btc_fob_attackRadius && 
    {_x getVariable ["occupied", false] && !(_x getVariable ["active", false])}
}; 
if (_nearCities isEqualTo []) exitWith {
    [format["_nearCities is empty, skipping FOB: %1", _structure getVariable["FOB_name", ""]] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};

//Disables Respawn and Redeploy
private _flag = _structure getVariable["FOB_Flag", objNull];
_flag setVariable["FOB_Event", true, true]; //publicVariable for clients to handle ace interaction menu condition check
_structure setVariable ["FOB_Event", true];
_BIS_respawn_EH = _structure getVariable["FOB_Respawn_EH", []];
_BIS_respawn_EH call BIS_fnc_removeRespawnPosition;

/*
Notifications or task based on reputation(default values)
    btc_rep_level_veryLow = 0;
    btc_rep_level_low = 200;
    btc_rep_level_normal = 500;
    btc_rep_level_high = 750;
*/
switch true do {
    case (btc_global_reputation >= btc_rep_level_high): {
        ["WarningDescription", ["", localize "$STR_BTC_HAM_EVENT_FOBATTACK_DESC"]] call btc_task_fnc_showNotification_s;
        _fob_task_name = format["btc_task_%1", _structure getVariable ["FOB_name", ""]];
        [_fob_task_name, FOB_ATTACK_TASK_TYPE, _structure, btc_fob_structure, true, true] call btc_task_fnc_create;
    };
    case (btc_global_reputation < btc_rep_level_high && {btc_global_reputation >= btc_rep_level_veryLow}): {
        ["FOBlowRepWarningDescription", ["", format[
            localize "$STR_BTC_HAM_EVENT_EASTWIND",
            _structure getVariable ["FOB_name", ""]
        ]]] call btc_task_fnc_showNotification_s;
    };
};


//Group spawning and prep for CBA_fnc_waitUntilAndExecute's condition statement
private _groups = [_structure, _nearCities] call btc_event_fnc_attackFOBspawn;
_structure setVariable["FOB_Event_grps", _groups];

/*
    I hate this clusterfuck but all groups are spawned after a set delay 
    and it would result in an empty units array therefore the condition would be true before they even spawned
*/
[{
    [format["%1 victory manager is on", (_this select 0) getVariable["FOB_name", ""]], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    
    params["_structure", "_flag", "_groups"];
    _units = [];
    _groups apply {_units append units _x};

    _statement = {
        params["_structure", "_flag", "_groups"];
        _flag setVariable["FOB_Event", false, true]; //publicVariable for clients to handle ace interaction menu condition check
        _structure setVariable ["FOB_Event", false];
        
        _fob_task_name = format["btc_task_%1", _structure getVariable ["FOB_name", ""]];
        [_fob_task_name, "SUCCEEDED"] call btc_task_fnc_setState;
        [_fob_task_name, btc_player_side, true] call BIS_fnc_deleteTask;
        
        _groups apply {_x call btc_data_fnc_add_group;};

        _FOB_name = _structure getVariable["FOB_name", ""];
        _BISEH_return = [btc_player_side, _flag, _FOB_name] call BIS_fnc_addRespawnPosition;
        _structure setVariable["FOB_Respawn_EH", _BISEH_return];

        btc_event_activeEvents = (0 max (btc_event_activeEvents - 1));

    };

    // TASK_SUCCEEDED when only a part of enemy troops are remaining
    [{// also has timeout in case of Arma's AI fuckery
        ({alive _x} count (_this select 3)) <= (_this select 4)
    }, _statement, [_structure, _flag, _groups, _units, floor((count _units)/2.5)], 300*(count _groups), _statement
    ] call CBA_fnc_waitUntilAndExecute;

}, [_structure, _flag, _groups], 2*(count _groups)] call CBA_fnc_waitAndExecute;



btc_event_activeEvents = btc_event_activeEvents + 1;
btc_event_cooldown = CBA_missionTime + EVENT_COOLDOWN;


_return
