
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_createJail_s

Description:
    Creates FOB's jail

Parameters:
    _target -

Returns:

Examples:
    (begin example)
        [player, cursorObject] call btc_jail_fnc_createJail_s;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_player", objNull, [objNull]],
    ["_target", objNull, [objNull]],
    ["_pos", [0,0,0], [[]]],
    ["_dir", 0]
];

if(!(isPlayer _player) or (!alive _player)) exitWith {
    ["_player is not player or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(!alive _target) exitWith {
    ["_target is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

_jail = createVehicle["CBA_NamespaceDummy", [0, 0, 0], [], 0, "CAN_COLLIDE"];
[
    ["Land_Net_Fence_Gate_F", [0, -4, 0], 0], 
    ["Land_Razorwire_F", [4, 0, 0], 90], 
    ["Land_Razorwire_F", [0, 4, 0], 0], 
    ["Land_Razorwire_F", [-4, 0, 0], 90]
] apply {
    private _obj = createVehicle[_x#0, _x#1, [], 0, "CAN_COLLIDE"];
    _obj setPosATL _x#1;
    _obj setDir _x#2;
    [_obj, _jail] call BIS_fnc_attachToRelative;
    _obj allowDamage false;
};

private _jailPositions = _jail getVariable ["btc_jail_positions", [_jail, 45] call btc_fnc_circlePosAroundObj];
_jailPositions pushBack getPosATL _jail; //add center of jail to list of available positions
_jail setVariable ["btc_jail_positions", _jailPositions];

private _helpers = _jail getVariable ["btc_log_helpers", []];
_arrow = createVehicle["Sign_Arrow_Large_Blue_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
[_arrow, _jail] call BIS_fnc_attachToRelative;
_helpers pushBack _arrow;

_jailPositions apply {
    private _sphere = createVehicle ["Sign_Sphere25cm_F", _x, [], 0, "CAN_COLLIDE"];
    [_sphere, _jail] call BIS_fnc_attachToRelative;
    _helpers pushBack _sphere;
};
_jail setVariable ["btc_log_helpers", _helpers, true];

if(_pos isEqualTo [0,0,0]) then {
    _eyeDir = eyeDirection _player;
    _jail setVectorDir _eyeDir;
    _pos_ATL = getPosATL _player;
    _jail setPosATL (_pos_ATL vectorAdd (_eyeDir vectorMultiply 14));
    [_jail, [(attachedObjects _jail)] call btc_fnc_getCompositionBoundingSize] remoteExecCall ["btc_log_fnc_place", _player];
} else {
    _jail setPosATL _pos;
    _jail setDir _dir;
};


if(btc_debug) then {
    [format[
        "executing btc_log_fnc_place to %1 with %2 boundingBoxReal", 
        _jail, [(attachedObjects _jail)] call btc_fnc_getCompositionBoundingSize
    ], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;  
};



_target setVariable ["btc_jail", _jail];
btc_jails pushBack _jail;
publicVariable "btc_jails";