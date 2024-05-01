    
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_cache

Description:
    Shows or Hides cache markers locally

Parameters:


Returns:

Examples:
    (begin example)
        _result = [true] call btc_debug_fnc_cache;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
	["_isEnable", true, [true]]
];

if(isNil "btc_debug_namespace") exitWith {
    [format["btc_debug_namespace isNil something went wrong with PublicVariableClient in request_server_data"], 
        __FILE__, nil, true] call btc_debug_fnc_message;
};

//["cache_n", "cache_pos"]
private _hash = btc_debug_namespace getVariable "cache";
private _cache_n = _hash get "cache_n";
private _pos = _hash get "cache_pos";

private _marker = _hash getOrDefault ["_cache_loc", createMarkerLocal [format ["btc_cache_%1",  _cache_n], _pos], true];
if(_isEnable) then {
    _marker setMarkerType "mil_unknown";
    _marker setMarkerText format ["Cache %1", _cache_n];
    _marker setMarkerSize [0.8, 0.8];
} else {
	deleteMarkerLocal _marker;
};


if(_isEnable) then {
    btc_debug_cache = true;
	hint "Cache Markers on";
	true
} else {
    btc_debug_cache = false;
	hint "Cache Markers off";
	false
};
