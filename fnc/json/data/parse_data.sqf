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
	["_rawData", [], [[]]]
];

private _innerHash = createHashMap;
if(_rawData isNotEqualTo [""]) then {
	private _rawData = _rawData joinString "";
	_rawData = _rawData regexReplace ["\\\\", "\"];
	_rawData = parseSimpleArray _rawData;

	_rawData apply {
		private _in = createHashMapFromArray (_x select 1);
		_innerHash set [_x select 0, _in];
	};
};

btc_JSON set [_category, _innerHash];