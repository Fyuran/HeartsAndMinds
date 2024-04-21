
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_fob_supplies

Description:
    Shows or Hides hideouts' markers locally

Parameters:


Returns:

Examples:
    (begin example)
        _result = [true] call btc_debug_fnc_fob_supplies;
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

{
    private _markerVarName = format ["fob_supply_%1",  _forEachIndex];
    private _marker = getMarkerPos _markerVarName;
    if(_marker isEqualTo [0,0,0]) then {
        createMarkerLocal [_markerVarName, _x];
    };

	if(_isEnable) then {
		_markerVarName setMarkerTypeLocal "hd_warning";
		_markerVarName setMarkerTextLocal "Supply";
		_markerVarName setMarkerSizeLocal [0.8, 0.8];
		_markerVarName setMarkerColorLocal "ColorPink";
	} else {
		deleteMarkerLocal _markerVarName;
	};
} forEach (btc_debug_namespace getVariable "fob_supplies");


if(_isEnable) then {
	btc_debug_fob_supplies = true;
	hint "FOB Supplies Markers on";
	true
} else {
	btc_debug_fob_supplies = false;
	hint "FOB Supplies Markers off";
	false
};