
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_killed

Description:
    Delete FOB from the btc_fobs array and remove the flag.

Parameters:
    _struc - Object the event handler is assigned to. [Object]
    _killer - Object that killed the unit. Contains the unit itself in case of collisions. [Object]
    _instigator - Person who pulled the trigger. [Object]
    _delete - Delete the FOB/Rallypoint. [Boolean]
    _useEffects - Same as useEffects in setDamage alt syntax. [Boolean]
    _fobs - Array containing FOB data. [Array]

Returns:
    _this - Arguments passed. [Array]

Examples:
    (begin example)
        _result = [btc_fobs select 1 select 0] call btc_fob_fnc_killed;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_struc", objNull, [objNull]],
    ["_killer", objNull, [objNull]],
    ["_instigator", objNull, [objNull]],
    ["_useEffects", true, [true]],
    ["_delete", false, [true]],
    ["_fobs", btc_fobs, [[]]]
];

private _fob_index = (_fobs select 1) find _struc;
private _fob = (_fobs select 1) deleteAt _fob_index; //FOB_structure
private _fob_name = _fob getVariable ["FOB_name", "UNKNOWN"];

if (btc_debug) then {
    [format ["%1", _fob_name], __FILE__, [btc_debug, btc_debug_log]] call btc_debug_fnc_message;

    private _triggerMrks = (_fob getVariable["alarmTrgMarker", []]) + (_fob getVariable["destroyTrgMarker", []]);
    _triggerMrks apply {deleteMarker _x};
};

deleteMarker ((_fobs select 0) deleteAt _fob_index); //Markers

private _flag = ((_fobs select 2) deleteAt _fob_index); //Flags
deleteVehicle ((_fobs select 3) deleteAt _fob_index); //Loudspeakers
((_fobs select 4) deleteAt _fob_index) apply {deleteVehicle _x}; //Triggers
[_fob getVariable ["destroyTrgPFH", -1]] call CBA_fnc_removePerFrameHandler; //destroyTrg CBA PFH
_fob setVariable["cap_time", -1, true]; //Make sure all GUIs are closed
[_flag] call btc_jail_fnc_removeJail_s;
[_flag] call btc_log_fob_fnc_remove;

if(_fob getVariable ["FOB_Event", false]) then {
    _fob_task_name = format["btc_task_%1", _fob_name];
    if(_fob_task_name call BIS_fnc_taskExists) then {
        [_fob_task_name, "FAILED"] call btc_task_fnc_setState;
        [_fob_task_name, btc_player_side, true] call BIS_fnc_deleteTask;
    };
    
   btc_event_activeEvents = (0 max (btc_event_activeEvents - 1));
};

private _garrisonUnits = units (_fob getVariable ["btc_mil_garrison_group", []]);
if (!_delete) then {
    ["WarningDescriptionDefeated", ["", format[
        localize "$STR_BTC_HAM_REP_FOB_LOST",
        _fob_name
    ]]] call btc_task_fnc_showNotification_s;

    _garrisonUnits apply {[_x] call ace_medical_status_fnc_setDead};

    [_fob_name, _FOB_LOST_] call btc_rep_fnc_change;
} else {
    _garrisonUnits apply {deleteVehicle _x};
    
    [_fob_name, _FOB_DISMANTLED_] call btc_rep_fnc_change;
    deleteVehicle _fob;
};

deleteVehicle _flag;

_this
