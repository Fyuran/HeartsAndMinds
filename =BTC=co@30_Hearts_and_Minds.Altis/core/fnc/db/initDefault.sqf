
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

{
	_x call btc_veh_fnc_add;
} forEach (getMissionLayerEntities "btc_vehicles" select 0);
if (isNil "btc_vehicles") then {
	btc_vehicles = [];
};