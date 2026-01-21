#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_damageLoop

Description:
    Apply chemical damage constantly.

Parameters:
    _unit - Unit to apply the damage. [Object]
    _notAlready - false if is already contaminated. [Boolean]

Returns:

Examples:
    (begin example)
        [] call btc_chem_fnc_damageLoop;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_unit", player, [objNull]],
    ["_notAlready", true, [true]]
];

private _bodyParts = ["head","body","hand_l","hand_r","leg_l","leg_r"];
private _handle = [{
    params ["_args", "_handle"];
    private _unit = _args select 0;

    if !(alive _unit) exitWith {
        ["btc_chem_decontaminated", [_unit]] call CBA_fnc_localEvent;
    };
    _this set [0, _args call btc_chem_fnc_damage];
}, 3, [_unit, _notAlready, _bodyParts, configFile >> "CfgGlasses"]] call CBA_fnc_addPerFrameHandler;

["btc_chem_decontaminated", {
    params ["_unitfromCallEvent"];
    _thisArgs params ["_handle", "_unit"];

    if (_unitfromCallEvent isEqualTo _unit) then {
        [_thisType, _thisId] call CBA_fnc_removeEventHandler;
        [_handle] call CBA_fnc_removePerFrameHandler;

        #ifdef BTC_DEBUG_CHEM
        [["%1: Stop: %2", __FILE_NAME__, _handle], 2, "chem"] call btc_debug_fnc_message;
        #endif};
}, [_handle, _unit]] call CBA_fnc_addEventHandlerArgs;

#ifdef BTC_DEBUG_CHEM
[["%1: Start: %2", __FILE_NAME__, _handle], 2, "chem"] call btc_debug_fnc_message;
#endif