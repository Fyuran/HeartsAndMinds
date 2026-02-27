#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_server

Description:
    Add event handler to server.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_server;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

addMissionEventHandler ["BuildingChanged", FUNC(eh,buildingChanged)];
["ace_explosives_defuse", FUNC(rep,explosives_defuse)] call CBA_fnc_addEventHandler;
["ace_killed", FUNC(rep,killed)] call CBA_fnc_addEventHandler;
["Animal", "InitPost", {
    [_this select 0, "HandleDamage", FUNC(rep,hd)] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addClassEventHandler;
["Animal", "killed", {
    params ["_unit", "_killer", "_instigator"];
    [_unit, "", _killer, _instigator] call FUNC(rep,killed);
}] call CBA_fnc_addClassEventHandler;
{
    [_x, "InitPost", {
        [_this select 0, "Suppressed", FUNC(rep,suppressed)] call CBA_fnc_addBISEventHandler;
        [_this select 0, "HandleDamage", FUNC(rep,hd)] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_units;
{
    [_x, "InitPost", {
        [_this select 0, "HandleDamage", FUNC(rep,hd)] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_veh;
["ace_killed", FUNC(mil,unit_killed)] call CBA_fnc_addEventHandler;
["ace_repair_setWheelHitPointDamage", FUNC(rep,wheelChange)] call CBA_fnc_addEventHandler;
["ace_disarming_dropItems", FUNC(rep,foodRemoved)] call CBA_fnc_addEventHandler;
["btc_respawn_player", {
    params ["", "_player"];
    [_player, _PLAYER_RESPAWNED_] call FUNC(rep,change);
}] call CBA_fnc_addEventHandler;

["ace_explosives_detonate", {
    params ["_player", "_explosive", "_delay"];
    [
        FUNC(door,broke),
        ([3, _explosive, 0.5] call FUNC(door,get)) + [_player, 1, 2],
        _delay
    ] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;

addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "_id", "_uid", "_name"];
    if(_unit in entities "HeadlessClient_F") exitWith {};
    [_uid, _unit] call FUNC(slot,saveData); false
}];

if (btc_p_auto_db) then {
    addMissionEventHandler ["HandleDisconnect", {
        if ((allPlayers - entities "HeadlessClient_F") isEqualTo []) then {
            switch (btc_db_load) do {
	            case 1: {[] call FUNC(db,save)};
                default {};
	        };
        };
    }];
};
if (btc_p_chem) then {
    ["ace_cargoLoaded", FUNC(chem,propagate)] call CBA_fnc_addEventHandler;
    ["AllVehicles", "GetIn", {[_this select 0, _this select 2] call FUNC(chem,propagate)}] call CBA_fnc_addClassEventHandler;
    ["DeconShower_01_F", "init", {
        btc_chem_decontaminate pushBack (_this select 0);
        (_this select 0) setVariable ['bin_deconshower_disableAction', true];
    }, true, [], true] call CBA_fnc_addClassEventHandler;
    ["DeconShower_02_F", "init", {
        btc_chem_decontaminate pushBack (_this select 0);
        (_this select 0) setVariable ['bin_deconshower_disableAction', true];
    }, true, [], true] call CBA_fnc_addClassEventHandler;
};

["GroundWeaponHolder", "InitPost", {btc_groundWeaponHolder append _this}] call CBA_fnc_addClassEventHandler;
["acex_fortify_objectPlaced", {[_this select 2] call FUNC(log,init)}] call CBA_fnc_addEventHandler;
if (btc_p_set_skill) then {
    ["CAManBase", "InitPost", FUNC(mil,set_skill)] call CBA_fnc_addClassEventHandler;
};
["btc_delay_vehicleInit", FUNC(patrol,addEH)] call CBA_fnc_addEventHandler;
["ace_killed", {
    params ["_unit"];
    if (side group _unit isNotEqualTo civilian) exitWith {};
    private _vehicle = assignedVehicle _unit;
    if (_vehicle isNotEqualTo objNull) then {
        [[], [_vehicle]] call FUNC(common,delete);
    };
}] call CBA_fnc_addEventHandler;
{
    [_x, "InitPost", {
        [_this select 0, "HandleDamage", FUNC(patrol,disabled)] call CBA_fnc_addBISEventHandler;
    }, false] call CBA_fnc_addClassEventHandler;
} forEach btc_civ_type_veh;
["ace_tagCreated", FUNC(tag,eh)] call CBA_fnc_addEventHandler; 

if (btc_p_respawn_ticketsAtStart >= 0) then {
    ["ace_placedInBodyBag", FUNC(body,setBodyBag)] call CBA_fnc_addEventHandler;

    if !(btc_p_respawn_ticketsShare) then {
        ["btc_playerConnected", FUNC(respawn,playerConnected)] call CBA_fnc_addEventHandler;
    };

    addMissionEventHandler ["HandleDisconnect", {
        params ["_unit"];
        if (
            ace_respawn_removedeadbodiesdisconnected &&
            {_unit in btc_body_deadPlayers}
        ) then {
            deleteMarker (_unit getVariable ["btc_body_deadMarker", ""]);
            private _deadUnits  = [[[_unit]] call FUNC(body,get)] call FUNC(body,create);
            private _deadUnit = _deadUnits select 0;
            btc_body_deadPlayers pushBack _deadUnit;
        };
    }];
};

//Cargo
[btc_fob_mat, "InitPost", {
    params ["_obj"];
    [_obj, -1] call ace_cargo_fnc_setSpace;
}, true, [], true] call CBA_fnc_addClassEventHandler;
{
    [_x, "InitPost", {
        params ["_obj"];
        [_obj, 50] call ace_cargo_fnc_setSpace;
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} forEach ["CUP_MTVR_Base", "Truck_01_base_F"];

["ace_explosives_place", {
    params ["_explosive", "_dir", "_pitch", "_unit"];
    _explosive setVariable ["btc_side", side group _unit];
    btc_explosives pushBack _this;
}] call CBA_fnc_addEventHandler; 

//for FOB Log objs attachedObjects
["ace_cargoUnloaded", {
    params["_obj"];
    
    if(_obj in btc_log_fob_supply_objects) then {
        _marker_flag = createVehicle ["FlagMarker_01_F", [0,0,0], [], 0, "CAN_COLLIDE"];
        _marker_flag attachTo [_obj, [0,0,1]];
    };
}] call CBA_fnc_addEventHandler;

//Sunrise or Sunset
[abs btc_p_eh_sunriseorsunset] call FUNC(eh,setSunriseOrSunset);

["btc_log_place_pickedUp", {
    params ["_target", "_unit"];
    
    #ifdef BTC_DEBUG_EH
    [["%1: %2 picked up a %3", __FILE_NAME__, name _unit, typeOf _target], 2, "eh"] call FUNC(debug,message);
    #endif
    _target setVariable ["btc_log_isBeingPlaced", true, true];
}] call CBA_fnc_addEventHandler;

["btc_log_place_placedDown", {
    params ["_target", "_unit"];

    #ifdef BTC_DEBUG_EH
    [["%1: %2 placed down a %3", __FILE_NAME__, name _unit, typeOf _target], 2, "eh"] call FUNC(debug,message);
    #endif
    _target setVariable ["btc_log_isBeingPlaced", false, true];
}] call CBA_fnc_addEventHandler;