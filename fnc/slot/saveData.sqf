
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_saveData

Description:
    Server saves player data into btc_slots_serialized global var

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_saveData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_uid", "", [""]],
    ["_unit", objNull, [objNull]]
];

if(_uid isEqualTo "") exitWith {
    if(btc_debug) then {
        ["invalid _uid", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

if(isNull _unit) then {
    _unit = _uid call BIS_fnc_getUnitByUID;
};
if(isNull _unit) exitWith {
    if(btc_debug) then {
        ["null _unit retrieved by _uid", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

private _data = createHashMapFromArray [
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
btc_slots_serialized set [_uid, _data];


if(btc_debug) then {
    [format ["%1(%2) saving data", name _unit, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
};

[_uid, _data]