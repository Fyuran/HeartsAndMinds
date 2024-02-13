    
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_handleDisconnect

Description:
    Fire the event playerConnected.

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

if (_unit in (entities "HeadlessClient_F")) then {
    deleteVehicle _unit;
};

if(!isPlayer _unit) exitWith {}; //Avoid recording garbage data

if (alive _unit) then {
    if (btc_debug) then {
        [format ["for %1, %2, %3, [%2]", _name, _unit, [_uid, _unit getVariable ["btc_slot_player", -1]] select btc_p_slot_isShare, _this], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    };
    _unit call btc_slot_fnc_serializeState;
};
false