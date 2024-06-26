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
    [] spawn btc_respawn_fnc_intro;
} else {
    btc_intro_done = true;
};

[] call btc_int_fnc_shortcuts;
[] call btc_lift_fnc_shortcuts;

[{!isNull player}, {
    [] call compileScript ["core\doc.sqf"];

    btc_respawn_marker setMarkerPosLocal player;
    player addRating 9999;
    ["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

    [player] call btc_eh_fnc_player;

    _arsenal_trait = player call btc_arsenal_fnc_trait;
    if (btc_p_arsenal_Restrict isEqualTo 3) then {
        [_arsenal_trait select 1] call btc_arsenal_fnc_weaponsFilter;
    };
    switch (btc_p_autoloadout) do {
        case 1: {
            player setUnitLoadout ([_arsenal_trait select 0] call btc_arsenal_fnc_loadout);
        };
        case 2: {
            (weapons player) apply {          
                player removeWeapon _x;
            };
        };
        default {};
    };
    [] call btc_int_fnc_add_actions;

    if (player getVariable ["interpreter", false]) then {
        player createDiarySubject ["btc_diarylog", localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG", '\A3\ui_f\data\igui\cfg\simpleTasks\types\talk_ca.paa'];
    };

    [] call btc_respawn_fnc_screen;

    if(btc_debug) then {
        [] call btc_debug_fnc_debug_mode;
    };

    [] spawn btc_log_fnc_drawResources3D;
    
    if(btc_db_load>0 && {isMultiplayer}) then {
        [] call btc_slot_fnc_loadPlayer;
    };
}] call CBA_fnc_waitUntilAndExecute;
