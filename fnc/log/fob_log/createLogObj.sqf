
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_createLogObj

Description:
    Adds logistic actions to object for FOBs "Land_ToolTrolley_02_F"

Parameters:
    _obj - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fob_fnc_createLogObj;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
    ["_fob", objNull, [objNull]]
];

if(!alive _fob) exitWith {
    if(btc_debug) then {
        ["_fob is null or not alive", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

private _log_create_obj = _fob getVariable ["btc_fob_log_create_obj", objNull];

if(isNull _log_create_obj) then {
    _log_create_obj = createVehicle [btc_fob_log_create_obj, [0,0,0]];
    private _arrow = createVehicle ["Sign_Arrow_Large_Blue_F", [0,0,0]];
    private _log_point = createVehicle ["Land_HelipadSquare_F", [0,0,0]];
    _log_create_obj setVariable ["btc_log_helpers", [_arrow], true];
    _log_create_obj setVariable ["btc_log_point_obj", _log_point, true];
    _log_point attachTo [_log_create_obj, [5,10,0]];
    _arrow attachTo [_log_point, [0,0,0]];

    private _action = ["Logistic", localize "STR_BTC_HAM_ACTION_LOC_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\L_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    _action = ["Require_object", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQOBJ", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\D_ca.paa", {
        params ["_target", "", "_params"];
        _params params ["_construction_array", "_log_point"];
        [_target, _construction_array, _log_point] spawn btc_log_fnc_create;
    }, {true}, {}, [btc_fob_construction_array, _log_point], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
};

private _eyeDir = eyeDirection player;
private _pos_ASL = getPosASL player;
_log_create_obj setPosASL (_pos_ASL vectorAdd (_eyeDir vectorMultiply 2));

[_log_create_obj] call btc_log_fnc_place;



/*{
    _x params ["_log_create_obj", "_helipad"];

    //Logistic
    _action = ["Logistic", localize "STR_BTC_HAM_ACTION_LOC_MAIN", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\L_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Require_log_create_obj", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQOBJ", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\D_ca.paa", {
        params ["", "", "_params"];
        _params spawn btc_log_fnc_create
    }, {true}, {}, [_helipad], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Repair_wreck", localize "STR_BTC_HAM_ACTION_LOGPOINT_REPWRECK", "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_repair_wreck
    }, {true}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Refuel", localize "STR_BTC_HAM_ACTION_LOGPOINT_REFUELSOURCE", "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_refuelSource
    }, {true}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Rearm", localize "STR_BTC_HAM_ACTION_LOGPOINT_REARMSOURCE", "\A3\ui_f\data\igui\cfg\simpleTasks\types\rearm_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_rearmSource
    }, {true}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;

	_action = ["Restore", localize "STR_BTC_HAM_ACTION_LOGPOINT_RESTORESOURCE", "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_restoreVehicle
    }, {true}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;

    _action = ["Require_veh", localize "STR_BTC_HAM_ACTION_LOGPOINT_REQVEH", "\A3\ui_f\data\map\vehicleicons\iconCar_ca.paa", {
        params ["", "", "_params"];
        _params spawn btc_arsenal_fnc_garage
    }, {(serverCommandAvailable "#logout" || !isMultiplayer) and btc_p_garage}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Require_delete", localize "STR_3DEN_Delete", "\z\ace\addons\arsenal\data\iconClearContainer.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_delete
    }, {true}, {}, [_helipad], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Logistic"], _action] call ace_interact_menu_fnc_addActionToObject;

    //Tool
    _action = ["Tool", localize "str_3den_display3den_menubar_tools_text", "\A3\ui_f\data\igui\cfg\simpleTasks\letters\T_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Copy_container", localize "STR_BTC_HAM_ACTION_COPYPASTE_COPY", "\A3\ui_f\data\igui\cfg\simpleTasks\types\download_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_copy
    }, {true}, {}, [_helipad], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Paste_container", localize "STR_BTC_HAM_ACTION_COPYPASTE_PASTE", "\A3\ui_f\data\igui\cfg\simpleTasks\types\upload_ca.paa", {
        params ["", "", "_params"];
        [btc_copy_container, _params] call btc_log_fnc_paste
    }, {!isNil "btc_copy_container"}, {}, _helipad, [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Copy_inventory", localize "STR_BTC_HAM_ACTION_COPYPASTE_COPYI", "\A3\ui_f\data\igui\cfg\simpleTasks\types\download_ca.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_inventoryCopy
    }, {true}, {}, [_helipad], [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Paste_inventory", localize "STR_BTC_HAM_ACTION_COPYPASTE_PASTEI", "\A3\ui_f\data\igui\cfg\simpleTasks\types\upload_ca.paa", {
        params ["", "", "_params"];
        [btc_copy_inventory, _params] call btc_log_fnc_inventoryPaste
    }, {!isNil "btc_copy_inventory"}, {}, _helipad, [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = ["Restore_inventory", localize "STR_BTC_HAM_ACTION_RESTOREI", "\A3\Ui_f\data\GUI\Cfg\KeyframeAnimation\IconCurve_CA.paa", {
        params ["", "", "_params"];
        _params call btc_log_fnc_inventoryRestore
    }, {true}, {}, _helipad, [0, 0, 0.4], 5] call ace_interact_menu_fnc_createAction;
    [_log_create_obj, 0, ["ACE_MainActions", "Tool"], _action] call ace_interact_menu_fnc_addActionToObject;

    //Bodybag
    if (btc_p_respawn_ticketsAtStart isNotEqualTo -1) then {
        _action = ["Bodybag", localize "STR_BTC_HAM_ACTION_LOGPOINT_BODYBAG", "\A3\Data_F_AoW\Logos\arma3_aow_logo_ca.paa", {
            params ["", "", "_params"];
            _params call btc_body_fnc_bagRecover;
        }, {true}, {}, [_helipad], [0, 0, 0], 5] call ace_interact_menu_fnc_createAction;
        [_log_create_obj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };
} forEach [[btc_log_create_obj, btc_log_point_obj]];

