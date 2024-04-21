
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_getData

Description:
    Server replies with requested player data if it exists

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
if(isNil "btc_slots_serialized") exitWith {
    if(btc_debug) then {
        ["btc_slots_serialized is nil", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

btc_slot_data = btc_slots_serialized getOrDefault [_uid, createHashMap];

if(isRemoteExecuted && {remoteExecutedOwner isNotEqualTo 0}) then { //relay back data to requesting client
    remoteExecutedOwner publicVariableClient "btc_slot_data";
    if(btc_debug) then {
        private _unit = _uid call BIS_fnc_getUnitByUID;
        [format ["%1(%2) retrieving data", name _unit, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
    };

};

btc_slot_data