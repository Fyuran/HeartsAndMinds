[{!isNil "btc_db_load"}, {
	if(btc_db_load isEqualTo 2) then {
		call compileScript ["core\fnc\json\data\addMEH.sqf"];
		private _saveFile = profileNamespace getVariable [format["btc_hm_%1_saveFile", worldName], ""];
		if(_saveFile isEqualTo "") exitWith {
			if (btc_debug) then {
				[format["No JSON file found or loaded"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
			};
		};
		"btc_ArmaToJSON" callExtension ["getData", [_saveFile]];
	};
}, []] call CBA_fnc_waitUntilAndExecute;