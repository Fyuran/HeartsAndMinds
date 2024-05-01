/* ----------------------------------------------------------------------------
Function: btc_log_resupply_fnc_delete

Description:
    Manages safe removal of claimed crate

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_resupply_fnc_delete;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_from", objNull, [objNull]],
    ["_player", objNull, [objNull]]
];

if(isNull _from) exitWith {};

btc_log_fob_supply_objects deleteAt (btc_log_fob_supply_objects find _from);
publicVariable "btc_log_fob_supply_objects";

(attachedObjects _from) apply {deleteVehicle _x};
deleteVehicle _from;