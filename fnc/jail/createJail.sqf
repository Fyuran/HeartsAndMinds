
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_createJail

Description:
    Creates FOB's jail

Parameters:
    _target -

Returns:

Examples:
    (begin example)
        [player, cursorObject] call btc_jail_fnc_createJail;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_player", objNull, [objNull]],
    ["_target", objNull, [objNull]]
];

if(!canSuspend) exitWith {
    if(btc_debug) then {
        ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};
if(!(isPlayer _player) or (!alive _player)) exitWith {
    ["bad _player param", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _target) exitWith {
    ["null _target param", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _jail = createVehicleLocal["CBA_NamespaceDummy", [0, 0, 0], [], 0, "CAN_COLLIDE"];
btc_jail_comp apply {
    private _obj = createVehicleLocal[_x#0, _x#1, [], 0, "CAN_COLLIDE"];
    _obj setPosATL _x#1;
    _obj setDir _x#2;
    [_obj, _jail] call BIS_fnc_attachToRelative;
    _obj allowDamage false;
};

private _jailPositions = _jail getVariable ["btc_jail_positions", [_jail, 45] call btc_fnc_circlePosAroundObj];
_jailPositions pushBack getPosATL _jail; //add center of jail to list of available positions

private _arrow = createVehicleLocal["Sign_Arrow_Large_Blue_F", [0, 0, 0], [], 0, "CAN_COLLIDE"];
[_arrow, _jail] call BIS_fnc_attachToRelative;

_eyeDir = eyeDirection _player;
_jail setVectorDir _eyeDir;
_pos_ATL = getPosATL _player;
_jail setPosATL (_pos_ATL vectorAdd (_eyeDir vectorMultiply 14));

private _attachedObjects = attachedObjects _jail;

if(btc_debug) then {
    [format["executing btc_log_fnc_place to %1 with %2 boundingBoxReal", 
        _jail, _attachedObjects call btc_fnc_getCompositionBoundingBox],
            __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;  
};

[_jail, _attachedObjects call btc_fnc_getCompositionBoundingBox] call btc_log_fnc_place;
waitUntil {!btc_log_placing};

private _pos = getPosATL _jail;
private _direction = direction _jail;

_attachedObjects apply {deleteVehicle _x};
deleteVehicle _jail;

[_target, _pos, [vectorDir _jail, vectorUp _jail]] 
    remoteExecCall ["btc_jail_fnc_createJail_s", [0, 2] select isMultiplayer];