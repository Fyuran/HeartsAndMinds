
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_alarmTrg

Description:

Parameters:
    _fob_trg - fob trigger [ObjNull]

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define FOB_ATTACK_TASK_TYPE 42

if(!params[
    ["_fob_trg", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;};

//Task and sound
_fob_trg spawn {
    private _structure = _this getVariable ["btc_fob_structure", ObjNull];
    if (isNull _structure) then {["_structure is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;};
    private _FOB_Name = _structure getVariable["FOB_name",""];
    [format["%1: alarm triggered", _FOB_name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    private _loudspeaker = _structure getVariable ["FOB_Loudspeaker", ObjNull];
    private _pos = getPosASL _loudspeaker;
    playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
    sleep 5;
    playSound3d [getMissionPath "core\sounds\btc_event_FOB_Alert.ogg", _loudspeaker, false, _pos, 5];
    ["WarningDescription", ["", format[
        localize "$STR_BTC_HAM_O_FOB_REDEPLOY_FOBUNDERATTACK",
        _FOB_Name
    ]]] call btc_task_fnc_showNotification;
    //["btc_dft", FOB_ATTACK_TASK_TYPE, _structure, btc_fob_structure, true, true] call btc_task_fnc_create;
    sleep 4;
    for "_i" from 0 to 1 do {
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
        sleep 9;
    }; 
};