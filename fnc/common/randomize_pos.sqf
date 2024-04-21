
/* ----------------------------------------------------------------------------
Function: btc_fnc_randomize_pos

Description:
    Randomize position.

Parameters:
    _pos - Starting position. [Array]
    _random_area - Area of radomization. [Number]
    _allowWater - Allow water position. [Boolean]

Returns:
    _return_pos - New position. [Array]

Examples:
    (begin example)
        _return_pos = [getPos player] call btc_fnc_randomize_pos;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_pos", [0, 0, 0], [[], objNull]],
    ["_random_area", 300, [0]],
    ["_allowWater", false, [true]],
    ["_onRoad", false, [true]]
];

if(_pos isEqualType objNull) then {
    _pos = getPosASL _pos;
};

private _return_pos = _pos;

_check_pos = [_pos, _random_area] call CBA_fnc_randPos;

if ((surfaceIsWater _check_pos) && {!(_allowWater)}) then {
    _return_pos = [_check_pos, 0, _random_area, 13, false] call btc_fnc_findsafepos;
    if(_onRoad) then {
        private _roads = _return_pos nearRoads _random_area;
        if !(_roads isEqualTo []) then {
            _return_pos = [getPosATL (selectRandom _roads), 0, 30, 13, false] call btc_fnc_findsafepos;
        };
    };
} else {
    _return_pos = _check_pos;
};
_return_pos
