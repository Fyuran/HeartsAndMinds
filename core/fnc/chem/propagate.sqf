#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_propagate

Description:
    Cross-contaminate items and vehicles when transferred between contaminated and non-contaminated objects, propagating chemical status across inventory and mounted cargo.

Parameters:
    _item[OBJECT or STRING]: Item or object to transfer
    _vehicle[OBJECT]: Destination vehicle or container

Returns:
    ARRAY: Input parameters as array

Examples:
    (begin example)
        [cursorObject, vehicle player] call btc_chem_fnc_propagate;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_item", objNull, [objNull, ""]],
    ["_vehicle", objNull, [objNull]]
];

if (_item isEqualType "") exitWith {_this};

if (_item in btc_chem_contaminated) then {
    if ((btc_chem_contaminated pushBackUnique _vehicle) > -1) then {
        publicVariable "btc_chem_contaminated";
    };
} else {
    if (_vehicle in btc_chem_contaminated) then {
        if ((btc_chem_contaminated pushBackUnique _item) > -1) then {
            publicVariable "btc_chem_contaminated";
        };
    };
};

_this
