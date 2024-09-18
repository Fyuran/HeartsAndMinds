
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_loadPlayer

Description:
    Asks server if database exists for this current player and if it does, load it

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_loadPlayer;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
if(!params[
    ["_slot_data", createHashMap, [createHashMap]]
]) exitWith { //empty hashmap
    if(btc_debug) then {
        [format ["no data found for %1(%2)", name player, getPlayerUID player], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

if(!alive player) exitWith {
    if(btc_debug) then {
        [format["%1 is null or not alive", name player], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

(values _slot_data) params ((keys _slot_data) apply {"_" + _x});
if(btc_debug) then {
    [format ["%1(%2) with: %3", name player, _uid, _slot_data], __FILE__, [false, btc_debug_log, false], false] call btc_debug_fnc_message;
};

if((_uid isNotEqualTo "") && {_uid isNotEqualTo (getPlayerUID player)}) exitWith { //just check for mismatch, ignore empty string
    if(btc_debug) then {
        [format ["%1, different uid! %2, %3", name player, _uid, getPlayerUID player], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
    };
};
player setDir _dir; //keep setDir above setPos to sync direction between clients https://community.bistudio.com/wiki/setDir
player setPosASL _previousPos;

player forceFlagTexture _flagTexture;
[{player getVariable ["ace_medical_initialized", false]}, {
    [player, _this] call btc_json_fnc_medical_deserializeState;
}, _medicalState] call CBA_fnc_waitUntilAndExecute;

_field_rations params [["_thirst", 0, [0]], ["_hunger", 0, [0]]];
player setVariable ["acex_field_rations_thirst", _thirst, true];
player setVariable ["acex_field_rations_hunger", _hunger, true];

if (_isContaminated) then {
    if ((btc_chem_contaminated pushBackUnique player) > -1) then {
        publicVariable "btc_chem_contaminated";
        player call btc_chem_fnc_damageLoop;
    };
};
player setUnitLoadout _loadout;
if(_hasEarPlugsIn) then {
    [player, false] call ace_hearing_fnc_putInEarplugs;
};

player setVariable["btc_scoreboard", _btc_scoreboard, 2];