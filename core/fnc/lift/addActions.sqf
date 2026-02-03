#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_lift_fnc_addActions

Description:
    Adds ACE actions for deploy or destroy ropes

Parameters:
    _chopper - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_lift_fnc_addActions;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */

private _action = [
    "Deploy_ropes", localize "STR_ACE_Fastroping_Interaction_deployRopes",
    "\A3\ui_f\data\igui\cfg\simpleTasks\types\container_ca.paa",
    {[] spawn btc_lift_fnc_deployRopes;},
    {!btc_ropes_deployed && {(driver vehicle player) isEqualTo player} && {(getPosATL player) select 2 > 4}}
] call ace_interact_menu_fnc_createAction;
["Helicopter", 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = [
    "Cut_ropes", localize "STR_ACE_Fastroping_Interaction_cutRopes",
    "\z\ace\addons\logistics_wirecutter\ui\wirecutter_ca.paa",
    {[] call btc_lift_fnc_destroyRopes;},
    {btc_ropes_deployed && {(driver vehicle player) isEqualTo player}}
] call ace_interact_menu_fnc_createAction;
["Helicopter", 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;