
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

btc_slot_data = [];
if (_uid in btc_slots_serialized) then {
    btc_slot_data = btc_slots_serialized get _uid;
};

private _unit = _uid call BIS_fnc_getUnitByUID;
if(alive _unit) then {
    btc_slots_serialized set [_uid, [
        getPosASL _unit,
        getDir _unit,
        getUnitLoadout _unit,
        getForcedFlagTexture _unit,
        _unit in btc_chem_contaminated,
        [_unit] call ace_medical_fnc_serializeState,
        vehicle _unit,
        [
            _unit getVariable ["acex_field_rations_thirst", 0],
            _unit getVariable ["acex_field_rations_hunger", 0]
        ],
        [_unit] call ace_hearing_fnc_hasEarPlugsIn,
        _uid
    ]];
};


if(btc_debug) then {
    [format ["%1(%2) retrieving and saving data", name _unit, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
};

remoteExecutedOwner publicVariableClient "btc_slot_data";