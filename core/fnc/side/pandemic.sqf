#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_side_fnc_pandemic

Description:
    Decontaminate civilian with a little shower. To locate civilian go to the subtask, follow red blood drop and use your chemical detector.

Parameters:
    _taskID - Unique task ID. [String]
    _selectedPos - Position acquired from side missions menu available to admin only [Array]
    
Returns:

Examples:
    (begin example)
        [false, "pandemic"] spawn btc_side_fnc_create;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_taskID", "btc_side", [""]],
	["_selectedPos", [0, 0, 0], [[]], 3]
];

//// Choose a City\\\\
private _minNumberOfSubTask = 2;
private _usefuls = if (_selectedPos isEqualTo [0,0,0]) then {
	values btc_city_all select {
        !(_x getVariable ["type", ""] in ["NameMarine", "StrongpointArea"]) &&
        {!(_x getVariable ["active", false])} &&
        {
            private _city = _x;
            ({
                (_x select 0) isEqualTo 6 &&
                {(_x select 3) isEqualTo civilian}
            } count (_city getVariable ["data_units", []])) >= _minNumberOfSubTask
        }
	};
} else {
	private _temp = values btc_city_all select {(_x distance2D _selectedPos) <= _S_RADIUS 
    && {!(_x getVariable ["active", false])}
    &&  {
            private _city = _x;
            ({
                (_x select 0) isEqualTo 6 &&
                {(_x select 3) isEqualTo civilian}
            } count (_city getVariable ["data_units", []])) >= _minNumberOfSubTask
        }
    };
	[_temp, [_selectedPos], {_x distance2D _input0}] call BIS_fnc_sortBy;
};
if (_usefuls isEqualTo []) exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no _usefuls", __FILE_NAME__, _taskID], 2, "side"] call FUNC(debug,message);
	#endif
	[] call FUNC(side,create);
};

private _city = if (_selectedPos isEqualTo [0,0,0]) then {
	selectRandom _usefuls;
} else {
	_usefuls#0;
};
if(isNil "_city") exitWith {
    #ifdef BTC_DEBUG_SIDE
	[["%1: %2 found no valid _city", __FILE_NAME__, _taskID], 2, "side"] call FUNC(debug,message);
	#endif
	[] call FUNC(side,create);
};

private _dataCivilian = (_city getVariable ["data_units", []]) select {
    (_x select 0) isEqualTo 6 &&
    {(_x select 3) isEqualTo civilian}
};
private _extraCiv = round random (((count _dataCivilian) - _minNumberOfSubTask) min 2);

[_taskID, 40, objNull, _city getVariable "name"] call FUNC(task,create);
btc_side_taskIDs set ["pandemic", (btc_side_taskIDs getOrDefault ["pandemic", [], true]) + [[_taskID, _city getVariable ["name", "Unknown Location"]]]];
publicVariable "btc_side_taskIDs";
#ifdef BTC_DEBUG_SIDE
[["%1: %2 at %3", __FILE_NAME__, _taskID, getPos _city], 2, "side"] call FUNC(debug,message);
#endif

private _tasksID = [];
for "_i" from 0 to (_minNumberOfSubTask + _extraCiv - 1) do {
    private _deconta_taskID = _taskID + "dc" + str _i;
    _tasksID pushBack _deconta_taskID;

    private _selectedCiv = _dataCivilian select _i;
    [[_deconta_taskID, _taskID], 41, _selectedCiv select 1 select 0, _selectedCiv select 2 select 0, false, false] call FUNC(task,create);
 
    [{
        params ["_city", "_civPos", "_civType"];
        _city getVariable ["active", false] && 
        {nearestObjects [_civPos, [_civType], 10] isNotEqualTo []}
    }, {
        params ["_city", "_civPos", "_civType", "_deconta_taskID"];
        private _civ = (nearestObjects [_civPos, [_civType], 10]) select 0;
        (group _civ) setVariable ["acex_headless_blacklist", true];
        btc_chem_contaminated pushBack _civ;
        publicVariable "btc_chem_contaminated";

        [{
            params ["_civ", "_deconta_taskID"];
            !alive _civ ||
            !(_civ in btc_chem_contaminated)
        }, {
            params ["_civ", "_deconta_taskID"];
            if (_deconta_taskID call BIS_fnc_taskCompleted) exitWith {};
            if (!alive _civ) exitWith {
                [_deconta_taskID, "FAILED"] call BIS_fnc_taskSetState;
            };
            [_deconta_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
        }, [_civ, _deconta_taskID]] call CBA_fnc_waitUntilAndExecute;
    }, [_city, _selectedCiv select 1 select 0, _selectedCiv select 2 select 0, _deconta_taskID]] call CBA_fnc_waitUntilAndExecute;
};

waitUntil {sleep 5;
    _taskID call BIS_fnc_taskCompleted ||
    !(false in (_tasksID apply {_x call BIS_fnc_taskCompleted}))
};

if (_taskID call BIS_fnc_taskState isEqualTo "CANCELED") exitWith {};
if !("SUCCEEDED" in (_tasksID apply {_x call BIS_fnc_taskState})) exitWith {
    [_taskID, "FAILED"] call BIS_fnc_taskSetState;
};

{
    if (_x call BIS_fnc_taskState isEqualTo "SUCCEEDED") then {
        [objNull, _SIDE_CIV_DECONTAMINATED_] call FUNC(rep,change);
    };
} forEach _tasksID;

[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
