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
#define _ERROR_ -1
#define _FILE_EXISTS_ 200
#define _FILE_COPIED_ 201
#define _DATA_EXISTS_ 202
#define _FILE_DELETED_ 203
#define _FILE_RENAMED_ 204
#define _LIST_RETRIEVED_ 205

private _saveFile = profileNamespace getVariable [format["btc_hm_%1_saveFile", worldName], ""];
private _JSON = createHashMap;
if(_saveFile isEqualTo "") exitWith {
	[format["No JSON file found or loaded"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

private _category = [worldName, "player_markers", "cities_status", "array_ho", "explosives",
"array_cache", "fobs", "fobs_ruins", "array_obj", "array_fob_log_supplies", "tags_properties", "respawn_tickets", "deadPlayers", "slots_serialized", "array_veh"];


_category apply {
	private _rawData = [];
	private _return = "btc_ArmaToJSON" callExtension ["getData", [_saveFile, _x, "-1"]]; //retrieve in how many pieces data has been split with -1 as index
	_return params ["_result", "_returnCode", "_errorCode"];

	if (btc_debug) then {
		[format ["Loading JSON data for %1[%2]: %3", _saveFile, _x, _return], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
	};

	if(_returnCode isEqualTo _DATA_EXISTS_) then {
		private _result = parseSimpleArray _result;
		_pieces = _result param[0, -1, [0]];
		if(_pieces <= -1) exitWith {
			[format["for %1, bad _pieces var, should be >= 1", _result], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
		};
		for "_i" from 0 to (_pieces - 1) do {
			("btc_ArmaToJSON" callExtension ["getData", [_saveFile, _x, str _i]]) params ["_rawDataPiece", "_returnCode"];
			if (btc_debug) then {
				[format ["Loading JSON Data returned for %1(%2/%3)", _x, _i + 1, _pieces], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
			};
			if(_returnCode isEqualTo _DATA_EXISTS_) then { //if data piece exists
				_rawData pushBack _rawDataPiece;
			};
		};

		[_x, _rawData, _JSON] call btc_json_fnc_parse_data;
	};

	
};

_JSON