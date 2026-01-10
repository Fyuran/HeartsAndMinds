#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_task_fnc_create
Date: 2025/12

Description:
    Create the task server side and add description to each client and JIP client.

Parameters:
    _task - ID of the task. [String, Array]
    _description - Number of the corresponding description. [Number]
    _destination - Destination of the task. [Object or Array]
    _location - Custom information to fill the task description. [String or Array]
    _setCurrent - Set task as current. [Boolean]
    _showNotification - Show notification. [Boolean]

Returns:
    _jipID - return the join in process ID. [String]

Examples:
    (begin example)
        [["btc_dft", "btc_m"], 0] call btc_task_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_task", "btc_dft", ["", []]],
    ["_description", 0, [0]],
    ["_destination", objNull, [objNull, []]],
    ["_location", "", ["", []]],
    ["_setCurrent", false, [false]],
    ["_showNotification", true, [true]]
];

if (_destination in values btc_city_all) then {
    _destination = _destination getVariable ["city_realPos", getPos _destination];
};

private _jipID = "";
if(_task isEqualType "") then {
    if(!(_task call BIS_fnc_taskExists)) then {
        [btc_player_side, _task, nil, _destination, ["CREATED", "ASSIGNED" ] select _setCurrent] call BIS_fnc_taskCreate;
        _jipID = [_task, btc_player_side, _description, _destination, 2, _showNotification, _location] remoteExecCall ["btc_task_fnc_setDescription", [0, -2] select isDedicated, true];
    };
} else {
    if ((count _task) > 2) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: bad task array: %2", __FILE_NAME__, _task], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    _task params [
        ["_child", "", [""]], 
        ["_parent", "", [""]]
    ];
    if (_parent call BIS_fnc_taskExists) then { //parent task has to be valid in order to add a child
        if (!(_child call BIS_fnc_taskExists)) then {
            [btc_player_side, _task, nil, _destination, ["CREATED", "ASSIGNED" ] select _setCurrent] call BIS_fnc_taskCreate;
            _jipID = [_task, btc_player_side, _description, _destination, 2, _showNotification, _location] remoteExecCall ["btc_task_fnc_setDescription", [0, -2] select isDedicated, true];
        };
    };
};

_jipID
