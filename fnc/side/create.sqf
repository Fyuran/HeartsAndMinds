
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_create

Description:
    Create side mission inside the H&M task system.

Parameters:
    _cycle - Cycle side mission. [Boolean]
    _side_fnc_name - Side mission function name. [String]

Returns:

Examples:
    (begin example)
        [false, "btc_side_fnc_supply"] call btc_side_fnc_create;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_cycle", false, [false]],
    ["_side", "", [""]]
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

private _id = btc_side_ids getOrDefault [_side, 0, true];
private _tskID = format ["btc_side_%1_task_%2", _side, btc_side_ID];
if ([_tskID] call BIS_fnc_taskExists) exitWith {
    [[]] call btc_debug_fnc_log;
};

[_tskID] spawn (missionNamespace getVariable [format ["btc_side_fnc_%1", _side], {}]);

if (_cycle) then {
    [true] call btc_side_fnc_create;
};
