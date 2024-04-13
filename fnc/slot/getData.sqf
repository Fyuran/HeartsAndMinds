
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_getData

Description:
    Server replies with requested player data

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_getData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_uid", "", [""]]
];

if(_uid isEqualTo "") exitWith {
    if(btc_debug) then {
        ["invalid _uid", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

btc_slot_data = createHashMap;
if (_uid in btc_slots_serialized) then {
    btc_slot_data = btc_slots_serialized getOrDefault [_uid, []];
};

if(isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 0}) then { //relay back data to requesting client
    remoteExecutedOwner publicVariableClient "btc_slot_data";
};

private _unit = _uid call BIS_fnc_getUnitByUID;
if(alive _unit) then {
    private _slot = createHashMapFromArray [
        ["previousPos", getPosASL _unit],
        ["dir", getDir _unit],
        ["loadout", getUnitLoadout _unit],
        ["flagTexture", getForcedFlagTexture _unit],
        ["isContaminated", _unit in btc_chem_contaminated],
        ["medicalState", [_unit] call btc_json_fnc_medical_serializeState],
        ["field_rations", [
            _unit getVariable ["acex_field_rations_thirst", 0],
            _unit getVariable ["acex_field_rations_hunger", 0]
        ]],
        ["hasEarPlugsIn", [_unit] call ace_hearing_fnc_hasEarPlugsIn],
        ["uid", _uid]
    ];
    btc_slots_serialized set [_uid, _slot];
};


if(btc_debug) then {
    [format ["%1(%2) retrieving and saving data", name _unit, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
};

btc_slot_data