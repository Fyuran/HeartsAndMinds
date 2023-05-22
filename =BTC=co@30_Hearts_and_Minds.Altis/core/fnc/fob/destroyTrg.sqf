
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

//Handle client GUI
private _fob_conquest_time = _structure getVariable["fob_conquest_time", -1];
if(_fob_conquest_time < 0) then {

    ["WarningDescription", ["", format[
        localize "$STR_BTC_HAM_EVENT_FOBBEINGCAPPED",
        _structure getVariable["FOB_name", "UNKNOWN"]
    ]]] call btc_task_fnc_showNotification_s;

    _structure setVariable["fob_conquest_time", 0]; //setting flag for GUIs
    [_structure] remoteExecCall ["btc_fob_fnc_destroyProgress", [0,-2] select isDedicated];

    _handle = [
    {
        _args params["_fob_trg", "_structure"];
        diag_log format["inside destroy trigger: %1", list _fob_trg];

        _fob_conquest_time = _structure getVariable["fob_conquest_time", -1];
        if(list _fob_trg isNotEqualTo []) then {
            _structure setVariable["fob_conquest_time", _fob_conquest_time + (triggerInterval _fob_trg), true];
        } else {
            if (_fob_conquest_time > -1) then {
                _structure setVariable["fob_conquest_time", _fob_conquest_time - (triggerInterval _fob_trg), true];
            };
        };

        if(_fob_conquest_time >= btc_p_fob_cap_time) then {
            _structure setDamage 1;
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

    }, triggerInterval _fob_trg, 
    [
        _fob_trg, _structure
    ]] call CBA_fnc_addPerFrameHandler;

    _fob_trg setVariable ["CBAperFrameHandle", _handle];
};
