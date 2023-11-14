/* ----------------------------------------------------------------------------
	Function: btc_debug_fnc_debug_mode
	
	Description:
	    Shows or Hides cities' markers locally
	
	Parameters:
	
	
	Returns:
	
	Examples:
	    (begin example)
	        _result = [true] call btc_debug_fnc_debug_mode;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
params[
	["_isEnable", true, [true]]
];

if (_isEnable) then {
	btc_debug = true; btc_debug_log = true;
	hint "Debug mode on";
	player allowDamage false;

	private _mapSingleClick = addMissionEventHandler ["MapSingleClick", {
		params ["_units", "_pos", "_alt", "_shift"];
		if ( alive player && {!_alt && !_shift}) then {
			vehicle player setPos _pos;
		};
	}];
	btc_debug_namespace setVariable ["btc_debug_mapSingleClick", _mapSingleClick];

	[{!isNull (findDisplay 12)}, {
		_perFrameHandler = [{
			[10, objNull, "btc_units_owners"] remoteExecCall ["btc_int_fnc_ask_var", 2];
			["btc_patrol_active", objNull, "btc_patrol_active"] remoteExecCall ["btc_int_fnc_ask_var", 2];
			["btc_civ_veh_active", objNull, "btc_civ_veh_active"] remoteExecCall ["btc_int_fnc_ask_var", 2];
			["btc_delay_time", objNull, "btc_delay_timeDebug"] remoteExecCall ["btc_int_fnc_ask_var", 2];
		}, 1, []] call CBA_fnc_addPerFrameHandler;

		_mapOnDraw = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", btc_debug_fnc_marker];

		btc_debug_namespace setVariable ["btc_debug_perFrameHandler", _perFrameHandler];
		btc_debug_namespace setVariable ["btc_debug_mapOnDraw", _mapOnDraw];
	}] call CBA_fnc_waitUntilAndExecute;

} else {
	btc_debug = false; btc_debug_log = false;
	hint "Debug mode off";
	player allowDamage true;

	private _mapSingleClick = btc_debug_namespace getVariable ["btc_debug_mapSingleClick", -1];
	private _perFrameHandler = btc_debug_namespace getVariable ["btc_debug_perFrameHandler", -1];
	private _mapOnDraw = btc_debug_namespace getVariable ["btc_debug_mapOnDraw", -1];
	
	removeMissionEventHandler ["MapSingleClick", _mapSingleClick];
	if(!([_perFrameHandler] call CBA_fnc_removePerFrameHandler)) then {
		[format["Couldn't remove a CBA_perFrameHandler"],__FILE__, nil, true] call btc_debug_fnc_message;
	};
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", _mapOnDraw];

	btc_debug_graph = false; //Remove graph as PFH handling count of units is removed
};