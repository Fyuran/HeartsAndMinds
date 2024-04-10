
/* ----------------------------------------------------------------------------
Function: btc_fnc_getCompositionBoundingBox

Description:

Parameters:
    _objs -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_fnc_getCompositionBoundingBox;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_objs", [], [[], objNull]]
];

if(_objs isEqualType objNull) then {_objs = [_objs]};

private _positionCenterX = 0;
private _positionCenterY = 0;
private _positionCenterZ = 0;
private _positions = _objs apply {getPosWorld _x};
_positions apply {
    _positionCenterX = _positionCenterX + _x#0;
    _positionCenterY = _positionCenterY + _x#1;
    _positionCenterZ = _positionCenterZ + _x#2;
};
private _compositionCenter = [ //retrieve centroid
    [_positionCenterX, _positionCenterY, _positionCenterZ], 
    count _positions
] call BIS_fnc_vectorDivide;

private _centerDummy = createVehicle["CBA_NamespaceDummy", [0,0,0], [], 0, "CAN_COLLIDE"];
_centerDummy setPosASL _compositionCenter;
if(btc_debug) then {
    private _sphere = createVehicle ["Sign_Sphere25cm_F", _centerDummy, [], 0, "CAN_COLLIDE"];
    _sphere setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0,1,1,ca)'];
    _sphere attachTo [_centerDummy];
};

private _boundingCorners = [];
_objs apply {
    private _model = _x;
    private _bbR = boundingBoxReal _model;
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
        _boundingCorners pushBackUnique ((_model modelToWorldWorld _x)vectorDiff _compositionCenter);
        if(btc_debug) then {
            private _sphere = createVehicle ["Sign_Sphere25cm_F", _model modelToWorldVisual _x, [], 0, "CAN_COLLIDE"];
            _sphere attachTo [_centerDummy];
        };
    };
};

private _mapSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");

private _lowestX = _mapSize;
private _lowestY = _mapSize;
private _lowestZ = _mapSize;

private _highestX = -_mapSize;
private _highestY = -_mapSize; 
private _highestZ = -_mapSize;

_boundingCorners apply {
    _x params ["_cordX", "_cordY", "_cordZ"];
    _lowestX = _cordX min _lowestX;
    _lowestY = _cordY min _lowestY;
    _lowestZ = _cordZ min _lowestZ;

    _highestX = _cordX max _highestX;
    _highestY = _cordY max _highestY;
    _highestZ = _cordZ max _highestZ;
};

private _lowestRelPos = [_lowestX, _lowestY, _lowestZ];
private _highestRelPos = [_highestX, _highestY, _highestZ];
private _boundingBoxSize = _lowestRelPos vectorDiff _highestRelPos; 

if (btc_debug) then {
    #define A		(_centerDummy modelToWorldVisual [_lowestX,_lowestY,_lowestZ])
    #define B		(_centerDummy modelToWorldVisual [_highestX,_lowestY,_lowestZ])
    #define C		(_centerDummy modelToWorldVisual [_highestX,_lowestY,_highestZ])
    #define D		(_centerDummy modelToWorldVisual [_lowestX,_lowestY,_highestZ])
    #define E		(_centerDummy modelToWorldVisual [_lowestX,_highestY,_lowestZ])
    #define F		(_centerDummy modelToWorldVisual [_highestX,_highestY,_lowestZ])
    #define G		(_centerDummy modelToWorldVisual [_highestX,_highestY,_highestZ])
    #define H		(_centerDummy modelToWorldVisual [_lowestX,_highestY,_highestZ])
    #define PURPLE  [1, 0, 1, 1]
    btc_debug_corners = _boundingCorners apply {
        [ASLtoAGL _compositionCenter, _centerDummy modelToWorldVisual _x, [1,1,0,1]];
    };
    btc_debug_lowestPos = _centerDummy modelToWorldVisual _lowestRelPos;
    btc_debug_highestPos = _centerDummy modelToWorldVisual _highestRelPos;
	drawBoundingBox_edges = [
		[A, B, PURPLE],
		[B, C, PURPLE],
		[C, D, PURPLE],
		[D, A, PURPLE],
		[E, F, PURPLE],
		[F, G, PURPLE],
		[G, H, PURPLE],
		[H, E, PURPLE],
		[A, E, PURPLE],
		[B, F, PURPLE],
		[C, G, PURPLE],
		[D, H, PURPLE] 
	];

    removeMissionEventHandler["Draw3D", missionNamespace getVariable ["btc_compositionboundingsize_eh", -1]];
    btc_compositionboundingsize_eh = addMissionEventHandler ["Draw3D", {
            drawLine3D [btc_debug_lowestPos, btc_debug_highestPos, [1, 0, 0, 1]];
            drawBoundingBox_edges apply {
                _screenPosition = worldToScreen _x#0;
                if (_screenPosition isEqualTo []) then { continue };
                drawLine3D _x;
            };
    }];
};

private _return = [_lowestRelPos, _highestRelPos, vectorMagnitude _boundingBoxSize];
if(btc_debug) then {_return pushBack _centerDummy};

_return
