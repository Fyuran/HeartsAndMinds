
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOB_alarmTrg

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

private _structure = _fob_trg getVariable ["btc_event_fob_structure", ObjNull];
[format["%1: alarm triggered", _structure getVariable["FOB_name",""]], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
//Task and sound
_structure spawn {
    private _loudspeaker = _this getVariable ["FOB_Loudspeaker", ObjNull];
    private _pos = getPosASL _loudspeaker;
    playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
    sleep 5;
    playSound3d [getMissionPath "core\sounds\btc_event_FOB_Alert.ogg", _loudspeaker, false, _pos, 5];
    ["btc_dft", FOB_ATTACK_TASK_TYPE, _this, btc_fob_structure, true, true] call btc_task_fnc_create;
    sleep 4;
    for "_i" from 0 to 1 do {
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
        sleep 9;
    }; 
};

deleteVehicle _fob_trg;