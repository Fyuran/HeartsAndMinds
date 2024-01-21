/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_request_data
	
	Description:
	    Parses collected JSON data
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_request_data;
	    (end)
	
	Author: Fyuran
	
---------------------------------------------------------------------------- */

private _saveFile = profileNamespace getVariable [format["btc_hm_%1_saveFile", worldName], ""];
if(_saveFile isEqualTo "") exitWith {
	if (btc_debug) then {
		[format["No JSON file found or loaded"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
	};
};

private _category = [worldName, "cache", "cities", "fobs", "hos", "markers", "objs", "slotsSerialized", "vehs"];
btc_JSON = createHashMap;

_category apply {
	private _rawData = [];
	private _return = "btc_ArmaToJSON" callExtension ["getData", [_saveFile, _x, "-1"]]; //retrieve in how many pieces data has been split with -1 as index
	_return params ["_result", "_returnCode", "_errorCode"];

	_result = parseSimpleArray _result;
	_result params ["_pieces", "_outputMaxSize"];

	if (btc_debug) then {
		[format ["Loading JSON data for %1[%2]: %3", _saveFile, _x, _return], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
	};

	if(_returnCode isEqualTo 202) then {
		for "_i" from 0 to (_pieces - 1) do {
			("btc_ArmaToJSON" callExtension ["getData", [_saveFile, _x, str _i]]) params ["_rawDataPiece", "_returnCode"];
			if (btc_debug) then {
				[format ["Loading JSON Data returned for %1(%2)", _x, _i], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
			};
			if(_returnCode isEqualTo 202) then {
				_rawData pushBack _rawDataPiece;
			};
		};
	};

	[_x, _rawData] call btc_json_fnc_parse_data;
};

btc_JSON