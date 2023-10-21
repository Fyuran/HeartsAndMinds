
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_get_group

Description:
    Get less groups parameters for JSON load, save them and delete.

Parameters:
    _group - Group of units. [Group]

Returns:

Examples:
    (begin example)
        _result = [] call btc_json_fnc_get_group;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */
//0:unit? VEH:1, 2:??? inHOUSE groups:3, CIVgetWeapons:4, suicider:5, CIV:6, drone:7
params [
    ["_group", grpNull, [grpNull]]
];

private _units = (units _group) select {alive _x};
if (_units isEqualTo []) exitWith {nil};
private _leader = leader _group;
private _vehicle = vehicle _leader;

private _type_db = "UNITS";

private _array_pos = [];
private _pos = getPosATL leader _x;
if (surfaceIsWater _pos) then {
    _array_pos = getPos leader _x;
} else {
    _array_pos = _pos;
};

private _array_type = [];
private _side = side _group;
private _array_veh = [];

{
    _array_type pushBack typeOf _x;
} forEach _units;

if (_group getVariable ["btc_inHouse", ""] isNotEqualTo "") then {
    _type_db = "HOUSE";
    _array_veh = _group getVariable ["btc_inHouse", ""];
};
if (_group getVariable ["getWeapons", false]) then {_type_db = "CIV_GETWEAPONS";};
if (_group getVariable ["suicider", false]) then {_type_db = "SUICIDER";};
if (_group getVariable ["btc_data_inhouse", []] isNotEqualTo []) then {
    _type_db = "CIVILIANS";
    _array_veh = _group getVariable ["btc_data_inhouse", []];
};
if (_group getVariable ["btc_ied_drone", false]) then {_type_db = "DRONE";};
if (
    _vehicle != _leader &&
    {_type_db isNotEqualTo "DRONE"}
) then {
    _type_db = "VEHICLE";
    _array_veh = [typeOf _vehicle, getPosATL _vehicle];
};

["type_db", "side", "pos", "array_type", "array_veh"]createHashMapFromArray[_type_db, _side, _array_pos, _array_type, _array_veh];