#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_trackItem

Description:
    This function detect if an object is deleted with a specific item and fail the task.

Parameters:
    _dogTag - Item to track. [String]
    _taskID - Task ID to fail. [String]
    _objt - Object owning the item. [Object]

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_trackItem;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_dogTag", "", [""]],
    ["_taskID", "", [""]],
    ["_objt", player, [objNull]]
];

[_objt, "Respawn", {
    params [
        ["_unit", objNull, [objNull]],
        ["_corpse", objNull, [objNull]]
    ];
    _thisArgs params ["_dogTag", "_taskID"];

    if (_taskID call BIS_fnc_taskCompleted) exitWith {};

    if (_dogTag in items _unit) then {
        _unit removeItem _dogTag;
    };

    #ifdef BTC_DEBUG_EH
    [["%1: _thisArgs %2, items %3", __FILE_NAME__, _thisArgs, items _unit], 2, "eh"] call btc_debug_fnc_message;
    #endif}, [_dogTag, _taskID]] call CBA_fnc_addBISEventHandler;

[_objt, "Deleted", {
    params [
        ["_unit", objNull, [objNull]]
    ];
    _thisArgs params ["_dogTag", "_taskID"];

    if (_dogTag in items _unit && {!(_taskID call BIS_fnc_taskCompleted)}) then {
        [_taskID, "FAILED"] call BIS_fnc_taskSetState;
    };
}, [_dogTag, _taskID]] call CBA_fnc_addBISEventHandler;

[_objt, "Put", {
    params ["_unit", "_container", "_item"];
    _thisArgs params ["_dogTag", "_taskID"];

    if (_dogTag isEqualTo _item) then {
        [_container, "Killed", {
            params [
                ["_container", objNull, [objNull]]
            ];
            _thisArgs params ["_dogTag", "_taskID"];

            if (!(_taskID call BIS_fnc_taskCompleted) && {(allUnits + vehicles) findif {_dogTag in itemCargo _x} isEqualTo -1}) then {
                [_taskID, "FAILED"] call BIS_fnc_taskSetState;
            };
        }, [_dogTag, _taskID]] remoteExecCall ["CBA_fnc_addBISEventHandler", 0];
    };
}, [_dogTag, _taskID]] call CBA_fnc_addBISEventHandler;
