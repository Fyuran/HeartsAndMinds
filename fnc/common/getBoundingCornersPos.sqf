
/* ----------------------------------------------------------------------------
Function: btc_fnc_getBoundingCornersPos

Description:

Parameters:
    _objs -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_fnc_getBoundingCornersPos;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_objs", [], [[], objNull]]
];

if(_objs isEqualType objNull) then {
    _objs = [_objs];
};

private _boundingCorners = [];
_objs apply {
    private _model = _x;
    private _bbR = 0 boundingBoxReal _model;
    _bbR params ["_boxMin", "_boxMax"];

    private _corners = [
        _boxMin,
        [_boxMax#0, _boxMin#1, _boxMin#2],
        [_boxMax#0, _boxMax#1, _boxMin#2],
        [_boxMin#0, _boxMax#1, _boxMin#2],

        [_boxMin#0, _boxMin#1, _boxMax#2],
        [_boxMax#0, _boxMin#1, _boxMax#2],
        _boxMax,
        [_boxMin#0, _boxMax#1, _boxMax#2]

    ] apply {
        _boundingCorners pushBackUnique (_model modelToWorldWorld _x);
        if(btc_debug) then {
            private _pos = _model modelToWorldVisual _x;
            if(_pos#2 < 0) then {_pos set [2,0]};
            private _sphere = createVehicle ["Sign_Sphere25cm_F", _model modelToWorldVisual _x, [], 0, "CAN_COLLIDE"];
            _sphere attachTo [_model];
        };
    };
};

_boundingCorners