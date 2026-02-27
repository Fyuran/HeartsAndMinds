#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_biopsy

Description:
    Perform chemical contamination analysis on a unit and display notification of contamination status. Only processes on successful biopsy completion.

Parameters:
    _data[ARRAY]: Biopsy data array containing [unit, body_part, health_value] (default: [])
    _success[BOOLEAN]: Whether the biopsy procedure completed successfully (default: false)

Returns:
    ARRAY: Input parameters

Examples:
    (begin example)
        [[player, "head", 50], true] call btc_chem_fnc_biopsy;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_data", [], [[]]],
    ["_success", false, [true]]
];

if !(_success) exitWith {_this};

private _obj = _data select 0;
([
    localize "STR_BTC_HAM_O_CHEM_NOTCONTA",
    localize "STR_BTC_HAM_O_CHEM_CONTA"
] select (_obj in btc_chem_contaminated)) call CBA_fnc_notify;

_this
