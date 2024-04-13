    
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
#define _PROGRESS_DURATION_ 20
if(btc_debug) then {
    [format["added %1 fob ruins actions", _this], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
};

private _action = ["btc_fob_reactivate", localize "STR_BTC_HAM_ACTION_REPAIR_FOB", "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa", {
    _actionParams = param[2, []];
    _flag = _actionParams param [2, objNull, [objNull]];
    //"a3\data_f\flags\flag_blue_co.paa"
    //"a3\data_f\flags\flag_white_co.paa"
    _flag setVariable ["btc_isBeingUsed", true, true];
    
    _flag spawn {
        waitUntil {
            _time = _this getVariable["btc_fob_progress", 0];
            if(_time % 4 == 0) then {
                playSound3D [getMissionPath "\core\sounds\flag_flapping.ogg", _this];
            };
            _this setVariable["btc_fob_progress", _time + 1];
            _phase = linearConversion[0, _PROGRESS_DURATION_, _this getVariable["btc_fob_progress", 0], 0, 1, true];
            
            [_this, _phase, false] call BIS_fnc_animateFlag; 
            sleep 1;
            !(_this getVariable ["btc_isBeingUsed", false])
        };
    };


    [localize "STR_BTC_HAM_ACTION_REPAIRING_FOB", _PROGRESS_DURATION_, {true}, {
        (_this#0) params[
            ["_actionObj", objNull, [objNull]], 
            ["_name", "UNKNOWN", [""]], 
            ["_flag", objNull, [objNull]], 
            ["_ruins", objNull, [objNull]], 
            ["_marker", "", [""]]
        ];
        _flag setFlagTexture "a3\data_f\flags\flag_blue_co.paa";
        [_flag] spawn btc_fob_fnc_create;
        [_flag, 1, true] call BIS_fnc_animateFlag; 
        
        ["btc_fobs_reactivation", [_actionObj, _name, _ruins, _marker]] call CBA_fnc_serverEvent;
    }, {
        _flag = (_this#0) param [2, objNull, [objNull]];
        [_flag, 0, true] call BIS_fnc_animateFlag;
        _flag setVariable ["btc_fob_progress", 0];
        _flag setVariable ["btc_isBeingUsed", false, true];
    }, _actionParams] call CBA_fnc_progressBar;


}, {
    _actionParams = param[2, []];
    _flag = _actionParams param [2, objNull, [objNull]];
    [_player, _target] call ace_common_fnc_canInteractWith && {!(_flag getVariable ["btc_isBeingUsed", false])}
}, {}, _this, {}, 2] call ace_interact_menu_fnc_createAction;

private _actionObj = param[0, objNull, [objNull]];
[_actionObj, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;