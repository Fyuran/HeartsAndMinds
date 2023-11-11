[] call compileScript ["core\fnc\city\init.sqf"];

switch (btc_db_load) do {
	case 1: {
		if (profileNamespace getVariable [format ["btc_hm_%1_db", btc_db_saveName], false]) then {
			if ((profileNamespace getVariable [format ["btc_hm_%1_version", btc_db_saveName], 1.13]) in [btc_version select 1, 22.1]) then {
				[] call compileScript ["core\fnc\db\load.sqf"];
			} else {
				[] call compileScript ["core\fnc\db\load_old.sqf"];
			};
		} else {
			[] call btc_db_fnc_initDefault;
		};
	};
	case 2: {
		("btc_ArmaToJSON" callExtension ["dataExists", [format["btc_hm_%1.JSON", btc_db_saveName]]]) params ["_result", "_returnCode"];
		if (_returnCode isEqualTo 200) then {
			[] call btc_json_fnc_load;
		} else {
			[] call btc_db_fnc_initDefault;
		};
	};
	default {
		[] call btc_db_fnc_initDefault;
	};
};

["Initialize"] call BIS_fnc_dynamicGroups;
setTimeMultiplier btc_p_acctime;

["btc_m", -1, objNull, "", false, false] call btc_task_fnc_create;
[["btc_dft", "btc_m"], 0] call btc_task_fnc_create;
[["btc_dty", "btc_m"], 1] call btc_task_fnc_create;

[] call btc_eh_fnc_server;
[btc_ied_list] call btc_ied_fnc_fired_near;
[] call btc_chem_fnc_checkLoop;
[] call btc_chem_fnc_handleShower;
[] call btc_spect_fnc_checkLoop;
[] call btc_db_fnc_autoRestartLoop;

{
	[_x, 30] call btc_veh_fnc_addRespawn;
	if (_forEachIndex isEqualTo 0) then {
		missionNamespace setVariable ["btc_veh_respawnable_1", _x, true];
	};
} forEach (getMissionLayerEntities "btc_veh_respawnable" select 0);
if (isNil "btc_veh_respawnable") then {
	btc_veh_respawnable = [];
};

if (btc_p_side_mission_cycle > 0) then {
	for "_i" from 1 to btc_p_side_mission_cycle do {
		[true] spawn btc_side_fnc_create;
	};
};

{
	["btc_tag_remover" + _x, "STR_BTC_HAM_ACTION_REMOVETAG", _x, ["#(rgb, 8, 8, 3)color(0, 0, 0, 0)"], "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa"] call ace_tagging_fnc_addCustomTag;
} forEach ["ACE_SpraypaintRed"];

if (
btc_p_respawn_ticketsShare &&
{
	btc_p_respawn_ticketsAtStart >= 0
}
) then {
	private _tickets = btc_respawn_tickets getOrDefault [btc_player_side, btc_p_respawn_ticketsAtStart];
	if (_tickets isEqualTo 0) then {
		_tickets = -1;
	};
	[btc_player_side, _tickets] call BIS_fnc_respawnTickets;
};