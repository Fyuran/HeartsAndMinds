#include "..\script_macros.hpp"
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

#ifdef BTC_DEBUG_DB
[["%1: No save found, initializing to defaults", __FILE_NAME__], 3, "db"] call btc_debug_fnc_message;
#endif
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