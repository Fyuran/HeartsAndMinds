
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_deserializeState

Description:
    Deserialize player slot.

Parameters:
    _previousPos - Position of the player. [Array]
    _dir - Direction of the player. [Number]
    _loadout - Loadout of the player. [Array]
    _flagTexture - Flag raised. [String]
    _isContaminated - Chemically contaminated. [Boolean]
    _medicalDeserializeState - Medical ACE state. [String]
    _vehicle - Vehicle occupied by player. [Object]
    _field_rations - Thirst and hunger player's. [Array]

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

[{!isNull player}, {
    params [
        ["_previousPos", [0,0,0], [[]], 3],
        ["_dir", 0, [0]],
        ["_loadout", [], [[]], 10],
        ["_flagTexture", "", [""]],
        ["_isContaminated", false, [false]],
        ["_medicalDeserializeState", "", [""]],
        ["_vehicle", objNull, [objNull]],
        ["_field_rations", [], [[]]]
    ];

    if (btc_debug) then {
        [format ["deserializing %1 with: %2", name player, _this], __FILE__, [false]] call btc_debug_fnc_message;
    };

    [{player setUnitLoadout _this}, _loadout] call CBA_fnc_execNextFrame;

    player setDir _dir; //keep setDir above setPos to sync direction between clients https://community.bistudio.com/wiki/setDir
    if ((isNull _vehicle) || {!(player moveInAny _vehicle)}) then {
        player setPosASL _previousPos;
    };

    player forceFlagTexture _flagTexture;
    [{player getVariable ["ace_medical_initialized", false]}, {
        [player, _this] call ace_medical_fnc_deserializeState;
    }, _medicalDeserializeState] call CBA_fnc_waitUntilAndExecute;

    _field_rations params [["_thirst", 0, [0]], ["_hunger", 0, [0]]];
    player setVariable ["acex_field_rations_thirst", _thirst, true];
    player setVariable ["acex_field_rations_hunger", _hunger, true];

}, _this] call CBA_fnc_waitUntilAndExecute;
