
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_supplies

Description:
    Shows or Hides hideouts' markers locally

Parameters:


Returns:

Examples:
    (begin example)
        _result = [true] call btc_debug_fnc_supplies;
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

(btc_debug_namespace getVariable "unclaimed_supplies") apply { //["_id", "_pos", "_dir", "_resources", "_markers"]
	(values _y) params (keys _y);
    private _markerVarName = format ["btc_city_unclaimed_supply_%1", _pos];
    private _marker = createMarkerLocal [_markerVarName, _pos];

	if(_isEnable) then {
		_markerVarName setMarkerTypeLocal "hd_warning";
		_markerVarName setMarkerTextLocal format["Supply(id:%1)", _id];
		_markerVarName setMarkerSizeLocal [0.8, 0.8];
		_markerVarName setMarkerColorLocal "ColorPink";
	} else {
		deleteMarkerLocal _markerVarName;
	};
};

(btc_debug_namespace getVariable "claimed_supplies") apply {
	(values _y) params (keys _y);
	private _markerVarName = format ["btc_city_claimed_supply_%1", _pos];
    private _marker = createMarkerLocal [_markerVarName, _pos];

	if(_isEnable) then {
		_markerVarName setMarkerTypeLocal "hd_warning";
		_markerVarName setMarkerTextLocal format["Supply(r:%1)", _resources];
		_markerVarName setMarkerSizeLocal [0.8, 0.8];
		_markerVarName setMarkerColorLocal "ColorPink";
	} else {
		deleteMarkerLocal _markerVarName;
	};
};

if(_isEnable) then {
	btc_debug_fob_supplies = true;
	hint "FOB Supplies Markers on";
	true
} else {
	btc_debug_fob_supplies = false;
	hint "FOB Supplies Markers off";
	false
};