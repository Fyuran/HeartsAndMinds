#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_fnc_btc_fnc_getFilteredLoadout

Description:
    pass a regex and an optional cfgName to get back list of classes matching the regex (adds compatible mags and items if a weapon)
Parameters:
    _regex - String
    _cfg - OPTIONAL String

Returns:

Examples:
    (begin example)
        ["rhs_weap_ak.*"] call btc_fnc_getFilteredLoadout;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
	 ["_regex", "", [""]],
	 ["_cfg", "CfgWeapons", [""]]
];

private _weap_configs = [];
if(_regex isNotEqualTo "true") then {
	_weap_configs = '(getNumber(_x >> "scope") == 2) && {(configName _x) regexMatch _regex}' configClasses (configFile >> _cfg);
} else {
	_weap_configs = '(getNumber(_x >> "scope") == 2)' configClasses (configFile >> _cfg);
};
private _weap_classNames = _weap_configs apply {configName _x};

private _weap_magazines = [];
_weap_classNames apply {
	_weap_magazines append (compatibleMagazines _x)
};
_weap_magazines = _weap_magazines arrayIntersect _weap_magazines;


private _weap_items = [];
_weap_classNames apply {
	_weap_items append (compatibleItems _x)
};
_weap_items = _weap_items arrayIntersect _weap_items;


[_weap_classNames, _weap_magazines, _weap_items]