#include "..\script_macros.hpp"
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
    #ifdef BTC_DEBUG_SLOT
    [["%1: no data found for %2(%3)", __FILE_NAME__, name player, getPlayerUID player], 6, "slot"] call FUNC(debug,message);
    #endif};

if(!alive player) exitWith {
    #ifdef BTC_DEBUG_SLOT
    [["%1: %2 is null or not alive", __FILE_NAME__, name player], 6, "slot"] call FUNC(debug,message);
    #endif
};

(values _slot_data) params ((keys _slot_data) apply {"_" + _x});
#ifdef BTC_DEBUG_SLOT
[format ["%1(%2) with: %3", name player, _uid, _slot_data], __FILE_NAME__, [false, btc_debug_log, false], false] call FUNC(debug,message);
#endif
if((_uid isNotEqualTo "") && {_uid isNotEqualTo (getPlayerUID player)}) exitWith { //just check for mismatch, ignore empty string
    #ifdef BTC_DEBUG_SLOT
    [["%1: %2, different uid! %3, %4", __FILE_NAME__, name player, _uid, getPlayerUID player], 6, "slot"] call FUNC(debug,message);
    #endif
};
player setDir _dir; //keep setDir above setPos to sync direction between clients https://community.bistudio.com/wiki/setDir
player setPosASL _previousPos;

player forceFlagTexture _flagTexture;
[{player getVariable ["ace_medical_initialized", false]}, {
    [player, _this] call FUNC(db,medical_deserializeState);
}, _medicalState] call CBA_fnc_waitUntilAndExecute;

_field_rations params [["_thirst", 0, [0]], ["_hunger", 0, [0]]];
player setVariable ["acex_field_rations_thirst", _thirst, true];
player setVariable ["acex_field_rations_hunger", _hunger, true];

if (_isContaminated) then {
    if ((btc_chem_contaminated pushBackUnique player) > -1) then {
        publicVariable "btc_chem_contaminated";
        player call FUNC(chem,damageLoop);
    };
};
player setUnitLoadout _loadout;
if(_hasEarPlugsIn) then {
    [player, false] call ace_hearing_fnc_putInEarplugs;
};

player setVariable["btc_scoreboard", _btc_scoreboard, 2];