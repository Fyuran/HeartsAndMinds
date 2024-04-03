
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
    Vdauphin

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

if (btc_debug || btc_debug_log) then {
    [format ["named %1", (_fobs select 0) select _fob_index], __FILE__, [btc_debug, btc_debug_log]] call btc_debug_fnc_message;
};

deleteMarker ((_fobs select 0) deleteAt _fob_index); //Markers
private _fob = (_fobs select 1) deleteAt _fob_index; //FOB_structure
private _flag = ((_fobs select 2) deleteAt _fob_index); //Flags
deleteVehicle ((_fobs select 3) deleteAt _fob_index); //Loudspeakers
((_fobs select 4) deleteAt _fob_index) apply {deleteVehicle _x}; //Triggers
[_fob getVariable ["CBAperFrameHandle", -1]] call CBA_fnc_removePerFrameHandler; //CBA PFH
_fob setVariable["fob_conquest_time", -1, true]; //Make sure all GUIs are closed
[_flag] call btc_jail_fnc_removeJail_s;

if(_fob getVariable ["FOB_Event", false]) then {
    _fob_task_name = format["btc_task_%1", _fob getVariable ["FOB_name", ""]];
    if(_fob_task_name call BIS_fnc_taskExists) then {
        [_fob_task_name, "FAILED"] call btc_task_fnc_setState;
        [_fob_task_name, btc_player_side, true] call BIS_fnc_deleteTask;
    };
    
   btc_event_activeEvents = (0 max (btc_event_activeEvents - 1));
};

(units (_fob getVariable ["btc_mil_garrison_group", []])) apply {
    _x setDamage 1;
};

deleteVehicle _flag;
if (!_delete) then {
    [_fob getVariable ["FOB_name", ""], _FOB_LOST_] call btc_rep_fnc_change;
} else {
    deleteVehicle _fob;
    [_fob getVariable ["FOB_name", ""], _FOB_DISMANTLED_] call btc_rep_fnc_change;
};

_this