
/* ----------------------------------------------------------------------------
Function: btc_info_fnc_fob_supplies

Description:
    Add an random intel marker for the current fob supply.

Parameters:
    _fob_supply - Current supply. [Object]
Returns:

Examples:
    (begin example)
        [] call btc_info_fnc_fob_supplies;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

private _cities = values btc_city_all;
 
private _valid_supplies = [];
_cities apply {
    private _city = _x;
    private _cachingRadius = _city getVariable ["cachingRadius", 100];
    private _valid = btc_log_fob_supply_objects select {
        ((_x distanceSqr _city) < (_cachingRadius*_cachingRadius)) && {!(_x getVariable ["btc_fob_log_isClaimed", false])}
    };
    _valid apply {
		_valid_supplies pushBackUnique _x;
	};
};
if(_valid_supplies isEqualTo []) exitWith { //give next intel instead
    [objNull, 31] call btc_info_fnc_give_intel;
};

for "_i" from 0 to ((ceil((count _valid_supplies)/4)) max 2) do {
    private _fob_supply = selectRandom _valid_supplies;
    _markersArray = _fob_supply getVariable ["markers", []];

    private _pos = [getPosASL _fob_supply, btc_info_supply_radius] call CBA_fnc_randPos;
    private _marker = createMarkerLocal [format ["%1", _pos], _pos];
    _marker setMarkerTypeLocal "hd_unknown";
    _marker setMarkerTextLocal format ["%1m", btc_info_supply_radius];
    _marker setMarkerSizeLocal [0.4, 0.4];
    _marker setMarkerAlphaLocal 0.35;
    _marker setMarkerColor "ColorPink";

    _markersArray pushBack _marker;
    _fob_supply setVariable ["markers", _markersArray];
};
