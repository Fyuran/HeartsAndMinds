#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_player

Description:
    Add event handler to player.

Parameters:
    _player - Player to add event. [Object]

Returns:
    _eventHandleID - ID of the WeaponAssembled event handle. [Number]

Examples:
    (begin example)
        _eventHandleID = [player] call btc_eh_fnc_player;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_player", objNull, [objNull]]
];

[_player, "Respawn", {
    params ["_unit", "_corpse"];
    _corpse connectTerminalToUAV objNull;
    if !(ace_map_mapIllumination) then {ace_map_mapIllumination = btc_map_mapIllumination;};
}] call CBA_fnc_addBISEventHandler;
["ace_killed", {
    params ["_unit"];
    if (_unit isNotEqualTo player) exitWith {};
    if (ace_map_mapIllumination) then {ace_map_mapIllumination = false;};
    if (isObjectHidden player) exitWith {};
    if !(isServer) then { // Don't add twice the event in player host
        ["btc_respawn_player", [_unit, player]] call CBA_fnc_localEvent;
    };
    ["btc_respawn_player", [_unit, player]] call CBA_fnc_serverEvent;
}] call CBA_fnc_addEventHandler;
{
    _x addEventHandler ["CuratorObjectPlaced", btc_eh_fnc_CuratorObjectPlaced];
} forEach allCurators;
["ace_treatmentSucceded", btc_rep_fnc_treatment] call CBA_fnc_addEventHandler;
if !(isServer) then { // Don't add twice the event in player host
    ["ace_repair_setWheelHitPointDamage", {
        _this remoteExecCall ["btc_rep_fnc_wheelChange", 2];
    }] call CBA_fnc_addEventHandler;
};
_player addEventHandler ["WeaponAssembled", btc_civ_fnc_add_leaflets];
[_player, "WeaponAssembled", {[_thisType, _this] call btc_fob_fnc_rallypointAssemble;}] call CBA_fnc_addBISEventHandler;
[_player, "WeaponDisassembled", {[_thisType, _this] call btc_fob_fnc_rallypointAssemble;}] call CBA_fnc_addBISEventHandler;
_player addEventHandler ["GetInMan", btc_ied_fnc_deleteLoop];
_player addEventHandler ["GetOutMan", {
    if (btc_ied_deleteOn > -1) then {
        [btc_ied_deleteOn] call CBA_fnc_removePerFrameHandler;
        btc_ied_deleteOn = -1;
    };
}];
_player addEventHandler ["WeaponAssembled", {
    params ["_player", "_static"];

    if !(_static isKindOf "StaticWeapon") exitWith {_this};
    [_static] remoteExecCall ["btc_log_fnc_init", 2];
}];
["ace_csw_deployWeaponSucceeded", {
    _this remoteExecCall ["btc_log_fnc_init", 2];
}] call CBA_fnc_addEventHandler;

if (btc_p_chem) then {
    // Add biopsy
    [missionNamespace, "probingEnded", btc_chem_fnc_biopsy] call BIS_fnc_addScriptedEventHandler;

    // Disable BI shower
    ["DeconShower_01_F", "init", {(_this select 0) setVariable ['bin_deconshower_disableAction', true];}, true, [], true] call CBA_fnc_addClassEventHandler;
    ["DeconShower_02_F", "init", {(_this select 0) setVariable ['bin_deconshower_disableAction', true];}, true, [], true] call CBA_fnc_addClassEventHandler;

    [] call btc_chem_fnc_ehDetector;
};

if (btc_p_spect) then {
    ["weapon", btc_spect_fnc_updateDevice] call CBA_fnc_addPlayerEventHandler;
    ["vehicle", {
        params ["_unit", "_newVehicle"];
        [] call btc_spect_fnc_disableDevice;
        [_unit, currentWeapon _unit] call btc_spect_fnc_updateDevice;
    }] call CBA_fnc_addPlayerEventHandler;
};

if (btc_p_respawn_arsenal) then {
    [_player, "Respawn", {
        params ["_unit", "_corpse"];
        if (isObjectHidden _corpse) exitWith {};
        [btc_gear_object, _unit] call ace_arsenal_fnc_openBox;
    }] call CBA_fnc_addBISEventHandler;
};

if (btc_p_respawn_location >= 4) then {
    ["ace_killed", {
        params ["_unit"];
        if (_unit isNotEqualTo player) exitWith {};
        private _group = group player;
        [_group, leader _group] call BIS_fnc_addRespawnPosition;
    }] call CBA_fnc_addEventHandler;
};

["btc_inGameUISetEventHandler", {
    params ["_target", "", "", "", "_text"];
    [_target, _text, ["siren_Start", "siren_stop"], "btc_int_sirenStart"] call btc_int_fnc_checkSirenBeacons;
}] call CBA_fnc_addEventHandler;
["btc_inGameUISetEventHandler", {
    params ["_target", "", "", "", "_text"];
    [_target, _text, ["beacons_start", "beacons_stop"], "btc_int_beaconsStart"] call btc_int_fnc_checkSirenBeacons;
}] call CBA_fnc_addEventHandler;
inGameUISetEventHandler ["Action", '["btc_inGameUISetEventHandler", _this] call CBA_fnc_localEvent; false'];

[{!isNull (findDisplay 46)}, {
    (findDisplay 46) displayAddEventHandler ["MouseButtonDown", btc_int_fnc_horn];
}] call CBA_fnc_waitUntilAndExecute;

if (btc_p_respawn_ticketsAtStart >= 0) then {
    ["btc_respawn_player", {
        [
            [player, btc_player_side] select btc_p_respawn_ticketsShare,
            btc_p_respawn_ticketsLost
        ] call BIS_fnc_respawnTickets; // Needs to be handled locally
        _this remoteExecCall ["btc_respawn_fnc_player", 2];
    }] call CBA_fnc_addEventHandler;
};

["ace_marker_flags_placed", {
    params ["_unit", "_flag"];
    _flag remoteExecCall ["btc_log_fnc_init", 2];
}] call CBA_fnc_addEventHandler; 

//Side Missions UI
["btc_side_ui_refresh_sideLb", {
    //UI related refresh
    [{
        private _dialog = findDisplay 70593;
        private _sidesLb = _dialog displayCtrl 1500;

        if(isNull _dialog || isNull _sidesLb) exitWith {
            #ifdef BTC_DEBUG_EH
            [["%1: null _dialog or _sidesLb", __FILE_NAME__], 2, "side"] call btc_debug_fnc_message;
            #endif
        };
        lbClear _sidesLb;
        btc_side_list apply {
            private _side = _x; //just to clarify things

            private _tasksIDs = (btc_side_taskIDs getOrDefault [_side, []]) select { //only pick tasks that are still functioning
                _x params[
                    ["_id", "", [""]]
                ];
                not(([_id] call BIS_fnc_taskState) in [
                    "SUCCEEDED",
                    "FAILED",
                    "CANCELED"
                ])
            };

            #ifdef BTC_DEBUG_EH
            private _title = localize format["STR_BTC_HAM_SIDE_%1_TITLE_SIMPLE", toUpper _side];
            private _countTaskIDs = count _tasksIDs;
            private _string = format["%1  #:%2", _title, _countTaskIDs];
            private _row = _sidesLb lbAdd _string;
            #else
            private _row = _sidesLb lbAdd format["%1  #:%2", localize format["STR_BTC_HAM_SIDE_%1_TITLE_SIMPLE", toUpper _side], count _tasksIDs];
            #endif
            private _data = format['["%1", "%2"]',
                _side,
                localize format["STR_BTC_HAM_SIDE_%1_DESC_SIMPLE", toUpper _side]
            ];
            _sidesLb lbSetData [_row, _data];
            #ifdef BTC_DEBUG_EH
            [["%1: REFRESHING '%2'(#%3) row %4 data is %5", __FILE_NAME__, _title, _countTaskIDs, _row, _data], 2, "side"] call btc_debug_fnc_message;
            #endif
        };
    }, []] call CBA_fnc_execNextFrame;

}] call CBA_fnc_addEventHandler;