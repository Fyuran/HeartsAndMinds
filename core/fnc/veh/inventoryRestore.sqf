#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_inventoryRestore

Description:
    Fill me when you edit me !

Parameters:
    _object - Object to restore inventory. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_veh_fnc_inventoryRestore;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_object", objNull, [objNull]]
];

private _inventory = _object getVariable ["btc_EDENinventory", []];
if (_inventory isEqualTo []) then {
    _inventory = (typeOf _object) call FUNC(log,inventoryGet);
};

[
    _object,
    _inventory
] call FUNC(log,inventorySet);
