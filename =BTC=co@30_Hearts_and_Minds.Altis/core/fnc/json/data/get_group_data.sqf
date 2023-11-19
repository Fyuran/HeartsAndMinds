/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_get_group_data
	
	Description:
	    get less groups parameters for JSON load, save them and delete.
	
	Parameters:
	    _group - group of units. [group]
	
	Returns:
	
	Examples:
	    (begin example)
	        _result = [] call btc_json_fnc_get_group_data;
	    (end)
	
	Author:
	    Giallustio, Fyuran
	
---------------------------------------------------------------------------- */
// 0:unit? VEH:1, 2:??? inHOUSE groups:3, CIVgetWeapons:4, suicider:5, CIV:6, drone:7
params [
	["_group", grpNull, [grpNull]]
];

private _units = (units _group) select {
	alive _x
};
if (_units isEqualTo []) exitWith {
	nil
};
private _leader = leader _group;
private _vehicle = vehicle _leader;



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
private _wp_type = _group getVariable ["wp_type", "PATROL"];

{
	_array_type pushBack typeOf _x;
} forEach _units;

private _type_db = switch(true) do {

	case(_leader getVariable ["ace_captives_isSurrendering", false]): {"SURRENDERED"};

	case(_group getVariable ["btc_inHouse", ""] isNotEqualTo ""): {_array_veh = _group getVariable ["btc_inHouse", ""]; "HOUSE"};

	case(_group getVariable ["getWeapons", false]): {"CIV_GETWEAPONS"};

	case(_group getVariable ["suicider", false]): {"SUICIDER"};

	case(_group getVariable ["btc_data_inhouse", []] isNotEqualTo []): {_array_veh = _group getVariable ["btc_data_inhouse", []]; "CIVILIANS"};

	case(_group getVariable ["btc_ied_drone", false]): {"DRONE"};

	case(_vehicle != _leader && {_type_db isNotEqualTo "DRONE"}): {_array_veh = [typeOf _vehicle, getPosATL _vehicle]; "VEHICLE"};

	default {"UNITS"};
};

[_vehicle, _group] call CBA_fnc_deleteEntity;

["type_db", "side", "pos", "wp_type", "array_type", "array_veh"]createHashMapFromArray[_type_db, _side, _array_pos, _wp_type, _array_type, _array_veh];