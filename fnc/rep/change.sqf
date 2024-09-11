
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
        [player, 101] call btc_rep_fnc_change;
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

private _name = "";
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
    case _HIDEOUT_DESTROYED_ : {[btc_rep_bonus_hideout, localize"STR_BTC_HAM_REP_HIDEOUT_DESTROYED"]};
    case _IED_REMOVED_ : {[btc_rep_bonus_IEDCleanUp, localize"STR_BTC_HAM_REP_IED_REMOVED", true]};
    case _CAPTIVE_DETAINED_ : {[btc_rep_bonus_captive_detained, localize"STR_BTC_HAM_REP_CAPTIVE_DETAINED", true]};
    case _FOOD_GIVEN_ : {[btc_rep_bonus_foodGive, localize"STR_BTC_HAM_REP_FOOD_GIVEN", true]};
    case _CIV_KILLED_ : {[btc_rep_malus_civ_killed, localize"STR_BTC_HAM_REP_CIV_KILLED", true]};
    case _HOSTILE_KILLED_ : {[btc_rep_bonus_mil_killed, localize"STR_BTC_HAM_REP_HOSTILE_KILLED", true]};
    case _BUILDING_DAMAGED_ : {[btc_rep_malus_building_damaged, localize"STR_BTC_HAM_REP_BUILDING_DAMAGED"]};
    case _BUILDING_DESTROYED_ : {[btc_rep_malus_building_destroyed, localize"STR_BTC_HAM_REP_BUILDING_DESTROYED"]};
    case _EXPLOSIVE_DEFUSED_ : {[btc_rep_bonus_disarm, localize"STR_BTC_HAM_REP_EXPLOSIVE_DEFUSED", true]};
    case _FOOD_REMOVED_ : {[btc_rep_malus_foodRemove * _instigator, localize"STR_BTC_HAM_REP_FOOD_REMOVED"]}; //_instigator is a multiplier in this case
    case _CIV_HURT_ : {[btc_rep_malus_civ_hd, localize"STR_BTC_HAM_REP_CIV_HURT", true]};
    case _ANIMAL_HURT_ : {[btc_rep_malus_animal_hd, localize"STR_BTC_HAM_REP_ANIMAL_HURT", true]};
    case _ANIMAL_KILLED_ : {[btc_rep_malus_animal_killed, localize"STR_BTC_HAM_REP_ANIMAL_KILLED", true]};
    case _CIV_HEALED_ : {[btc_rep_bonus_civ_hh, localize"STR_BTC_HAM_REP_CIV_HEALED", true]};
    case _CIV_SUPPRESSED_ : {[btc_rep_malus_civ_suppressed, localize"STR_BTC_HAM_REP_CIV_SUPPRESSED", true]};
    case _CIV_WHEEL_CHANGED_ : {[btc_rep_malus_wheelChange, localize"STR_BTC_HAM_REP_CIV_WHEEL_CHANGED"]};
    case _TAG_LETTER_REMOVED_ : {[btc_rep_bonus_removeTagLetter, localize"STR_BTC_HAM_REP_TAG_REMOVED"]};
    case _TAG_REMOVED_ : {[btc_rep_bonus_removeTag, localize"STR_BTC_HAM_REP_TAG_REMOVED", true]};
    case _VEHICLE_LOST_: {[btc_rep_malus_veh_killed, localize"STR_BTC_HAM_REP_VEHICLE_LOST", [true, false] select isNull _instigator]};
    case _FRIENDLY_KILLED_ : {[btc_rep_malus_civ_killed, localize"STR_BTC_HAM_REP_FRIENDLY_KILLED", true]};
    case _CAPTIVE_KILLED_ : {[btc_rep_malus_civ_killed, localize"STR_BTC_HAM_REP_CAPTIVE_KILLED", true]};
    case _FOB_DISMANTLED_ : {[floor(btc_rep_malus_fob_lost/2), format[localize"STR_BTC_HAM_REP_FOB_DISMANTLED", _name]]};
    case _SUPPLIES_CLAIMED_ : {[btc_rep_bonus_supplies_claimed, localize"STR_BTC_HAM_REP_SUPPLIES_CLAIMED", true]};
    //SIDES
    case _SIDE_OFFICER_CAPTURED_ : {[50, localize"STR_BTC_HAM_REP_SIDE_OFFICER_CAPTURED"]};
    case _SIDE_CHECKPOINT_DESTROYED_ : {[80, localize"STR_BTC_HAM_REP_SIDE_CHECKPOINT_DESTROYED"]};
    case _SIDE_DECONTAMINATED_ : {[50, localize"STR_BTC_HAM_REP_SIDE_DECONTAMINATED"]};
    case _SIDE_CIV_TREATED_;
    case _SIDE_CIV_BOAT_TREATED_: {[10, localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED"]};
    case _SIDE_CIV_DECONTAMINATED_: {[15, localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED"]};
    case _SIDE_CIV_RESCUED_: {[_instigator, localize"STR_BTC_HAM_REP_SIDE_CIV_TREATED"]}; //_instigator is the reputation modifier
    case _SIDE_CONVOY_AMBUSHED_ : {[50, localize"STR_BTC_HAM_REP_SIDE_CONVOY_AMBUSHED"]};
    case _SIDE_EMP_DESTROYED_ : {[80, localize"STR_BTC_HAM_REP_SIDE_EMP_DESTROYED"]};
    case _SIDE_CITY_TAKEN_ : {[80, localize"STR_BTC_HAM_REP_SIDE_CITY_TAKEN"]};
    case _SIDE_TERMINAL_HACKED_ : {[80, localize"STR_BTC_HAM_REP_SIDE_TERMINAL_HACKED"]};
    case _SIDE_HOSTAGE_RESCUED_ : {[40, localize"STR_BTC_HAM_REP_SIDE_HOSTAGE_RESCUED"]};
    case _SIDE_TARGET_KILLED_: {[40, localize"STR_BTC_HAM_REP_SIDE_TARGET_KILLED"]};
    case _SIDE_MINEFIELD_DEFUSED_ : {[30, localize"STR_BTC_HAM_REP_SIDE_MINEFIELD_DEFUSED"]};
    case _SIDE_RUBBISH_REMOVED_ : {[2, localize"STR_BTC_HAM_REP_SIDE_RUBBISH_REMOVED"]};
    case _SIDE_SUPPLIES_DELIVERED_ : {[50, localize"STR_BTC_HAM_REP_SIDE_SUPPLIES_DELIVERED"]};
    case _SIDE_TOWER_DESTROYED_ : {[80, localize"STR_BTC_HAM_REP_SIDE_TOWER_DESTROYED"]};
    case _SIDE_UNDERWATER_GENERATOR_DESTROYED_ : {[80, localize"STR_BTC_HAM_REP_SIDE_UNDERWATER_GENERATOR_DESTROYED"]};
    case _SIDE_VEHICLE_REPAIRED_ : {[_instigator, localize"STR_BTC_HAM_REP_SIDE_VEHICLE_REPAIRED"]}; //_instigator is the reputation modifier
    default {[0, "Invalid reputation change"]};
};

_change params [
    ["_rep_amount", 0, [0]],
    ["_text", "", [""]],
    ["_showInstigator", false, [true]]
];
btc_global_reputation = btc_global_reputation + _rep_amount;

if (btc_debug) then {
    [format ["GLOBAL %1 - CHANGE %2 - REASON %3 - INSTIGATOR %4", btc_global_reputation, _rep_amount, _reason, _name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

//abs rep var to make sure even negative changes are displayed
if(_showNotification) then {
    if ((btc_p_rep_notify != -1) && {(abs _rep_amount) >= btc_p_rep_notify}) then {

        private _colorIntensity = linearConversion [0, 5, (abs _rep_amount), 0.25, 1, true];

        private _color = "#FFFFFF";
        if(_rep_amount > 0) then { //if rep is positive use green color else red
            _color = [0, _colorIntensity, 0] call BIS_fnc_colorRGBtoHTML;
        };
        if(_rep_amount < 0) then {
            _color = [_colorIntensity, 0, 0] call BIS_fnc_colorRGBtoHTML;
        };

        private _posX = safeZoneW + (safeZoneX * 2.5);
        private _posY = safeZoneH + (safeZoneY * 2);
        private _textArray = [
            [format["SITREP %1H:", [dayTime, "HH:MM"] call BIS_fnc_timeToString], "align = 'center' shadow = '1' size = '0.7' font = 'RobotoCondensed'", 0.5, 0.08],
            [toUpper _text, format["align = 'center' color = '%1' shadow = '1' size = '0.7' font = 'RobotoCondensed'", _color], 0.5, 0.08]
        ]; 
        if(_showInstigator) then {
            _textArray pushBack ["BY:","align = 'center' shadow = '1' size = '0.7' font = 'RobotoCondensed'", 0.5, 0.08];
            _textArray pushBack [toUpper _name,"align = 'center' shadow = '1' size = '0.7' font = 'RobotoCondensed'", 3, 0.2];
        };

        [_posX, _posY, _textArray] remoteExec ["btc_fnc_typeText", [0, -2] select isDedicated];
    };
};

true
