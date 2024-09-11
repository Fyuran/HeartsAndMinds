
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

if(!params[
    ["_addon", "", [""]]
]) exitWith {
    [format["invalid params: %1", _this], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;  
};

private _configs = "
getNumber (_x >> 'scope') == 2 && 
{(configSourceAddonList _x) isEqualTo [_addon]}
" configClasses (configFile >> "CfgWeapons");
private _classes = _configs apply {configName _x};

_classes