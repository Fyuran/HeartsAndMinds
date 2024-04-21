
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_resupply_unpacked

Description:
    Manages unpacked logistic object

Parameters:

Returns:

Examples:
    (begin example)
        _result = [player] call btc_log_fob_fnc_resupply_unpacked;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_target", objNull, [objNull]],
    ["_actions", [], [[]]]
];

if(!alive _target) exitWith {
    ["_target is null or not alive", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};


private _obj = createVehicle [btc_log_fob_create_obj_resupply#1, getPosATL _target, [], 0, "CAN_COLLIDE"];
private _resources = _target getVariable ["btc_log_resources", 0];
[_obj, [vectorDir _target, vectorUp _target], _resources, true] call btc_log_fob_fnc_resupply_init;
_marker_flag = createVehicle ["FlagMarker_01_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_marker_flag attachTo [_obj, [0,0,1]];

btc_log_fob_supply_objects deleteAt (btc_log_fob_supply_objects find _target);
btc_log_fob_supply_objects pushBack _obj;
publicVariable "btc_log_fob_supply_objects";

private _markers = _target getVariable ["markers", []];
_markers apply {deleteMarker _x};


(attachedObjects _target) apply {deleteVehicle _x};
deleteVehicle _target;

playSound3D ["a3\missions_f_bootcamp\data\sounds\assemble_target.wss", _obj, false, getPosASL _obj, 5, 1, 10];

_actions apply {
    [_obj, 0, ["ACE_MainActions"], _x] remoteExecCall ["ace_interact_menu_fnc_addActionToObject", [0, -2] select isDedicated, _obj];
};

_obj