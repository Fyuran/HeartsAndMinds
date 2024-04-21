
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_resupply_init

Description:
    Inits log object vars

Parameters:

Returns:

Examples:
    (begin example)
        _result = [cursorObject, btc_log_fob_max_resources] call btc_log_fob_fnc_resupply_init;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
    ["_obj", objNull, [objNull]],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2],
    ["_resources", 0, [0]],
    ["_isClaimed", false, [false]]
];

if(!alive _obj) exitWith {
    ["_obj is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};
if !((typeOf _obj) in btc_log_fob_create_obj_resupply) exitWith {
    [format["_obj(%1) is not a supply fob log object", typeOf _obj], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

_obj setVectorDirAndUp _vectorDirAndUp;
_obj enableSimulationGlobal false;
_obj allowDamage false;
_obj setVariable ["btc_fob_log_isClaimed", _isClaimed];

[_obj, 2] call ace_cargo_fnc_setSize; //-1 to disable Load in Cargo
[_obj, 0] call ace_cargo_fnc_setSpace;

{
    _x addCuratorEditableObjects [[_obj], false];
} forEach allCurators;

_obj setVariable ["btc_log_resources", _resources, true];

_obj