
/* ----------------------------------------------------------------------------
Function: btc_db_fnc_initDefault

Description:
    DB defaults.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_db_fnc_initDefault;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

if (btc_debug) then {
	[format["Database loading falling through to defaults"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

if (btc_hideout_n > 0) then {
	for "_i" from 1 to btc_hideout_n do {
		[] call btc_hideout_fnc_create;
	};
} else {
	[] spawn btc_fnc_final_phase;
};

[] call btc_cache_fnc_init;

btc_startDate set [3, btc_p_time];
setDate btc_startDate;

(getMissionLayerEntities "btc_vehicles" select 0) apply {
	_x call btc_veh_fnc_add;
};
if (isNil "btc_vehicles") then {
	btc_vehicles = [];
};

//fob supplies
(values btc_city_all) apply {
	private _has_en = _x getVariable ["occupied", false];
	if(!_has_en) then { continue };

	private _type = _x getVariable ["type", ""];
	private _cachingRadius = _x getVariable ["cachingRadius", 100];
	
	private _supplyChance = (switch _type do {
		case "Hill" : {0.2};
		case "VegetationFir" : {0};
		case "BorderCrossing" : {0};
		case "NameLocal" : {0.3};
		case "StrongpointArea" : {0.4};
		case "NameVillage" : {0.3};
		case "NameCity" : {0.4};
		case "NameCityCapital" : {1};
		case "Airport" : {0.3};
		case "NameMarine" : {0};
		default {0};
	});
	if(_supplyChance > (random 1)) then {
		private _supply_pos = [getPosATL _x, _cachingRadius, false, true] call btc_fnc_randomize_pos;
		if(_supply_pos isNotEqualTo []) then {
			private _supply_obj = [objNull, _supply_pos] call btc_log_fob_fnc_resupply_packed;
		};
	};
};