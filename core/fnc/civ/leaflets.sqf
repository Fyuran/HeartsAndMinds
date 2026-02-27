#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_civ_fnc_leaflets

Description:
    Evacuate civilian when player drop leaflets.

Parameters:
    _uav - UAV use by player. [Object]
    _weapon - Type of weapon use by player inside UAV. [String]

Returns:

Examples:
    (begin example)
        _result = [player, "Bomb_Leaflets"] call btc_civ_fnc_leaflets;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_uav", objNull, [objNull]],
    ["_weapon", "", [""]]
];

#ifdef BTC_DEBUG_CIV
[["%1: %2 fired with %3", typeOf _uav, _weapon], 2, "civ"] call FUNC(debug,message);
#endif
if (_weapon isEqualTo "Bomb_Leaflets") then {
    [getPos _uav] remoteExecCall ["btc_civ_fnc_evacuate", 2];
};
