
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
#include "..\script_macros.hpp"

params[
    ["_fob_trg", ObjNull, [ObjNull]],
    ["_thisList", [], [[]]]
];

//hint format["%1", _thisList];
if (isNull _fob_trg) exitWith {
	["_fob_trg is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _building = _fob_trg getVariable ["btc_fob_structure", ObjNull];
if (isNull _building) exitWith {
    ["_building is ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _cooldown = _building getVariable["btc_fob_cooldown", -1];
if(_cooldown > CBA_missionTime) exitWith {
    if(btc_debug) then {
        [format["Not ready yet: CD:%1, CBA_missionTime: %2, Remaining: %3", 
            _cooldown, CBA_missionTime, _cooldown - CBA_missionTime],
                 __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    };
};

private _FOB_Event = _building getVariable ["FOB_Event", false];
private _FOB_Name = _building getVariable["FOB_name",""];
[format["%1: alarm triggered", _FOB_name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
 
//Notification sound
["WarningDescriptionAudio", ["", format[
    localize "$STR_BTC_HAM_EVENT_FOBUNDERATTACK",
    _FOB_Name
]]] call btc_task_fnc_showNotification_s;

if(_FOB_Event) then {
    _building spawn {
        params["_building"];

        _building setVariable["btc_fob_cooldown", CBA_missionTime + _FOB_COOLDOWN_];

        _loudspeaker = _building getVariable ["FOB_Loudspeaker", ObjNull];
        _pos = getPosASL _loudspeaker;
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
        sleep 5;

        _fob_task_name = format["btc_task_%1", _building getVariable ["FOB_name", ""]];
        [_fob_task_name, _FOB_ATTACK_TASK_TYPE_, _building, btc_fob_structure, true, true] call btc_task_fnc_create;
        
        playSound3d [getMissionPath "core\sounds\btc_event_FOB_Alert.ogg", _loudspeaker, false, _pos, 5];
        sleep 4;
        playSound3d ["a3\data_f_curator\sound\cfgsounds\air_raid.wss", _loudspeaker, false, _pos, 5];
    }; 
};