
/* ----------------------------------------------------------------------------
Function: btc_info_fnc_give_intel

Description:
    Give intel to the player.

Parameters:
    _asker - Player. [Object]
    _intelType - Intel type [Number]
Returns:
    _intelType - Return the type of intel. [Number]

Examples:
    (begin example)
        _intelType = [player] call btc_info_fnc_give_intel;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_asker", -1, [objNull, 0]],
    ["_intelType", random 100, [0]]
];

if (btc_hideouts isEqualTo []) then {_intelType = _cacheInt - 10;};
btc_info_intel_type params ["_suppliesInt", "_cacheInt", "_hoInt"];

//btc_info_intel_type = [30, 80, 95];//fob_supplies - cache - hd - >95 both
switch (true) do {
    case (_intelType <= _suppliesInt) : { //supplies
        [] call btc_info_fnc_supplies;
        [4] remoteExecCall ["btc_fnc_show_hint", _asker];
    };
    case (_intelType > _suppliesInt && {_intelType <= _cacheInt}) : { //cache
        [true] call btc_info_fnc_cache;
    };
    case (_intelType > _cacheInt && {_intelType < _hoInt}) : { //ho
        [] call btc_info_fnc_hideout;
        [5] remoteExecCall ["btc_fnc_show_hint", _asker];
    };
    case (_intelType >= _hoInt) : { //all
        [true] call btc_info_fnc_cache;
        [] call btc_info_fnc_hideout;
        [5] remoteExecCall ["btc_fnc_show_hint", _asker];
    };
    default {
        [3] remoteExecCall ["btc_fnc_show_hint", _asker];
    };
};

_intelType
