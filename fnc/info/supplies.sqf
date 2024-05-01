
/* ----------------------------------------------------------------------------
Function: btc_info_fnc_supplies

Description:
    Add an random intel marker for the current supply.

Parameters:
    _fob_supply - Current supply. [Object]
Returns:

Examples:
    (begin example)
        [] call btc_info_fnc_supplies;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

private _cities = (values btc_city_all) select {
    _x getVariable ["occupied", false] && 
    {(_x getVariable ["data_supplies", []]) isNotEqualTo []}
};
_cities = [_cities, (round((count _cities)/4)) max 2] call CBA_fnc_selectRandomArray;
if(_cities isEqualTo []) exitWith { //give next intel instead
    [objNull, 31] call btc_info_fnc_give_intel;
};

//get markers data out of data supplies, add intel markers then save it back to _city
_cities apply {
    private _data_supplies = _x getVariable ["data_supplies", []]; //[ 1:[_pos, random 360, btc_log_fob_max_resources, []], ... ]

    private _data = selectRandom _data_supplies;
    private _index = _data_supplies find _data; //get index on array where to next edit
    _data params ["_pos", "", "", "_markers"];

    private _markerPos = [_pos, btc_info_supply_radius] call CBA_fnc_randPos;
    private _marker = createMarkerLocal[format["supply_%1_int_%2", _x getVariable ["id", -1], count _markers], _markerPos];
    if(_marker isNotEqualTo "") then {
        _marker setMarkerTypeLocal "hd_unknown";
        _marker setMarkerTextLocal format ["%1m", btc_info_supply_radius];
        _marker setMarkerSizeLocal[0.4, 0.4];
        _marker setMarkerAlphaLocal 0.35;
        _marker setMarkerColor "ColorPink";
        _markers pushBack [_marker, _markerPos];
        
        _data set [3, _markers];
        _data_supplies set [_index, _data];
        _x setVariable ["data_supplies", _data_supplies];
    };

};