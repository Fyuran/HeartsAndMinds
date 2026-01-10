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

private _dialog = createDialog ["btc_gm_sidesmenu", true];
private _listbox = _dialog displayCtrl 1500;
private _multiText = _dialog displayCtrl 1000;
private _button = _dialog displayCtrl 1600;

btc_side_list apply {
    private _index = _listbox lbAdd (localize format["STR_BTC_HAM_SIDE_%1_TITLE_SIMPLE", toUpper _x]);
    _listbox lbSetData [_index, 
        format['["%1", "%2", "%3"]',
            _x,
            localize format["STR_BTC_HAM_SIDE_%1_DESC_SIMPLE", toUpper _x]
        ]
    ];
    #ifdef BTC_DEBUG_SIDE
    [["%1: %2 row data is %3", __FILE_NAME__, _x, localize format["STR_BTC_HAM_SIDE_%1_DESC_SIMPLE", toUpper _x]], 2, "side"] call btc_debug_fnc_message;
    #endif
};

_listbox ctrlAddEventHandler ["LBSelChanged", {
    params["_listbox", "_lbCurSel"];
    (call compile(_listbox lbData _lbCurSel)) params[
        ["_side", "", [""]],
        ["_desc", "", [""]]
    ];
    playSound "button_rollover";
    private _dialog = ctrlParent _listbox;
    private _multiText = _dialog displayCtrl 1000;
    private _button = _dialog displayCtrl 1600;
    
    private _taskID = format["btc_side_%1", _side];
    if([_taskID] call BIS_fnc_taskExists) then {
        _button ctrlSetBackgroundColor[0.89, 0.352, 0 , 1]; //rgb(227,90,0)
        _button ctrlSetText "CANCEL";
    } else {
        _button ctrlSetBackgroundColor[0.023,0.572,0.243,1];
        _button ctrlSetText "CREATE";
    };

    if (isNull _multiText) exitWith {};
    _multiText ctrlSetText _desc;
    _button ctrlEnable true;
}];

_button ctrlAddEventHandler ["ButtonClick", {
    params["_button"];
    playSound "button_release";
    private _listbox = (ctrlParent _button) displayCtrl 1500;
    (call compile(_listbox lbData (lbCurSel _listbox))) params[
        ["_side", "", [""]],
        ["_desc", "", [""]]
    ];
    _listbox lbSetCurSel -1;
    _button ctrlEnable false;
    
    private _taskID = format["btc_side_%1", _side];
    if([_taskID] call BIS_fnc_taskExists) exitWith {
        [_taskID, "CANCELED"] call btc_task_fnc_setState;
    };

    private _map = createDialog ["RscMap", true];
    #ifdef BTC_DEBUG_SIDE
    [["%1: %2 map loaded, lbCurSel: %3, fnc: %4", __FILE_NAME__, _map, (lbCurSel _listbox), _fnc], 3, "side"] call btc_debug_fnc_message;
    #endif
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
    _infoText ctrlSetText "Click where to place side mission"; //--- ToDo: Localize;
    _infoText ctrlSetFontHeight 1.5 * GUI_GRID_H;
    _infoText ctrlCommit 0.5;

    _mapCtrl = _map displayCtrl 51;
    _mapCtrl ctrlSetPosition[safezoneXAbs, safezoneY, 0, 0];
    _mapCtrl ctrlCommit 0;
    _mapCtrl ctrlSetPosition[safezoneXAbs, safezoneY, safezoneWAbs, safezoneH - _infoTextH];
    _mapCtrl ctrlCommit 0.5;
    [true, "btc_debug_fnc_cities"] remoteExecCall ["btc_debug_fnc_request_server_data", [0,2] select isMultiplayer];

    private _handle = addMissionEventHandler ["MapSingleClick", {
        params ["_units", "_pos", "_alt", "_shift"];
        _thisArgs params [
            ["_map", displayNull, [displayNull]],
            ["_side", "", [""]]
        ];
        private _fnc = format["btc_side_fnc_%1", _side];
        #ifdef BTC_DEBUG_SIDE
        [["%1: clicked on %2, %3 side, remoteExecCall: %4", __FILE_NAME__, _pos, _side, _fnc], 3, "side"] call btc_debug_fnc_message;
        #endif
        [format["btc_side_%1", _side], _pos] remoteExec [_fnc, 2];
        removeMissionEventHandler ["MapSingleClick", _thisEventHandler];
        _map closeDisplay 1;
    }, [_map, _side]];
    uiNamespace setVariable["btc_gm_side_menu_MapSingleClick", _handle];

    _map displayAddEventHandler ["Unload", {
        playSound "button_cancel";
        private _handle = uiNamespace getVariable["btc_gm_side_menu_MapSingleClick", -1];
        removeMissionEventHandler ["MapSingleClick", _handle];
    }];
}];
