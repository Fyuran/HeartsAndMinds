
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_removeJail_s

Description:
    Deletes FOB's jail

Parameters:
    _flag -

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
    ["_flag", objNull, [objNull]]
];

if(!alive _flag) exitWith {
    ["_flag is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _jail = _flag getVariable ["btc_jail", objNull];
if(!alive _jail) exitWith {};

private _jailed = _jail getVariable ["btc_jailed", []];
((attachedObjects _jail) + _jailed) apply {
    deleteVehicle _x;
};
deleteVehicle _jail;

btc_jails deleteAt (btc_jails find _jail);
publicVariable "btc_jails";