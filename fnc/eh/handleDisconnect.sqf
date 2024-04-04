    
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_handleDisconnect

Description:
    Fire the event handleDisconnect.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_handleDisconnect;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params ["_unit", "_id", "_uid", "_name"];
if(btc_debug) then {
    [format ["for %1, %2, %3, [%2]", _name, _unit, [_uid, _unit getVariable ["btc_slot_player", -1]] select btc_p_slot_isShared, _this], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
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
    ],
    [_unit] call ace_hearing_fnc_hasEarPlugsIn
];
btc_slots_serialized set [_uid, _data];

false