#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_effects

Description:
    Create effects on player (smoke, rock, shock wave ...).

Parameters:
    _pos - Position of the IED. [Array]
    _caller - Player. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_ied_fnc_effects;
    (end)

Author:
    1kuemmel1

---------------------------------------------------------------------------- */

params [
    ["_pos", [0, 0, 0], [[]]],
    ["_caller", player, [objNull]]
];

[_pos, _caller] spawn FUNC(ied,effect_blurEffect);
[_pos] spawn FUNC(ied,effect_smoke);
[_pos] spawn FUNC(ied,effect_rocks);
[_pos] spawn FUNC(ied,effect_shock_wave);
