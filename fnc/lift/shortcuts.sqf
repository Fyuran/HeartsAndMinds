
/* ----------------------------------------------------------------------------
Function: btc_lift_fnc_shortcuts

Description:
    Create CBA keybinds for lift.

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_lift_fnc_shortcuts;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

#include "..\script_macros.hpp"

private _menuString = "Hearts and Minds " + localize "STR_HOOKCARGO";
[
    _menuString,
    "btc_HaM_lift_deployRopes",
    [localize "STR_ACE_Fastroping_Interaction_deployRopes", "deploy ropes from helicopter"],
    {
        if (
            !btc_ropes_deployed &&
            {(driver vehicle player) isEqualTo player} &&
            {(getPosATL player) select 2 > 4}
        ) then {
            [] spawn btc_lift_fnc_deployRopes;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;

[
    _menuString,
    "btc_HaM_lift_cutRopes",
    [localize "STR_ACE_Fastroping_Interaction_cutRopes", "Cut ropes from helicopter"],
    {
        if (
            btc_ropes_deployed &&
            {(driver vehicle player) isEqualTo player}
        ) then {
            [] call btc_lift_fnc_destroyRopes;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;

[
    _menuString,
    "btc_HaM_lift_HUD",
    [localize "STR_BTC_HAM_LOG_LDR_ACTIONHUD", "On / Off HUD"],
    {
        if (btc_ropes_deployed) then {
            [] call btc_lift_fnc_hud;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;


[
    _menuString,
    "btc_HaM_lift_hook",
    [localize "STR_BTC_HAM_LOG_HOOK", "Hook a vehicle"],
    {
        if ([] call btc_lift_fnc_check) then {
            [] spawn btc_lift_fnc_hook;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;
