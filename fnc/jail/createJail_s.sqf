
/* ----------------------------------------------------------------------------
Function: btc_jail_fnc_createJail_s

Description:
    Creates FOB's jail

Parameters:
    _flag -

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
    ["_flag", objNull, [objNull]],
    ["_pos", [0,0,0], [[]], 3],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2]
];

if(!alive _flag) exitWith {
    ["_flag is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

if(btc_debug) then {
    [format["btc_jail_fnc_createJail_s: %1", _this],
            __FILE__, [false, btc_debug_log, false], false] call btc_debug_fnc_message;  
};

private _jail = createVehicle["CBA_NamespaceDummy", [0,0,0], [], 0, "CAN_COLLIDE"];
btc_jail_comp apply {
    private _obj = createVehicle[_x#0, _x#1, [], 0, "CAN_COLLIDE"];
    _obj setPosATL _x#1;
    _obj setDir _x#2;
    [_obj, _jail, false] call BIS_fnc_attachToRelative;
    _obj allowDamage false;
};
_jail setPosATL _pos;
_jail setVectorDirAndUp _vectorDirAndUp;

private _jailPositions = _jail getVariable ["btc_jail_positions", [_jail, 45] call btc_fnc_circlePosAroundObj];
_jailPositions pushBack getPosATL _jail; //add center of jail to list of available positions
_jail setVariable ["btc_jail_positions", _jailPositions];

_flag setVariable ["btc_jail", _jail, true];
btc_jails pushBack _jail;
publicVariable "btc_jails";