
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_serializeState

Description:
    Serialize player slot.

Parameters:
    _unit - Unit. [Object]

Returns:

Examples:
    (begin example)
        [allPlayers#0] call btc_slot_fnc_serializeState;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_unit", objNull, [objNull]]
];

private _key = [getPlayerUID _unit, _unit getVariable ["btc_slot_player", -1]] select btc_p_slot_isShared;
if(typeName _key isEqualTo "SCALAR") then {
    if(_key < 0) exitWith {}; //out of bounds check for invalid player slot
};

private _data = [
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
    ]
];

btc_slots_serialized set [_key, _data];

if (btc_debug) then {
    [format ["%1 recording data: %2", [name _unit, _key] select btc_p_slot_isShared, _data], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};