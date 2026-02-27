#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_damageLoop

Description:
    Set up a per-frame handler that continuously applies chemical damage to a unit until decontaminated, with damage intensity based on protection gear.

Parameters:
    _unit[OBJECT]: Unit receiving chemical damage (default: player)
    _notAlready[BOOLEAN]: Whether this is the unit's first contamination exposure (default: true)

Returns:
    NOTHING

Examples:
    (begin example)
        [soldier1, true] call btc_chem_fnc_damageLoop;
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
    _this set [0, _args call FUNC(chem,damage)];
}, 3, [_unit, _notAlready, _bodyParts, configFile >> "CfgGlasses"]] call CBA_fnc_addPerFrameHandler;

["btc_chem_decontaminated", {
    params ["_unitfromCallEvent"];
    _thisArgs params ["_handle", "_unit"];

    if (_unitfromCallEvent isEqualTo _unit) then {
        [_thisType, _thisId] call CBA_fnc_removeEventHandler;
        [_handle] call CBA_fnc_removePerFrameHandler;

        #ifdef BTC_DEBUG_CHEM
        [["%1: Stop: %2", __FILE_NAME__, _handle], 2, "chem"] call FUNC(debug,message);
        #endif};
}, [_handle, _unit]] call CBA_fnc_addEventHandlerArgs;

#ifdef BTC_DEBUG_CHEM
[["%1: Start: %2", __FILE_NAME__, _handle], 2, "chem"] call FUNC(debug,message);
#endif