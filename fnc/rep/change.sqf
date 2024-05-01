
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_change

Description:
    Change reputation level. Only significant reputation changes will show a feedback(if enabled)

Parameters:
    _rep_amount - Number to add or substrat to the reputation level. [Number]
    _instigator - Player triggered the reputation change. [Number]
    _reason - Why has this reputation change occured. [Number]

Returns:

Examples:
    (begin example)
        [player, _FOOD_GIVEN_] call btc_rep_fnc_change;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_instigator", objNull, [objNull, 0, ""]],
    ["_reason", -1, [0]],
    ["_showNotification", true, [true]]
];

private _name = "PLACEHOLDER";
if(_instigator isEqualType objNull) then {
    _name = name _instigator;
};
if(_instigator isEqualType "") then {
    _name = _instigator;
};

private _change = switch (_reason) do {
    //BASIC
    case _CACHE_DESTROYED_ : { [btc_rep_bonus_cache, format[localize"STR_BTC_HAM_REP_CACHE_DESTROYED", _name]] };
    case _DOOR_FORCED_ : { [btc_rep_malus_breakDoor, format[localize"STR_BTC_HAM_REP_DOOR_FORCED", _name]] };
    case _PLAYER_RESPAWNED_ : { [btc_rep_malus_player_respawn, format[localize"STR_BTC_HAM_REP_PLAYER_RESPAWNED", _name]] };
    case _FOB_LOST_ : {[btc_rep_malus_fob_lost, format[localize"STR_BTC_HAM_REP_FOB_LOST", _name]]};
    case _HIDEOUT_DESTROYED_ : {[btc_rep_bonus_hideout, format[localize"STR_BTC_HAM_REP_HIDEOUT_DESTROYED", _name]]};
    case _IED_REMOVED_ : {[btc_rep_bonus_IEDCleanUp, format[localize"STR_BTC_HAM_REP_IED_REMOVED", _name]]};
    case _CAPTIVE_DETAINED_ : {[btc_rep_bonus_captive_detained, format[localize"STR_BTC_HAM_REP_CAPTIVE_DETAINED", _name]]};
    case _FOOD_GIVEN_ : {[btc_rep_bonus_foodGive, format[localize"STR_BTC_HAM_REP_FOOD_GIVEN", _name]]};
    case _CIV_KILLED_ : {[btc_rep_malus_civ_killed, format[localize"STR_BTC_HAM_REP_CIV_KILLED", _name]]};
    case _HOSTILE_KILLED_ : {[btc_rep_bonus_mil_killed, format[localize"STR_BTC_HAM_REP_HOSTILE_KILLED", _name]]};
    case _BUILDING_DAMAGED_ : {[btc_rep_malus_building_damaged, format[localize"STR_BTC_HAM_REP_BUILDING_DAMAGED", _name]]};
    case _BUILDING_DESTROYED_ : {[btc_rep_malus_building_destroyed, format[localize"STR_BTC_HAM_REP_BUILDING_DESTROYED", _name]]};
    case _EXPLOSIVE_DEFUSED_ : {[btc_rep_bonus_disarm, format[localize"STR_BTC_HAM_REP_EXPLOSIVE_DEFUSED", _name]]};
    case _FOOD_REMOVED_ : {[btc_rep_malus_foodRemove * _instigator, format[localize"STR_BTC_HAM_REP_FOOD_REMOVED", _name]]}; //_instigator is a multiplier in this case
    case _CIV_HURT_ : {[btc_rep_malus_civ_hd, format[localize"STR_BTC_HAM_REP_CIV_HURT", _name]]};
    case _ANIMAL_HURT_ : {[btc_rep_malus_animal_hd, format[localize"STR_BTC_HAM_REP_ANIMAL_HURT", _name]]};
    case _ANIMAL_KILLED_ : {[btc_rep_malus_animal_killed, format[localize"STR_BTC_HAM_REP_ANIMAL_KILLED", _name]]};
    case _CIV_HEALED_ : {[btc_rep_bonus_civ_hh, format[localize"STR_BTC_HAM_REP_CIV_HEALED", _name]]};
    case _CIV_SUPPRESSED_ : {[btc_rep_malus_civ_suppressed, format[localize"STR_BTC_HAM_REP_CIV_SUPPRESSED", _name]]};
    case _CIV_WHEEL_CHANGED_ : {[btc_rep_malus_wheelChangel, format[localize"STR_BTC_HAM_REP_CIV_WHEEL_CHANGED", _name]]};
    case _TAG_LETTER_REMOVED_ : {[btc_rep_bonus_removeTagLetter, format[localize"STR_BTC_HAM_REP_TAG_REMOVED", _name]]};
    case _TAG_REMOVED_ : {[btc_rep_bonus_removeTag, format[localize"STR_BTC_HAM_REP_TAG_REMOVED", _name]]};
    case _VEHICLE_LOST_: {[btc_rep_malus_veh_killed, 
        [format[localize"STR_BTC_HAM_REP_VEHICLE_LOST", _name], format[localize"STR_BTC_HAM_REP_VEHICLE_LOST_KILLER", _name]] select (!isNull _instigator)]};
    case _FRIENDLY_KILLED_ : {[btc_rep_malus_civ_killed, format[localize"STR_BTC_HAM_REP_FRIENDLY_KILLED", _name]]};
    case _CAPTIVE_KILLED_ : {[btc_rep_malus_civ_killed, format[localize"STR_BTC_HAM_REP_CAPTIVE_KILLED", _name]]};
    case _FOB_DISMANTLED_ : {[floor(btc_rep_malus_fob_lost/2), format[localize"STR_BTC_HAM_REP_FOB_DISMANTLED", _name]]};
    case _SUPPLIES_CLAIMED_ : {[btc_rep_bonus_supplies_claimed, format[localize"STR_BTC_HAM_REP_SUPPLIES_CLAIMED", _name]]};
    //SIDES
    case _SIDE_OFFICER_CAPTURED_ : {[50, format[localize"STR_BTC_HAM_REP_SIDE_OFFICER_CAPTURED", _name]]};
    case _SIDE_CHECKPOINT_DESTROYED_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_CHECKPOINT_DESTROYED", _name]]};
    case _SIDE_DECONTAMINATED_ : {[50, format[localize"STR_BTC_HAM_REP_SIDE_DECONTAMINATED", _name]]};
    case _SIDE_CIV_TREATED_;
    case _SIDE_CIV_BOAT_TREATED_: {[10, format[localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED", _name]]};
    case _SIDE_CIV_DECONTAMINATED_: {[15, format[localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED", _name]]};
    case _SIDE_CIV_RESCUED_: {[_instigator, format[localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED", _name]]}; //_instigator is the reputation modifier
    case _SIDE_CONVOY_AMBUSHED_ : {[50, format[localize"STR_BTC_HAM_REP_SIDE_CONVOY_AMBUSHED", _name]]};
    case _SIDE_EMP_DESTROYED_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_EMP_DESTROYED", _name]]};
    case _SIDE_CITY_TAKEN_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_CITY_TAKEN", _name]]};
    case _SIDE_TERMINAL_HACKED_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_TERMINAL_HACKED", _name]]};
    case _SIDE_HOSTAGE_RESCUED_ : {[40, format[localize"STR_BTC_HAM_REP_SIDE_HOSTAGE_RESCUED", _name]]};
    case _SIDE_TARGET_KILLED_: {[40, format[localize"STR_BTC_HAM_REP_SIDE_TARGET_KILLED", _name]]};
    case _SIDE_MINEFIELD_DEFUSED_ : {[30, format[localize"STR_BTC_HAM_REP_SIDE_MINEFIELD_DEFUSED", _name]]};
    case _SIDE_RUBBISH_REMOVED_ : {[2, format[localize"STR_BTC_HAM_REP_SIDE_RUBBISH_REMOVED", _name]]};
    case _SIDE_SUPPLIES_DELIVERED_ : {[50, format[localize"STR_BTC_HAM_REP_SIDE_SUPPLIES_DELIVERED", _name]]};
    case _SIDE_TOWER_DESTROYED_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_TOWER_DESTROYED", _name]]};
    case _SIDE_UNDERWATER_GENERATOR_DESTROYED_ : {[80, format[localize"STR_BTC_HAM_REP_SIDE_UNDERWATER_GENERATOR_DESTROYED", _name]]};
    case _SIDE_VEHICLE_REPAIRED_ : {[_instigator, format[localize"STR_BTC_HAM_REP_SIDE_VEHICLE_REPAIRED", _name]]}; //_instigator is the reputation modifier
    default {[0, "Invalid reputation change"]};
};

_change params [
    ["_rep_amount", 0, [0]],
    ["_text", "", [""]]
];
btc_global_reputation = btc_global_reputation + _rep_amount;

if (btc_debug) then {
    [format ["GLOBAL %1 - CHANGE %2 - REASON %3 - INSTIGATOR %4", btc_global_reputation, _rep_amount, _reason, _name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//abs rep var to make sure even negative changes are displayed
if(_showNotification) then {
    if ((btc_p_rep_notify != -1) && {(abs _rep_amount) >= btc_p_rep_notify}) then {

        private _colorIntensity = linearConversion [0, 5, _rep_amount, 0, 1, true];
        if(_rep_amount > 0) then {
            [
                ["core\img\thumbs_up.paa", 5, [0,(_colorIntensity + 0.3) min 1,0,1]], 
                [_text, 1, [1,1,1,1]]
            ] remoteExecCall ["CBA_fnc_notify", 0];
        } else {
            [
                ["core\img\thumbs_down.paa", 5, [(_colorIntensity + 0.3) min 1,0,0,1]], 
                [_text, 1, [1,1,1,1]]
            ] remoteExecCall ["CBA_fnc_notify", 0];
        };

    };
};

true
