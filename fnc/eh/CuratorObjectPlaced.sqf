#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_CuratorObjectPlaced

Description:
    Initialise object placed by curator.

Parameters:
    _curator - Curator. [Object]
    _object_placed - Object/Unit placed. [Object]

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_eh_fnc_CuratorObjectPlaced;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_curator", objNull, [objNull]],
    ["_object_placed", objNull, [objNull]]
];

if !((_object_placed isKindOf "allVehicles") || (_object_placed isKindOf "Module_F")) then {
    [_object_placed] remoteExecCall ["btc_log_fnc_init", 2];
    #ifdef BTC_DEBUG_EH
    [["%1: CURATOR OBJECT PLACED %2 INIT", __FILE_NAME__, _object_placed], 2, "eh"] call btc_debug_fnc_message;    
    #endif
};
