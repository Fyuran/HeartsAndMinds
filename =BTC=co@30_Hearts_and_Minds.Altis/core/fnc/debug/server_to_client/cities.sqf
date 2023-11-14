
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_cities

Description:
    Shows or Hides cities' markers locally

Parameters:


Returns:

Examples:
    (begin example)
        _result = [true] call btc_debug_fnc_cities;
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


(btc_debug_namespace getVariable "cities") apply {
	_x params[
		"_id",
		"_occupied",
		"_name",
		"_type",
		"_cachingRadius",
		"_hasBeach",
		"_pos"
	];
	private _markerVarName = format ["loc_%1", _id];
	private _marker = btc_debug_namespace getVariable [_markerVarName, createMarkerLocal [_markerVarName, _pos]];

	private _markeVarName = format ["locn_%1", _id];
	private _marke = btc_debug_namespace getVariable [_markeVarName, createMarkerLocal [_markeVarName, _pos]];

	private _spaces = "";
	for "_i" from 0 to count _name -1 do {
		_spaces = _spaces + " ";
	};

	if(_isEnable) then {
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerBrushLocal "SolidBorder";
		_marker setMarkerSizeLocal [_cachingRadius + btc_city_radiusOffset, _cachingRadius + btc_city_radiusOffset];
		_marker setMarkerAlphaLocal 0.3;
		_marker setMarkerColorLocal (["colorGreen", "colorRed"] select _occupied);

		_marke setMarkerTypeLocal "Contact_dot1";
		_marke setMarkerTextLocal format [_spaces + "%1 ID %2 - %3", _type, _id, _hasBeach];

		btc_debug_namespace setVariable [_markerVarName, _marker];
		btc_debug_namespace setVariable [_markeVarName, _marke];
	} else {
		deleteMarkerLocal _marker;
		deleteMarkerLocal _marke;
	};
};

if(_isEnable) then {
	btc_debug_cities = true;
	hint "Cities Markers on";
} else {
	btc_debug_cities = false;
	hint "Cities Markers off";
};