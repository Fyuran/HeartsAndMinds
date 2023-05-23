
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_alarmTrg

Description:
    Handles alarm trigger calls by the FOB structure
    
Parameters:
    _fob_trg - fob trigger [ObjNull]

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!params[
    ["_fob_trg", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;};



private _structure = _this getVariable ["btc_fob_structure", ObjNull];
if (isNull _structure) exitWith {
    ["_structure is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _FOB_underAttack = _structure getVariable ["FOB_underAttack", false];
private _FOB_Name = _structure getVariable["FOB_name",""];
[format["%1: alarm triggered", _FOB_name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;

//Task and sound
["Warning2Description", ["", format[
    localize "$STR_BTC_HAM_EVENT_FOBUNDERATTACK",
    _FOB_Name
]]] call btc_task_fnc_showNotification_s;

if(_FOB_underAttack) then {
    _structure spawn {
        _loudspeaker = _this getVariable ["FOB_Loudspeaker", ObjNull];
        _pos = getPosASL _loudspeaker;
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
        sleep 5;
        playSound3d [getMissionPath "core\sounds\btc_event_FOB_Alert.ogg", _loudspeaker, false, _pos, 5];
        sleep 4;
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
        sleep 9;
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
    };
};