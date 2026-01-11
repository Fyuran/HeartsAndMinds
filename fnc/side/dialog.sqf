#include "..\script_macros.hpp"
#include "\a3\ui_f\hpp\definecommongrids.inc"
/* ----------------------------------------------------------------------------
Date: 2025/12
Function: btc_side_fnc_dialog

Description:
    Displays a menu for side missions.

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_side_fnc_dialog;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

private _dialog = createDialog ["btc_sides_sidesmenu", true];
if(isNull _dialog) exitWith {
    #ifdef BTC_DEBUG_SIDE
    [["%1: _dialog is null", __FILE_NAME__], 6, "side"] call btc_debug_fnc_message;
    #endif
};
private _sidesLb = _dialog displayCtrl 1500;
private _sidesTasksLb = _dialog displayCtrl 1501;
private _button = _dialog displayCtrl 1600;

["btc_side_ui_refresh_sideLb"] call CBA_fnc_localEvent;

//Sides ListBox
_sidesLb ctrlAddEventHandler ["LBSelChanged", {
    params["_sidesLb", "_lbCurSel"];
    if(_lbCurSel isEqualTo -1) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _sidesLb %2 selected -1, exiting event", __FILE_NAME__, _sidesLb], 2, "side"] call btc_debug_fnc_message;
        #endif
    };
    (call compile(_sidesLb lbData _lbCurSel)) params[
        ["_side", "", [""]],
        ["_desc", "", [""]]
    ];
    if(_side isEqualTo "") exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: invalid _side", __FILE_NAME__], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    private _dialog = ctrlParent _sidesLb;
    if(isNull _dialog) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _dialog is null", __FILE_NAME__], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    playSound "button_rollover";
    private _multiText = _dialog displayCtrl 1000;
    private _sidesTasksLb = _dialog displayCtrl 1501;
    _sidesTasksLb lbSetCurSel -1;

    private _button = _dialog displayCtrl 1600;
    _button ctrlEnable false;
    _button ctrlSetBackgroundColor[0.023,0.572,0.243,1];
    _button ctrlSetText localize "STR_BTC_HAM_SIDE_UI_CREATE";

    if (isNull _multiText) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _multiText is null", __FILE_NAME__, _taskID, _tasksIDs], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    _multiText ctrlSetText _desc;

    //Tasks and Create New Task elements for _sidesTasksLb
    private _tasksIDs = (btc_side_taskIDs getOrDefault [_side, []]) select { //only pick tasks that are still functioning
        _x params[
            ["_id", "", [""]]
        ];
        not(([_id] call BIS_fnc_taskState) in [
            "SUCCEEDED",
            "FAILED",
            "CANCELED"
        ])
    };
    #ifdef BTC_DEBUG_SIDE
    [["%1: btc_side_%2 adding elements to tasks sub-menu: %3", __FILE_NAME__, _side, _tasksIDs], 2, "side"] call btc_debug_fnc_message;
    #endif
    lbClear _sidesTasksLb;
    _sidesTasksLb lbAdd localize "STR_BTC_HAM_SIDE_UI_NEW_TASK";
    _sidesTasksLb lbSetData [0, "NEW_TASK"];
    {
        _x params[
            ["_id", "", [""]],
            ["_name", "", [""]] 
        ];
        if(_name isEqualTo "") then {
            _name = localize "STR_BTC_HAM_SIDE_UI_UNKNOWN_NAME";
        };
        _sidesTasksLb lbAdd _name;
        _sidesTasksLb lbSetData [_forEachIndex + 1, _id]; //0 index will always be NEW TASK
    }forEach _tasksIDs;
}];

//Tasks ListBox
_sidesTasksLb ctrlAddEventHandler ["LBSelChanged", {
    params["_sidesTasksLb", "_lbCurSel"];
    if(_lbCurSel isEqualTo -1) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _sidesTasksLb %2 selected -1, exiting event", __FILE_NAME__, _sidesTasksLb], 2, "side"] call btc_debug_fnc_message;
        #endif
    };

    private _dialog = ctrlParent _sidesTasksLb;
    if(isNull _dialog) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _dialog is null", __FILE_NAME__], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    playSound "button_rollover";
    private _button = _dialog displayCtrl 1600;
    private _taskID = _sidesTasksLb lbData _lbCurSel;

    if([_taskID] call BIS_fnc_taskExists) then {
        _button ctrlSetBackgroundColor[0.89, 0.352, 0 , 1]; //rgb(227,90,0)
        _button ctrlSetText localize "STR_BTC_HAM_SIDE_UI_CANCEL";
    } else {
        _button ctrlSetBackgroundColor[0.023,0.572,0.243,1];
        _button ctrlSetText localize "STR_BTC_HAM_SIDE_UI_CREATE";
    };
    _button ctrlEnable true;

    #ifdef BTC_DEBUG_SIDE
    private _sidesLb = _dialog displayCtrl 1500;
    (call compile(_sidesLb lbData (lbCurSel _sidesLb))) params[
        ["_side", "", [""]],
        ["_desc", "", [""]]
    ];
    [["%1: _side %2, _sidesTasksLb selected %3 with data %4", __FILE_NAME__, _side, _lbCurSel, _taskID], 3, "side"] call btc_debug_fnc_message;
    #endif
}];

//Button
_button ctrlAddEventHandler ["ButtonClick", {
    params["_button"];
    playSound "button_release";
    
    private _dialog = ctrlParent _button;
    if(isNull _dialog) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: _dialog is null", __FILE_NAME__], 6, "side"] call btc_debug_fnc_message;
        #endif
    };
    private _sidesLb = _dialog displayCtrl 1500;
    private _sidesTasksLb = _dialog displayCtrl 1501;

    (call compile(_sidesLb lbData (lbCurSel _sidesLb))) params[
        ["_side", "", [""]],
        ["_desc", "", [""]]
    ];

    if(not(_side in btc_side_list)) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: invalid _side: %2", __FILE_NAME__, _side], 6, "side"] call btc_debug_fnc_message;
        #endif
    };

    private _taskID = _sidesTasksLb lbData (lbCurSel _sidesTasksLb);
    #ifdef BTC_DEBUG_SIDE
    [["%1: button pressed with _button: %2, _dialog: %3, _sidesLb: %4, _sidesTasksLb: %5, _side: %6, _taskID: %7", 
    __FILE_NAME__, _button, _dialog, _sidesLb, _sidesTasksLb, _side, _taskID], 2, "side"] call btc_debug_fnc_message;
    #endif
    _button ctrlEnable false;
    _sidesLb lbSetCurSel -1;
    lbClear _sidesTasksLb;
    _sidesTasksLb lbSetCurSel -1;

    if([_taskID] call BIS_fnc_taskExists) exitWith {
        #ifdef BTC_DEBUG_SIDE
        [["%1: Cancelling taskID: %2", __FILE_NAME__, _taskID], 3, "side"] call btc_debug_fnc_message;
        #endif
        [_taskID, "CANCELED"] call btc_task_fnc_setState;
    };

    private _map = createDialog ["RscMap", true];

    #ifdef BTC_DEBUG_SIDE
    [["%1: %2 map loaded, lbCurSel: %3", __FILE_NAME__, _map, (lbCurSel _sidesLb)], 3, "side"] call btc_debug_fnc_message;
    #endif
    [false] call btc_debug_fnc_cities; //remove if preexisting in order to avoid conflicts
    private _infoText = _map ctrlCreate ["RscCenterText", 1001];
    //private _infoTextW = 0.37125 * safezoneW;
    private _infoTextH = 0.044 * safezoneH;
    _infoText ctrlSetPosition [
        safezoneXAbs,
        (safezoneH + safezoneY) - _infoTextH,
        safezoneWAbs,
        _infoTextH
    ];
	_infoText ctrlSetBackgroundColor [0,0,0,1];
    _infoText ctrlSetText localize "STR_BTC_HAM_SIDE_UI_HINT_01";
    _infoText ctrlSetFontHeight 1.5 * GUI_GRID_H;
    _infoText ctrlCommit 0.5;

    //Map Events
    _mapCtrl = _map displayCtrl 51;
    _mapCtrl ctrlSetPosition[safezoneXAbs, safezoneY, 0, 0];
    _mapCtrl ctrlCommit 0;
    _mapCtrl ctrlSetPosition[safezoneXAbs, safezoneY, safezoneWAbs, safezoneH - _infoTextH];
    _mapCtrl ctrlCommit 0.5;
    btc_debug_isUsingMapToPlace = true; //avoid teleportation for map clicks in debug mode
    [true, "btc_debug_fnc_cities"] remoteExecCall ["btc_debug_fnc_request_server_data", [0,2] select isMultiplayer];

    private _handle = addMissionEventHandler ["MapSingleClick", {
        params ["_units", "_pos", "_alt", "_shift"];
        _thisArgs params [
            ["_map", displayNull, [displayNull]],
            ["_side", "", [""]]
        ];
        #ifdef BTC_DEBUG_SIDE
        [["%1: clicked on pos %2, side %3", __FILE_NAME__, _pos, _side], 3, "side"] call btc_debug_fnc_message;
        #endif
        
        [false, _side, _pos] remoteExec ["btc_side_fnc_create", 2];
        removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
        _map closeDisplay 1;
    }, [_map, _side]];
    uiNamespace setVariable["btc_side_menu_MapSingleClick_handle", _handle];

    _map displayAddEventHandler ["Unload", {
        playSound "button_cancel";
        btc_debug_isUsingMapToPlace = false;
        [false] call btc_debug_fnc_cities;
        private _handle = uiNamespace getVariable["btc_side_menu_MapSingleClick_handle", -1];
        removeMissionEventHandler ["MapSingleClick", _handle];
    }];
}];
