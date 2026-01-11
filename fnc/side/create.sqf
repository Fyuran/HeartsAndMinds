#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_create

Description:
    Create side mission inside the H&M task system.

Parameters:
    _cycle - Cycle side mission. [Boolean]
    _side - Side mission name. [String]

Returns:

Examples:
    (begin example)
        [false, "supply"] call btc_side_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_cycle", false, [false]],
    ["_side", "", [""]],
    ["_selectedPos", [0, 0, 0], [[]], 3]
];

if (_side isEqualTo "") then {
    private _sides = +btc_side_list;
    if (!btc_p_sea) then {_sides = _sides - ["CIVTREATMENTment_boat", "underwater_generator"]};
    if (!btc_p_chem) then {_sides = _sides - ["chemicalLeak", "pandemic"]};

    if (btc_side_list_use isEqualTo []) then {
        btc_side_list_use = _sides call BIS_fnc_arrayShuffle;
    };
    _side = btc_side_list_use deleteAt 0;
};

private _sideTasks = btc_side_taskIDs getOrDefault [_side, [], true];
private _tskID = format ["btc_side_%1_%2", _side, count _sideTasks];
if ([_tskID] call BIS_fnc_taskExists) exitWith {
    #ifdef BTC_DEBUG_SIDE
    [["%1: %2 already exists", __FILE_NAME__, _tskID], 6, "side"] call btc_debug_fnc_message;
    #endif
};

[_tskID, _selectedPos] spawn (missionNamespace getVariable [format ["btc_side_fnc_%1", _side], {}]);

if (_cycle) then {
    [true] call btc_side_fnc_create;
};
