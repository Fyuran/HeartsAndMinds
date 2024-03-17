
/* ----------------------------------------------------------------------------
Function: btc_fnc_correct_position

Description:
	Attempts to correct object position so it won't fall down

Parameters:
    _object -

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_fnc_correct_position;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_object", objNull, [objNull]],
    ["_LOD", 1, [0]],
    ["_showHelpers", false, [false]]
];

if(isNull _object) exitWith {["Invalid _object param", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

_LOD = abs _LOD; //prevent negative LODs
//LOD types
// 0 -"Memory"
// 1 - "Geometry"
// 2 - "FireGeometry"
// 3 - "LandContact"
// 4 - "HitPoints"
// 5 - "ViewGeometry"
if(_LOD > 5) exitWith {[format["Invalid _LOD: %1, must be between 0 and 5 (included)", _LOD], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;};

private _boundingBox = boundingBoxReal [_object, _LOD]; //[[xmin, ymin, zmin], [xmax, ymax, zmax], boundingSphereDiameter].
_boundingBox#0 params ["_xMin", "_yMin", "_zMin"];
_boundingBox#1 params ["_xMax", "_yMax", "_zMax"];

private _cornersRel = [
    [_xMax, _yMax, _zMin],
    [_xMin, _yMin, _zMin],
    [_xMax, _yMin, _zMin],
    [_xMin, _yMax, _zMin]
];
private _cornersATL = _cornersRel apply {
    _object modelToWorld _x;
};

if(_showHelpers) then {
    btc_correct_position_debug_objects = missionNamespace getVariable ["btc_correct_position_debug_objects", []];
    if (btc_correct_position_debug_objects isNotEqualTo []) then {
        btc_correct_position_debug_objects apply {deleteVehicle _x};
        btc_correct_position_debug_objects = [];
    };
};
{
    if(_showHelpers) then {
        private _sphere = createVehicle ["Sign_Sphere25cm_F", _x, [], 0, "CAN_COLLIDE"];
        btc_correct_position_debug_objects pushBack _sphere;
    };
    if(_x#2 > 1) then {//if there's no floor underneath
        if(_showHelpers) then {
            private _sphere = btc_correct_position_debug_objects select (count (btc_correct_position_debug_objects#1) - 1);
            _sphere setObjectTextureGlobal [0,'#(argb,8,8,3)color(0,0,1,1,ca)'];
            private _arrow = createVehicle ["Sign_Arrow_Direction_Blue_F", _x, [], 0, "CAN_COLLIDE"];
            btc_correct_position_debug_objects pushBack _arrow;
        };
        
    };
}forEach _cornersATL;


