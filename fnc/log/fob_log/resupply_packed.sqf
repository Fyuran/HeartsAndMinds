
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_resupply_packed

Description:
    Manages packed up logistic object in addition also manages unpack->packed state flow

Parameters:

Returns:

Examples:
    (begin example)
        _result = [objNull, getPos player] call btc_log_fob_fnc_resupply_packed;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_target", objNull, [objNull]],
    ["_pos", [0,0,0], [[]], 3],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2],
    ["_resources", btc_log_fob_max_resources, [0]],
    ["_isClaimed", false, [false]], //avoids getting intel about claimed supplies
    ["_markers", [], [[]]]
];

if(_vectorDirAndUp isEqualTo []) then {
    _vectorDirAndUp = [[0,1,0], surfaceNormal _pos];
};

if(!isNull _target) then { //from unpacked to packed flow
    _pos = getPosATL _target;
    _vectorDirAndUp = [vectorDir _target, vectorUp _target];
    _resources = _target getVariable ["btc_log_resources", 0];
    _isClaimed = true;

    playSound3D ["a3\missions_f_bootcamp\data\sounds\assemble_target.wss", _target, false, getPosASL _target, 5, 1, 10];

    btc_log_fob_supply_objects deleteAt (btc_log_fob_supply_objects find _target);
    (attachedObjects _target) apply {deleteVehicle _x};
    deleteVehicle _target;
};

private _obj = createVehicle [btc_log_fob_create_obj_resupply#0, _pos, [], 0, "CAN_COLLIDE"];
[_obj, _vectorDirAndUp, _resources, _isClaimed] call btc_log_fob_fnc_resupply_init;
btc_log_fob_supply_objects pushBack _obj;
publicVariable "btc_log_fob_supply_objects";

private _marker_flag = createVehicle ["FlagMarker_01_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_marker_flag attachTo [_obj, [0,0,1]];

_markers apply {
    _x params ["_pos", "_text"];
    private _marker = createMarkerLocal [format ["%1", _pos], _pos];
    _marker setMarkerTypeLocal "hd_unknown";
    _marker setMarkerTextLocal _text;
    _marker setMarkerSizeLocal [0.4, 0.4];
    _marker setMarkerAlphaLocal 0.35;
    _marker setMarkerColor "ColorPink";
};

[_obj] remoteExecCall ["btc_log_fob_fnc_resupplyActions", [0, -2] select isDedicated, _obj];

_obj