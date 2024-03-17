
/* ----------------------------------------------------------------------------
Function: btc_fnc_getCompositionBoundingSize

Description:
	Adds action to place down a jail

Parameters:
    _fob -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_fnc_getCompositionBoundingSize;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_objs", [], [[], objNull]]
];

if(_objs isEqualType objNull) exitWith {2 boundingBoxReal _objs};

private _boundingCornersPos = [];
_objs apply {
    private _model = _x;
    private _bbR = 2 boundingBoxReal _model;
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
        _boundingCornersPos pushBack (_model modelToWorld _x);
    };
};

private _mapSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");

private _lowestX = _mapSize;
private _lowestY = _mapSize;
private _lowestZ = _mapSize;

private _highestX = -_mapSize;
private _highestY = -_mapSize;
private _highestZ = -_mapSize;

_boundingCornersPos apply {
    _x params ["_cordX", "_cordY", "_cordZ"];
    _lowestX = _cordX min _lowestX;
    _lowestY = _cordY min _lowestY;
    _lowestZ = _cordZ min _lowestZ;

    _highestX = _cordX max _highestX;
    _highestY = _cordY max _highestY;
    _highestZ = _cordZ max _highestZ;
};

private _lowestPos = [_lowestX, _lowestY, _lowestZ];
private _highestPos = [_highestX, _highestY, _highestZ];
private _sizeVec = _highestPos vectorDiff _lowestPos; 

if (btc_debug) then {
    _boundingCornersPos apply {
        _pos = +_x;
        if(_pos#2 < 0) then {_pos set[2, 0]};
        createVehicle ["Sign_Sphere25cm_F", _x, [], 0, "CAN_COLLIDE"];
    };

    btc_debug_lowestPos = _lowestPos;
    btc_debug_highestPos = _highestPos;
    removeMissionEventHandler["Draw3D", missionNamespace getVariable ["btc_compositionboundingsize_eh", -1]];
    btc_compositionboundingsize_eh = addMissionEventHandler ["Draw3D", {
            drawLine3D [btc_debug_lowestPos, btc_debug_highestPos, [1, 0, 0, 1]];
    }];
};

[_lowestPos, _highestPos, vectorMagnitude _sizeVec]