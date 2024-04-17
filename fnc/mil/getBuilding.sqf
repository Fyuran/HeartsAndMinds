
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_getBuilding

Description:
    Fill me when you edit me !

Parameters:
    _rpos - [Array]
    _n - [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_mil_fnc_getBuilding;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_rpos", [0, 0, 0], [[]]],
    ["_n", 0, [0]]
];

private _building = objNull;
([_rpos, 70] call btc_mil_fnc_getStructures) params ["_structures", "_houses"];

if (_structures isEqualTo []) then {
    if (_houses isNotEqualTo []) then {
        _building = selectRandom _houses;
        _n = 1;
    };
} else {
    _building = selectRandom _structures;
    _n = count (_building buildingPos -1);
    if (_n > 8) then {
        _n = 2;
    } else {
        _n = floor (_n/2);
    };
};

[_n, _building]
