
/* ----------------------------------------------------------------------------
Function: btc_fnc_ied_init_area

Description:
    Initialize positions of IEDS.

Parameters:
    _city - [Object]
    _area - [Number]
    _n - [Number]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_ied_init_area;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_city", objNull, [objNull]],
    ["_area", 100, [0]],
    ["_n", 1, [0]]
];

private _pos = getPos _city;
private _array = _city getVariable ["ieds", []];

{
    for "_i" from 1 to _n do {
        private _sel_pos = _pos;
        _sel_pos = [_pos, _area] call btc_fnc_randomize_pos;
        private _dir = random 360;

        private _roads = _sel_pos nearRoads 50;
        if (_roads isEqualTo []) then {
            _sel_pos = [_sel_pos, 0, 100, 1, false] call btc_fnc_findsafepos;
        } else {
            private _obj = selectRandom _roads;

            private _arr = _obj call btc_fnc_ied_randomRoadPos;
            _sel_pos = _arr select 0;
            _dir = _arr select 1;
        };

        _array pushBack [_sel_pos, selectRandom btc_model_ieds, _dir, _x];

        if (btc_debug) then {
            private _marker = createMarker [format ["btc_ied_%1", _sel_pos], _sel_pos];
            _marker setMarkerType "mil_warning";
            _marker setMarkerColor (["ColorBlue", "ColorRed"] select _x);
            _marker setMarkerText (["IED (fake)", "IED"] select _x);
            _marker setMarkerSize [0.8, 0.8];
        };
        if (btc_debug_log) then {
            [format ["_this = %1  POS %2  N %3(%4)", _this, _sel_pos, _i, _n], __FILE__, [false]] call btc_fnc_debug_message;
        };
    };
} forEach [true, false];

_city setVariable ["ieds", _array];
