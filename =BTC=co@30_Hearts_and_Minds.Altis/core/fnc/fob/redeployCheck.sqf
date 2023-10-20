
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_redeployCheck

Description:
    Check if player can redeploy.

Parameters:

Returns:
    _canRedeploy - Can redeploy. [Boolean]

Examples:
    (begin example)
        [] call btc_fob_fnc_redeployCheck;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

if !(player call ace_medical_status_fnc_isInStableCondition) exitWith {
    [[localize "STR_BTC_HAM_O_FOB_CANTREDEPLOY"], [localize "STR_BTC_HAM_O_FOB_REDEPLOYNOTSTABLE"]] call CBA_fnc_notify;
    playSound "addItemFailed";
    false
};

if (
    ["leftarm", "rightarm", "leftleg", "rightleg"] findIf {
        [player, player, _x] call ace_medical_treatment_fnc_canSplint
    } > -1
) exitWith {
    [[localize "STR_BTC_HAM_O_FOB_CANTREDEPLOY"], [localize "STR_BTC_HAM_O_FOB_REDEPLOYSPLINT"]] call CBA_fnc_notify;
    playSound "addItemFailed";
    false
};

if( //_params here is managed only in the case of an Object
    (_this isEqualType objNull && {_this getVariable["FOB_Event", false]}) //Will be set to true if Event FOB attack is fired on the flag's FOB
) exitWith {
    [[localize "STR_BTC_HAM_O_FOB_CANTREDEPLOY"], [localize "STR_BTC_HAM_EVENT_CANNOTDEPLOY"]] call CBA_fnc_notify;
    playSound "addItemFailed";
    false
};

true
