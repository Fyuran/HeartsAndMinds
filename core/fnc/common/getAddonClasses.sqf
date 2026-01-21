#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_fnc_getAddonClasses

Description:

Parameters:

Returns:

Examples:
    (begin example)
        ["ace_medical_treatment"] call btc_fnc_getAddonClasses;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_addon", "", [""]],
    ["_cfg", "CfgWeapons", [""]]
];

private _configs = [];
if(_cfg isNotEqualTo "all") then {
    _configs = 'getNumber (_x >> "scope") == 2 && {(configSourceAddonList _x) isEqualTo [_addon]}' configClasses (configFile >> _cfg);
} else {
    _configs append ('getNumber (_x >> "scope") == 2 && {(configSourceAddonList _x) isEqualTo [_addon]}' configClasses (configFile >> "CfgMagazines"));
    _configs append ('getNumber (_x >> "scope") == 2 && {(configSourceAddonList _x) isEqualTo [_addon]}' configClasses (configFile >> "CfgWeapons"));
};

private _classes = _configs apply {configName _x};

_classes