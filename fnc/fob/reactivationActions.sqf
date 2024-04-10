    
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_reactivationActions

Description:
    Adds reactivation actions to ruins object.

Parameters:
    _to - the ruins object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fob_fnc_reactivationActions;
    (end)

Author:
     Fyuran

---------------------------------------------------------------------------- */
if(btc_debug) then {
    [format["added %1 fob ruins actions", _this], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
};

private _action = ["btc_fob_reactivate", localize "STR_BTC_HAM_ACTION_REPAIR_FOB", "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa", {
    _actionParams = param[2, []];
    
    ["btc_fob_reactivate_progress", 20, {true}, {
        params[
            ["_actionObj", objNull, [objNull]], 
            ["_name", "UNKNOWN", [""]], 
            ["_flag", objNull, [objNull]], 
            ["_ruins", objNull, [objNull]], 
            ["_marker", "", [""]]
        ];
        [_flag] spawn btc_fob_fnc_create;
        ["btc_fobs_reactivation", [_actionObj, _name, _ruins, _marker]] call CBA_fnc_serverEvent;
    }, {}, _actionParams] call CBA_fnc_progressBar;
}, {
    [_player, _target] call ace_common_fnc_canInteractWith
}, {}, _this] call ace_interact_menu_fnc_createAction;

private _actionObj = param[0, objNull, [objNull]];
[_actionObj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;