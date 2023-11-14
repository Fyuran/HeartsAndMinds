
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
		_x params [
			"_id", 
			"_pos"
		];
		private _markerVarName = format ["btc_hideout_%1",  _pos];
		private _marker = btc_debug_namespace getVariable [_markerVarName, createMarkerLocal [_markerVarName, _pos]];

	if(_isEnable) then {
		_marker setMarkerTypeLocal "mil_unknown";
		_marker setMarkerTextLocal format ["Hideout %1", _id];
		_marker setMarkerSizeLocal [0.8, 0.8];
		_marker setMarkerColorLocal "ColorRed";
		btc_debug_namespace setVariable [_markerVarName, _marker];
	} else {
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