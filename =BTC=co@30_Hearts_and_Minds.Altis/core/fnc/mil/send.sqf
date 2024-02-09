
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_send

Description:
    Send a group of units to a location then call btc_data_fnc_add_group. If player is around, 
    initiate patrol around the destination, if not save in database and delete units unless it's a FOB type patrol.

Parameters:
    _start - Starting point. [Object]
    _dest - Destination. [Array, Object]
    _typeOf_patrol - Infantry or motorized. [Number]
    _veh_type - Vehicle type for motorized. [String]
    _infFormation - Define the infantry formation. [String]

Returns:
    _group - Created group. [Group]

Examples:
    (begin example)
        [allPlayers#0, getPos (allPlayers#0), 1, selectRandom btc_type_motorized] call btc_mil_fnc_send
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#define FOB_ATTACK_PATROL_TYPE 2

params [
    ["_start", objNull, [objNull]],
    ["_dest", [0, 0, 0], [[], objNull]],
    ["_typeOf_patrol", 0, [0]],
    ["_veh_type", "", [""]],
    ["_infFormation", "COLUMN", [""]]
];

private _pos = getPos _start;

private _group = grpNull;
private _delay = 0;
switch (_typeOf_patrol) do {
    case 0 : {
        _group = ([_pos, 150, 3 + round random 6, "PATROL"] call btc_mil_fnc_create_group) select 0;
    };
    case 1 : {
        _group = createGroup btc_enemy_side;

        if (_veh_type isEqualTo "") then {_veh_type = selectRandom btc_type_motorized};
        private _return_pos = [_pos, 10, 500, 13, false] call btc_fnc_findsafepos;

        _delay = [_group, _return_pos, _veh_type] call btc_mil_fnc_createVehicle;
    };
    case FOB_ATTACK_PATROL_TYPE : {
        _group = createGroup btc_enemy_side;

        private _return_pos = [_pos, 10, 500, 13, false] call btc_fnc_findsafepos;

        _delay = [_group, _return_pos, selectRandom (btc_type_motorized_transport + btc_type_motorized_armed_ground)] call btc_mil_fnc_createVehicle;
        //btc_type_motorized_armed_ground, still not sure if it should be a troop only attack
    };
};
_group setVariable ["no_cache", true];
_group setVariable ["acex_headless_blacklist", true];

[{
    params ["_group", "_typeOf_patrol", "_dest", "_infFormation"];

    [_group] call CBA_fnc_clearWaypoints;
    switch (_typeOf_patrol) do {
        case 0 : {
            [_group, _dest, -1, "MOVE", "AWARE", "RED", "FULL", _infFormation, "(group this) call btc_data_fnc_add_group;", nil, 60] call CBA_fnc_addWaypoint;
        };
        case 1 : {
            [_group, _dest, -1, "MOVE", "AWARE", "RED", "NORMAL", "NO CHANGE", "(group this) call btc_data_fnc_add_group;", nil, 60] call CBA_fnc_addWaypoint;
        };
        case FOB_ATTACK_PATROL_TYPE : {
            [_group, _dest, -1, "MOVE", "SAFE", "WHITE", "LIMITED", "NO CHANGE", "[group this, [this, btc_fobs select 1, false] call btc_fnc_find_closecity, 100, ""FOB""] call btc_mil_fnc_addWP;", nil, 300] call CBA_fnc_addWaypoint;
    };

    };

    _group setVariable ["acex_headless_blacklist", false];
    _group deleteGroupWhenEmpty true;
}, [_group, _typeOf_patrol, _dest, _infFormation], _delay] call btc_delay_fnc_waitAndExecute;

_group
