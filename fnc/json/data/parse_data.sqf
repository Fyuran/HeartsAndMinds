/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_parse_data
	
	Description:
	    Parses collected JSON data
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_parse_data;
	    (end)
	
	Author: Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_category", "", [""]],
	["_rawData", [], [[]]],
	["_JSON", createHashMap, [createHashMap]]
];

private _innerHash = createHashMap;
if(_rawData isNotEqualTo [""]) then {
	private _rawData = _rawData joinString "";
	_rawData = _rawData regexReplace ["\\\\", "\"];
	if(btc_debug) then {
		[format ["Parsing JSON data: %1", _rawData], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
	};
	_rawData = parseSimpleArray _rawData;

	_rawData apply {
		private _in = createHashMapFromArray (_x select 1);
		_innerHash set [_x select 0, _in];
	};
};

_JSON set [_category, _innerHash];