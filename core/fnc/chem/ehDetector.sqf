#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_ehDetector

Description:
    Attach event handlers to detect chemical detector key presses and trigger screen updates with contamination levels.

Parameters:
    NONE

Returns:
    NOTHING

Examples:
    (begin example)
        [] call btc_chem_fnc_ehDetector;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

"btc_chem_detector" cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false]; //IGUI display on

[{!isNull (findDisplay 46)}, {
    (findDisplay 46) displayAddEventHandler ["KeyDown", {
        params ["_display", "_key"];

        if (
            (_key in actionKeys "Watch" || _key in actionKeys "WatchToggle") &&
            {!visibleWatch} &&
            {"ChemicalDetector_01_watch_F" in (assignedItems player)}
        ) then {
            private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
            private _obj = _ui displayCtrl 101;

            [{visibleWatch}, FUNC(chem,updateDetector), [_obj]] call CBA_fnc_waitUntilAndExecute;
        };
    }];
}] call CBA_fnc_waitUntilAndExecute;
