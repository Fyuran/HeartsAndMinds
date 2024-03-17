
/* ----------------------------------------------------------------------------
Function: btc_fnc_find_highest_pos

Description:
	Attempts to find the highest position on a building

Parameters:
    _building -
    _detail -
    _showHelpers -

Returns:

Examples:
    (begin example)
        [cursorObject, 4, true] call btc_fnc_find_highest_pos;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_building", objNull, [objNull]],
    ["_detail", 4, [0]], //how many search grids will be used
    ["_LOD", 3, [0]],
    ["_showHelpers", false, [false]]
];

if(isNull _building) exitWith {["Invalid _building param", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

_LOD = abs _LOD; //prevent negative LODs
//LOD types
// 0 - ClipVisual (can significantly reduce bounding box's size on buildings)
// 1 - ClipShadow
// 2 - ClipGeometry
// 3 - ClipGeneral (same type that is used in the main syntax)
if(_LOD > 3) exitWith {[format["Invalid _LOD: %1, must be between 0 and 3 (included)", _LOD], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

if(_detail <= 0) exitWith {[format["Invalid _detail: %1, must be above zero", _detail], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

private _boundingBox = _LOD boundingBox _building; //[[xmin, ymin, zmin], [xmax, ymax, zmax], boundingSphereDiameter].
_boundingBox#0 params ["_xMin", "_yMin", "_zMin"];
_boundingBox#1 params ["_xMax", "_yMax", "_zMax"];
_zMax = _zMax + 2; //nudge zMax a bit higher to avoid clipping

if(_showHelpers) then {
    btc_highest_pos_debug_objects = missionNamespace getVariable ["btc_highest_pos_debug_objects", [[],[], objNull]];
    if (btc_highest_pos_debug_objects isNotEqualTo [[],[], objNull]) then {
        btc_highest_pos_debug_objects#0 apply {deleteVehicle _x};
        btc_highest_pos_debug_objects#1 apply {deleteVehicle _x};
        deleteVehicle (btc_highest_pos_debug_objects#2);
        btc_highest_pos_debug_objects = [[],[], objNull]; //Base plane objs, lineIntersects objs and highest point obj
    };
};


private _highestSurfaceATL = [[0, 0, 0], 0]; //highestPosATL and surfaceNormal
for "_yStep" from _yMin to _yMax step (_yMax / _detail) do {
    for "_xStep" from _xMin to _xMax step (_xMax / _detail) do {
        private _pos = _building modelToWorld [_xStep, _yStep, _zMax];
        private _ground = +_pos; 
        _ground set[2, -1];

        //lineIntersectsSurfaces returns an array of arrays [[1st result], [2nd result]...]
        private _surface = (lineIntersectsSurfaces [ATLtoASL _pos, ATLtoASL _ground]) select 0;
        if(_surface isNotEqualTo []) then {
            private _surfacePosATL = ASLtoATL (_surface#0);
            if(_showHelpers) then {
                private _sphere = createVehicle ["Sign_Sphere25cm_F", _surfacePosATL, [], 0, "CAN_COLLIDE"];
                btc_highest_pos_debug_objects#1 pushBack _sphere;
            };
            private _highestPosATL = _highestSurfaceATL#0;
            if ((_surfacePosATL#2) > (_highestPosATL#2)) then { //check heights between previous highest point and this one
                _highestSurfaceATL set[0, _surfacePosATL];
                _highestSurfaceATL set[1, _surface#1]; //surface normal
                if(_showHelpers) then {
                    btc_highest_pos_debug_objects#2 setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0.6,0.1,1.0,ca)'];
                    private _sphere = btc_highest_pos_debug_objects#1 select (count (btc_highest_pos_debug_objects#1) - 1);
                    _sphere setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0,0,1,ca)'];
                    btc_highest_pos_debug_objects set [2, _sphere];
                };
            };
        };

        if(_showHelpers) then {
            private _sphere = createVehicle ["Sign_Sphere25cm_F", _pos, [], 0, "CAN_COLLIDE"];
            btc_highest_pos_debug_objects#0 pushBack _sphere;
        };
    };
};

if(_showHelpers) then {
    publicVariable "btc_highest_pos_debug_objects";
    [[], {
        btc_highest_pos_debug_eh = missionNamespace getVariable ["btc_highest_pos_debug_eh", -1];
        if(btc_highest_pos_debug_eh isNotEqualTo -1) then {
            removeMissionEventHandler ["Draw3D", btc_highest_pos_debug_eh];
        };
        btc_highest_pos_debug_eh = addMissionEventHandler ["Draw3D", {
            _debug_objs = (btc_highest_pos_debug_objects#0) + [btc_highest_pos_debug_objects#2];
            _debug_objs apply {
                _screenPosition = worldToScreen (_x modelToWorldVisual [0,0,0]);
                if (_screenPosition isEqualTo []) then { continue };

                _pos = getPosATLVisual _x;
                _ground = +_pos;
                _ground set[2, 0];
                drawLine3D [_pos, _ground, [0, 0, 1, 1]];
            };
        }];
    }] remoteExecCall ["call", [0, -2] select isDedicated];

};

_highestSurfaceATL