#include "..\script_macros.hpp"
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

params[
    ["_flag", objNull, [objNull]],
    ["_pos", [0,0,0], [[]], 3],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2]
];

if(!alive _flag) exitWith {
    #ifdef BTC_DEBUG_JAIL
    [["%1: _flag is null or not alive", __FILE_NAME__], 6, "jail"] call btc_debug_fnc_message;
    #endif
};

#ifdef BTC_DEBUG_JAIL
[["%1: btc_jail_fnc_createJail_s: %2", __FILE_NAME__, _this], 2, "jail"] call btc_debug_fnc_message;  
#endif

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

_jail