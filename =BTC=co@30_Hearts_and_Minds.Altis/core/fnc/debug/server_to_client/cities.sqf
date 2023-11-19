
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
	(values _y) params (keys _y);
	private _markerVarName = format ["_loc_%1", _id];
	private _marker = _y getOrDefault [_markerVarName, createMarkerLocal [_markerVarName, _pos], true];

	private _markeVarName = format ["_locn_%1", _id];
	private _marke = _y getOrDefault [_markeVarName, createMarkerLocal [_markeVarName, _pos], true];

	private _spaces = "";
	for "_i" from 0 to count _name -1 do {
		_spaces = _spaces + " ";
	};

	if(_isEnable) then {
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerBrushLocal "SolidBorder";
		_marker setMarkerSizeLocal [_cachingRadius + btc_city_radiusOffset, _cachingRadius + btc_city_radiusOffset];
		_marker setMarkerAlphaLocal 0.3;
		if (_occupied) then {
			_marker setMarkerColorLocal (["colorRed", "ColorCIV"] select _initialized);
		} else {
			_marker setMarkerColorLocal (["colorGreen", "ColorWhite"] select _initialized);
		};

		_marke setMarkerTypeLocal "Contact_dot1";
		_marke setMarkerTextLocal format [_spaces + "%1 ID %2 - %3", _type, _id, _hasBeach];
	} else {
		_y deleteAt _markerVarName;
		_y deleteAt _markeVarName;
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