
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
#define SCALE 6
#define TRIGGER_SCALE 4
#define FOB_ATTACK_TASK_TYPE 42

if(!params[
	["_activator", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message; false};

if (_activator inArea [getMarkerPos "btc_base", btc_fob_minDistance, btc_fob_minDistance, 0, false]) exitWith {
    [format["%1 is too close to btc_base, aborting", getPosASL _activator], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};

private _fobs = btc_fobs param [1, [], [[]]]; //btc_fobs syntax is [[markers...],[fob_structures..],[fob_flags...],[fob_loudspeakers...], [[triggers...]]]
if(_fobs isEqualTo []) exitWith {
    ["_fobs is empty, are there any fobs yet?", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};
private _structure = [_fobs, _activator] call BIS_fnc_nearestPosition;
private _isUnderAttack = _structure getVariable ["FOB_underAttack", false];
if(_isUnderAttack) exitWith { //avoid multiple FOB attacks
    [format["event fob attack already active on %1", _structure getVariable["FOB_name", ""]], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};

[_structure] call btc_event_fnc_attackFOBspawn;

//Add second wave?


//Disable Respawn, Redeploy and add Task
_structure setVariable ["FOB_underAttack", true, true];
_BIS_respawn_EH = _structure getVariable["FOB_Respawn_EH", []];
_BIS_respawn_EH call BIS_fnc_removeRespawnPosition;
["btc_fob", FOB_ATTACK_TASK_TYPE, _structure, btc_fob_structure, true, true] call btc_task_fnc_create;
/*
if (_target getVariable["FOB_underAttack", false]) exitWith {
    [[localize "STR_BTC_HAM_O_FOB_CANTREDEPLOY"], [localize "STR_BTC_HAM_EVENT_FOBUNDERATTACK"]] call CBA_fnc_notify;
    false
};
*/

btc_event_activeEvents = btc_event_activeEvents + 1;
false