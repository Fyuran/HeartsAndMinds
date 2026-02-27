#include "fnc\script_macros.hpp"
btc_map_mapIllumination = ace_map_mapIllumination;
if !(isNil "btc_custom_loc") then {
    {
        _x params ["_pos", "_cityType", "_cityName", "_radius"];
        private _location = createLocation [_cityType, _pos, _radius, _radius];
        _location setText _cityName;
    } forEach btc_custom_loc;
};

btc_intro_done = false;
if(btc_p_intro) then {
    [] spawn FUNC(respawn,intro);
} else {
    btc_intro_done = true;
};

[] call FUNC(int,shortcuts);
[] call FUNC(lift,shortcuts);

[{!isNull player}, {
    [] call compileScript ["core\doc.sqf"];

    btc_respawn_marker setMarkerPosLocal player;
    player addRating 9999;
    ["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

    [player] call FUNC(eh,player);

    private _arsenal_trait = player call FUNC(arsenal,trait);
    if (btc_p_arsenal_Restrict isEqualTo 3) then {
        [_arsenal_trait select 1] call FUNC(arsenal,weaponsFilter);
    };
    switch (btc_p_autoloadout) do {
        case 1: {
            player setUnitLoadout ([_arsenal_trait select 0] call FUNC(arsenal,loadout));
        };
        case 2: {
            (weapons player) apply {          
                player removeWeapon _x;
            };
        };
        default {};
    };
    [] call FUNC(int,add_actions);

    if (player getVariable ["interpreter", false]) then {
        player createDiarySubject ["btc_diarylog", localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG", '\A3\ui_f\data\igui\cfg\simpleTasks\types\talk_ca.paa'];
    };

    [] call FUNC(respawn,screen);

    if(btc_debug) then {
        [] call FUNC(debug,debug_mode);
    };
    [] spawn FUNC(log,drawResources3D);
    
    if(btc_db_load > 0) then {
        ["btc_slot_loadPlayer", {_this call FUNC(slot,loadPlayer)}] call CBA_fnc_addEventHandler;
        [getPlayerUID player] remoteExec ["btc_slot_fnc_getData", 2];
    };
}] call CBA_fnc_waitUntilAndExecute;
