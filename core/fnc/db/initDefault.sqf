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
[["%1: No save found, initializing to defaults", __FILE_NAME__], 3, "db"] call FUNC(debug,message);
#endif
if (btc_hideout_n > 0) then {
	for "_i" from 1 to btc_hideout_n do {
		[] call FUNC(hideout,create);
	};
} else {
	[] spawn FUNC(common,final_phase);
};

[] call FUNC(cache,init);

btc_startDate set [3, btc_p_time];
setDate btc_startDate;

(getMissionLayerEntities "btc_vehicles" select 0) apply {
	_x call FUNC(veh,add);
};
if (isNil "btc_vehicles") then {
	btc_vehicles = [];
};