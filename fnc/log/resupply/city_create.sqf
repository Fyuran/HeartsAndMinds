
/* ----------------------------------------------------------------------------
Function: btc_log_resupply_fnc_city_create

Description:
    Manages packed up logistic object in addition also manages unpack->packed state flow

Parameters:

Returns:

Examples:
    (begin example)
        _result = [objNull, getPos player] call btc_log_resupply_fnc_city_create
        ;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_city", objNull, [objNull]],
    ["_data", [], [[]]]
];

_data params [
    ["_pos", [0,0,0], [[]], 3],
    ["_dir", 0, [0]],
    ["_resources", -1, [0]],
    ["_markers", [], [[]]]
];

if(isNull _city) exitWith {
    ["_city is null", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _obj = createVehicle [btc_log_fob_create_obj_resupply#0, _pos, [], 0, "CAN_COLLIDE"];
_obj setVariable ["btc_city", _city];
_obj setVariable ["btc_resupply_data", _data];
_obj setVariable ["btc_log_resources", _resources];
_obj setVariable ["btc_info_markers", _markers];

_obj setVectorUp (surfaceNormal _pos);
_obj setDir _dir;
[_obj, 2] call ace_cargo_fnc_setSize; //-1 to disable Load in Cargo
[_obj, 0] call ace_cargo_fnc_setSpace;

private _marker_flag = createVehicle ["FlagMarker_01_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_marker_flag attachTo [_obj, [0,0,1]];

_markers apply {
    private _marker = createMarkerLocal[_x#0, _x#1];
    if(_marker isNotEqualTo "") then {
        _marker setMarkerTypeLocal "hd_unknown";
        _marker setMarkerTextLocal format ["%1m", btc_info_supply_radius];
        _marker setMarkerSizeLocal[0.4, 0.4];
        _marker setMarkerAlphaLocal 0.35;
        _marker setMarkerColor "ColorPink";
    };
};


[_obj, {

    //claim
    private _action_place = ["btc_log_claim", localize "STR_BTC_HAM_ACTION_LOG_OBJ_RESUPPLY_CLAIM", "a3\ui_f\data\igui\cfg\actions\takeflag_ca.paa", {
        params["", "", "_actionParams"];
        [_target, _player] remoteExecCall ["btc_log_resupply_fnc_claim", [0, 2] select isMultiplayer];
    }, {
        !btc_log_placing && !(player getVariable ["ace_dragging_isCarrying", false])
    }, {}, [], [0,0,0], 5] call ace_interact_menu_fnc_createAction;
    [_this, 0, ["ACE_MainActions"], _action_place] call ace_interact_menu_fnc_addActionToObject;

}] remoteExecCall ["call", [0, -2] select isDedicated, _obj];

if(btc_debug) then {
    [format["created UNCLAIMED supply at %1[%2]", _city getVariable["id", -1], _pos], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;  
};

_obj