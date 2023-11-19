
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_hideouts

Description:
    Shows or Hides hideouts' markers locally

Parameters:


Returns:

Examples:
    (begin example)
        _result = [true] call btc_debug_fnc_hideouts;
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

(btc_debug_namespace getVariable "hideouts") apply {
		(values _y) params (keys _y);
		private _markerVarName = format ["_hideout_loc_%1",  _pos];
		private _marker = _y getOrDefault [_markerVarName, createMarkerLocal [_markerVarName, _pos], true];

	if(_isEnable) then {
		_marker setMarkerTypeLocal "mil_unknown";
		_marker setMarkerTextLocal format ["Hideout %1", _id];
		_marker setMarkerSizeLocal [0.8, 0.8];
		_marker setMarkerColorLocal "ColorRed";
	} else {
		_y deleteAt _markerVarName;
		deleteMarkerLocal _marker;
	};
};




if(_isEnable) then {
	btc_debug_hideouts = true;
	hint "Hideouts Markers on";
	true
} else {
	btc_debug_hideouts = false;
	hint "Hideouts Markers off";
	false
};