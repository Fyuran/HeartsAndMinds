
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_createJail

Description:
    Creates FOB's jail

Parameters:
    _flag -

Returns:

Examples:
    (begin example)
        [player, cursorObject] spawn btc_jail_fnc_createJail;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_flag", objNull, [objNull]]
];

if(!canSuspend) exitWith {
    ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};
if(!alive player) exitWith {
    ["player is dead", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if(isNull _flag) exitWith {
    ["null _flag param", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _jail = createVehicleLocal["CBA_NamespaceDummy", [0,0,0], [], 0, "CAN_COLLIDE"];
btc_jail_comp apply {
    private _obj = createVehicleLocal[_x#0, _x#1, [], 0, "CAN_COLLIDE"];
    _obj setPosATL _x#1;
    _obj setDir _x#2;
    [_obj, _jail] call BIS_fnc_attachToRelative;
    _obj allowDamage false;
};

private _arrow = createVehicleLocal["Sign_Arrow_Large_Blue_F", [0,0,0], [], 0, "CAN_COLLIDE"];
[_arrow, _jail] call BIS_fnc_attachToRelative;

private _pos_ATL = getPosATL player;
private _eyeDir = eyeDirection player;
private _new_pos_ATL = (_pos_ATL vectorAdd (_eyeDir vectorMultiply 14));
_jail setPosATL _new_pos_ATL;

private _attachedObjects = attachedObjects _jail;
[_jail] call btc_log_fnc_place;
waitUntil {!btc_log_placing};

private _pos = getPosATL _jail;
_attachedObjects apply {deleteVehicle _x};
deleteVehicle _jail;

[_flag, _pos, [vectorDir _jail, vectorUp _jail]] 
    remoteExecCall ["btc_jail_fnc_createJail_s", [0, 2] select isMultiplayer];