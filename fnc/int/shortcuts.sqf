
/* ----------------------------------------------------------------------------
Function: btc_int_fnc_shortcuts

Description:
    Create CBA keybinds to orders.

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_int_fnc_shortcuts;
    (end)

Author:
    1kuemmel1

---------------------------------------------------------------------------- */

#include "..\script_macros.hpp"

private _menuString = "Hearts and Minds " + localize "STR_BTC_HAM_ACTION_ORDERS_MAIN";
//Order Stop
[
    _menuString,
    "btc_HaM_Action_civStop",
    [localize "STR_BTC_HAM_ACTION_ORDERS_STOP", localize "STR_BTC_HAM_O_SHORTC_STOP_NOTE"],
    { //"Civil Order: Stop", "Order a civilian to stop"
        if (isNull objectParent player) then {
            [1] call btc_int_fnc_orders;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;

//Order Get down
[
    _menuString,
    "btc_HaM_Action_civGetDown",
    [localize "STR_BTC_HAM_ACTION_ORDERS_GETDOWN", localize "STR_BTC_HAM_O_SHORTC_GETDOWN_NOTE"],
    { //"Civil Order: Get down", "Order a civilian to get down"
        if (isNull objectParent player) then {
            [2] call btc_int_fnc_orders;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;

//Order Go away
[
    _menuString,
    "btc_HaM_Action_civGoAway",
    [localize "STR_BTC_HAM_ACTION_ORDERS_GOAWAY", localize "STR_BTC_HAM_O_SHORTC_GOAWAY_NOTE"],
    { //"Civil Order: Go Away", "Order a civilian to go away"
        if (isNull objectParent player) then {
            [3] call btc_int_fnc_orders;
            if (_BTC_PLAY_FBSOUND_) then {
                playSound _BTC_FBSOUND_;
            };
        };
    },
{}] call CBA_fnc_addKeybind;
