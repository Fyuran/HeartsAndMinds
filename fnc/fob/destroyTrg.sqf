
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_destroyTrg

Description:
	Handles calls by the FOB destroy trigger

Parameters:


Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_fob_trg", ObjNull, [ObjNull]]
];

if (isNull _fob_trg) exitWith {
	["_fob_trg is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};
private _structure = _fob_trg getVariable ["btc_fob_structure", ObjNull];
if (isNull _structure) exitWith {
	["_structure is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//If all units inside are ACE_isUnconscious, abort check
private _unconsciousUnits = (list _fob_trg) select {(_x getVariable ["ACE_isUnconscious", false])}; 
if(_unconsciousUnits isEqualTo list _fob_trg) exitWith {};

//Handle client GUI
private _fob_conquest_time = round(_structure getVariable["cap_time", -1]);
if(_fob_conquest_time < 0) then { //use _fob_conquest_time: -1 as a flag to run this code block once

    ["WarningDescriptionUnderattack", ["", format[
        localize "$STR_BTC_HAM_EVENT_FOBBEINGCAPPED",
        _structure getVariable["FOB_name", "UNKNOWN"]
    ]]] call btc_task_fnc_showNotification_s;

    _structure setVariable["cap_time", 0, true]; //unsetting the -1 flag
    [_structure, _structure getVariable ["FOB_name", "UNKNOWN"], false, btc_p_fob_cap_time] 
        remoteExecCall ["btc_ui_fnc_progressBars", [0,-2] select isDedicated, _structure];

    private _handle = [
    {
        _args params["_fob_trg", "_structure"];

        _fob_conquest_time = _structure getVariable["cap_time", -1];
        _awakeUnits = (list _fob_trg) select {!(_x getVariable ["ACE_isUnconscious", false])}; //ACE_isUnconscious units should never update cap timer

        if(!isGamePaused) then {
            if(_awakeUnits isNotEqualTo []) then { //increase cap time
                _structure setVariable["btc_fob_cooldown", -1]; //reset cooldown, sounds the alarm!
                _structure setVariable["cap_time", _fob_conquest_time + (triggerInterval _fob_trg), true];
            } else {
                if (round _fob_conquest_time > 0) then { //decrease cap time
                        _structure setVariable["cap_time", _fob_conquest_time - 2, true];
                };
                if (round _fob_conquest_time <= 0) then { //reset the -1 flag
                    _structure setVariable["cap_time", -1, true]; 
                    remoteExecCall ["", [0,-2] select isDedicated, _structure];
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };
            };

            if(round _fob_conquest_time >= btc_p_fob_cap_time) then {
                _structure setDamage 1; //CBA PFH will removed in Killed EH
            };
        };
    }, triggerInterval _fob_trg, 
    [
        _fob_trg, _structure
    ]] call CBA_fnc_addPerFrameHandler;

    _structure setVariable ["destroyTrgPFH", _handle];
};
