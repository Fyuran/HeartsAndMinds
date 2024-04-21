
/* ----------------------------------------------------------------------------
Function: btc_patrol_fnc_addWP

Description:
    Add waypoint to the end city.

Parameters:
    _group - Group to add waypoint. [Group]
    _pos - Position of the end city. [Array]
    _waypointStatements - Code to execute on waypoint completion. [String]

Returns:

Examples:
    (begin example)
        [group cursorTarget, getPos player, "[group this, 1000, [0, 0, 0], [0, 1, 2], false] call btc_patrol_fnc_WPCheck;"] call btc_patrol_fnc_addWP;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_group", grpNull, [grpNull]],
    ["_pos", [0, 0, 0], [[]]],
    ["_waypointStatements", "", [""]],
    ["_isBoat", false, [false]]
];

if (isNull _group) exitWith {
    if(btc_debug) then {
        [format ["_group isNull %1, waypointStatements = %2 ", isNull _group, _waypointStatements], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
    };
};

private _vehicle = vehicle leader _group;
if (_vehicle isKindOf "Air" || _vehicle isKindOf "LandVehicle") then {
    _vehicle setFuel 1;
};

[_group] call CBA_fnc_clearWaypoints;
private _behaviorMode = "SAFE";
private _combatMode = "RED";
if (side _group isEqualTo civilian) then {
    _behaviorMode = "CARELESS";
    _combatMode = "BLUE";
};

private _startPos = getposASL leader _group;
if (_vehicle isKindOf "Air") then {
    [_group, _pos, -1, "MOVE", _behaviorMode, _combatMode, "LIMITED", "STAG COLUMN", _waypointStatements, [0, 0, 0], 20] call CBA_fnc_addWaypoint;
} else {
    if(!(side _group isEqualTo civilian) && {!(_isBoat)}) then {
        //divide a line from origin to destination in 4 parts only for military patrols for FOB range checking
        for "_i" from 0 to 1 step 0.2 do {
            private _vec = (_startPos vectorAdd ((_pos vectorDiff _startPos) vectorMultiply _i));
            _vec set [2, 0]; //make sure WPs are set at ground level, soldiers can't fly
            private _nearestRoad = [_vec, 300] call BIS_fnc_nearestRoad;
            if (!(isNull _nearestRoad)) then {
                _vec = getPos _nearestRoad;
            };
            [_group, _vec, -1, "MOVE", _behaviorMode, _combatMode, "LIMITED", "STAG COLUMN", format["[group this, %1] call btc_patrol_fnc_WPFOBCheck", _isBoat], [0, 0, 0], 50] call CBA_fnc_addWaypoint;

            if (btc_debug) then {
                private _patrol_id = _group getVariable ["btc_patrol_id", 0];
                private _marker = createMarkerLocal [format ["Patrol_fant_%1_%2", _patrol_id, _i], _vec];
                _marker setMarkerTypeLocal "mil_dot";
                _marker setMarkerTextLocal format ["FOB?:%1/%2", _patrol_id, _i];
                _marker setMarkerColorLocal "ColorGrey";
                _marker setMarkerSizeLocal [0.2, 0.2];
                _marker setMarkerAlpha 0.5;
            };
        };
    };

    private _roadBlackList = [];
    for "_i" from 0 to (2 + (floor random 3)) do {
        private _nearestRoad = [_pos getPos [100, random 360], 100, _roadBlackList] call BIS_fnc_nearestRoad;
        private _newPos = [];
        if (isNull _nearestRoad) then {
            _newPos = [_pos, 150] call CBA_fnc_randPos;
        } else {
            _roadBlackList pushBackUnique _nearestRoad;
            _newPos = _nearestRoad;
        };
        [_group, _newPos, -1, "MOVE", "UNCHANGED", "RED", "UNCHANGED", "NO CHANGE", "", [0, 0, 0], 20] call CBA_fnc_addWaypoint;
    };
    [_group, _pos, -1, "MOVE", "UNCHANGED", "NO CHANGE", "UNCHANGED", "NO CHANGE", _waypointStatements, [0, 0, 0], 50] call CBA_fnc_addWaypoint;
};

if (btc_debug) then {
    if (!isNil {_group getVariable "btc_patrol_id"}) then {
        private _patrol_id = _group getVariable ["btc_patrol_id", 0];
        private _marker_color = (["ColorWhite", "ColorRed"] select (_patrol_id > 0));

        private _marker = createMarkerLocal [format ["Patrol_fant_begin_%1", _patrol_id], [(_startPos select 0) + random 30, (_startPos select 1) + random 30, 0]];
        _marker setMarkerTypeLocal "mil_dot";
        _marker setMarkerTextLocal format ["P:%1 START", _patrol_id];
        _marker setMarkerColorLocal _marker_color;
        _marker setMarkerSize [0.5, 0.5];

        _marker = createMarkerLocal [format ["Patrol_fant_end_%1", _patrol_id], [(_pos select 0) + random 30, (_pos select 1) + random 30, 0]];
        _marker setMarkerTypeLocal "mil_dot";
        _marker setMarkerTextLocal format ["P:%1 END", _patrol_id];
        _marker setMarkerColorLocal _marker_color;
        _marker setMarkerSize [0.5, 0.5];

        if(!(side _group isEqualTo civilian)) then {
            btc_patrols_pos set [_patrol_id,[_startPos, _pos]];
            publicVariable "btc_patrols_pos";
        };

    };
};
