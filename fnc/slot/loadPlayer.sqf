
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_loadPlayer

Description:
    Asks server if database exists for this current player and if it does, load it else just continue normally

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_loadPlayer;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!alive player) exitWith {
    if(btc_debug) then {
        [format["%1 is null or not alive", name player], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

[getPlayerUID player] remoteExecCall ["btc_slot_fnc_getData"];

[{!isNil "btc_slot_data"}, {

    if(isNil "btc_slot_data") exitWith {
        if(btc_debug) then {
            [format["btc_slot_data is still nil"], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
        };
    };
    if(btc_slot_data isEqualTo []) exitWith {
        if(btc_debug) then {
            [format ["no data found for %1(%2)", name player, getPlayerUID player], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
        };
    };

    btc_slot_data params [
        ["_previousPos", [0,0,0], [[]], 3],
        ["_dir", 0, [0]],
        ["_loadout", [], [[]], 10],
        ["_flagTexture", "", [""]],
        ["_isContaminated", false, [false]],
        ["_medicalDeserializeState", "", [""]],
        ["_vehicle", objNull, [objNull]],
        ["_field_rations", [], [[]]],
        ["_hasEarPlugsIn", false, [false]],
        ["_uid", "", [""]]
    ];

    if(btc_debug) then {
        [format ["%1(%2) with: %3", name player, _uid, btc_slot_data], __FILE__, [false, btc_debug_log, false], false] call btc_debug_fnc_message;
    };

    if((_uid isNotEqualTo "") && {_uid isNotEqualTo (getPlayerUID player)}) exitWith { //just check for mismatch, ignore empty string
        if(btc_debug) then {
            if(_uid isEqualTo "") then {_uid = "EMPTY"};
            [format ["%1, different uid! %2, %3", name player, _uid, getPlayerUID player], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
        };
    };
    player setDir _dir; //keep setDir above setPos to sync direction between clients https://community.bistudio.com/wiki/setDir
    player setPosASL _previousPos;

    player forceFlagTexture _flagTexture;
    [{player getVariable ["ace_medical_initialized", false]}, {
        [player, _this] call ace_medical_fnc_deserializeState;
    }, _medicalDeserializeState] call CBA_fnc_waitUntilAndExecute;

    _field_rations params [["_thirst", 0, [0]], ["_hunger", 0, [0]]];
    player setVariable ["acex_field_rations_thirst", _thirst, true];
    player setVariable ["acex_field_rations_hunger", _hunger, true];

    if (_isContaminated) then {
        if ((btc_chem_contaminated pushBackUnique player) > -1) then {
                publicVariable "btc_chem_contaminated";
                player call btc_chem_fnc_damageLoop;
            };
        } else {
        switch (btc_p_autoloadout) do {
            case 1: {
                private _arsenal_trait = player call btc_arsenal_fnc_trait;
                player setUnitLoadout ([_arsenal_trait select 0] call btc_arsenal_fnc_loadout);
            };
            case 2: {
                (weapons player) apply {          
                    player removeWeapon _x;
                };
            };
            default {};
        };
    };
    player setUnitLoadout _loadout;
    if(_hasEarPlugsIn) then {
        [player, false] call ace_hearing_fnc_putInEarplugs;
    };

    btc_slot_data = nil; //reset stored info

}, nil, 300, {
    if(btc_debug) then {
        [format ["timeout, unable to load data for %1(%2)", name player, getPlayerUID player], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
}] call CBA_fnc_waitUntilAndExecute;