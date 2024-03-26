
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_removeJail_s

Description:
    Deletes FOB's jail

Parameters:
    _target -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_jail_fnc_removeJail_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_target", objNull, [objNull]]
];

private _jail = _target getVariable ["btc_jail", objNull];
if(!alive _jail) exitWith {};

private _jailed = _jail getVariable ["btc_jailed", []];
((attachedObjects _jail) + _jailed) apply {
    deleteVehicle _x;
};
deleteVehicle _jail;

btc_jails deleteAt (btc_jails find _jail);
publicVariable "btc_jails";