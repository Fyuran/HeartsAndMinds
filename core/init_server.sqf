#include "fnc\script_macros.hpp"
#define _OK_ 0

[] call compileScript ["core\fnc\city\init.sqf"];

["Initialize", [true]] call BIS_fnc_dynamicGroups;
switch (btc_db_load) do {
	case 1: {
		private _saveFile = profileNamespace getVariable [format["btc_hm_%1_saveFile", worldName], ""];
		("btc_ArmaToJSON" callExtension ["dataExists", [_saveFile]]) params [["_result", -1], ["_returnCode", -1]];
		if (_returnCode isEqualTo _OK_) then {
			[] call FUNC(db,load);
		} else {
			#ifdef BTC_DEBUG_DEBUG
			[["%1: JSON load failed, result: %2, returnCode %3", __FILE_NAME__, [_result, -1] select {isNil "_result"}, _returnCode], 2] call FUNC(debug,message);
			#endif[] call FUNC(db,initDefault);
		};
	};
	default {
		[] call FUNC(db,initDefault);
	};
};
setTimeMultiplier btc_p_acctime;

["btc_m", -1, objNull, "", false, false] call FUNC(task,create);
[["btc_dft", "btc_m"], 0] call FUNC(task,create);
[["btc_dty", "btc_m"], 1] call FUNC(task,create);

[] call FUNC(eh,server);
[] call FUNC(log_dialog,init_tables);
[btc_ied_list] call FUNC(ied,fired_near);
[] call FUNC(chem,checkLoop);
[] call FUNC(chem,handleShower);
[] call FUNC(spect,checkLoop);
[] call FUNC(db,autoRestartLoop);

//Namespace to hold variables for debug
btc_debug_namespace = [true] call CBA_fnc_createNamespace;
publicVariable "btc_debug_namespace";

if(btc_p_debug_fps) then {
    ["Server", [0, -50], 200, 0] call FUNC(debug,show_fps);
};

{
    [_x, 30] call FUNC(veh,addRespawn);
    if (_forEachIndex isEqualTo 0) then {
        missionNamespace setVariable ["btc_veh_respawnable_1", _x, true];
    };
} forEach (getMissionLayerEntities "btc_veh_respawnable" select 0);
if (isNil "btc_veh_respawnable") then {btc_veh_respawnable = [];};

if (btc_p_side_mission_cycle > 0) then {
    for "_i" from 1 to btc_p_side_mission_cycle do {
        [true] spawn FUNC(side,create);
    };
};

{
    ["btc_tag_remover" + _x, "STR_BTC_HAM_ACTION_REMOVETAG", _x, ["#(rgb,8,8,3)color(0,0,0,0)"], "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa"] call ace_tagging_fnc_addCustomTag;
} forEach ["ACE_SpraypaintRed"];

if (
    btc_p_respawn_ticketsShare &&
    {btc_p_respawn_ticketsAtStart >= 0}
) then {
    private _tickets = btc_respawn_tickets getOrDefault [btc_player_side, btc_p_respawn_ticketsAtStart];
    if (_tickets isEqualTo 0) then {
        _tickets = -1;
    };
    [btc_player_side, _tickets] call BIS_fnc_respawnTickets;
};
