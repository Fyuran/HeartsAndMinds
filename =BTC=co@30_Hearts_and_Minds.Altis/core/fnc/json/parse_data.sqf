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
	
	Author:
	
---------------------------------------------------------------------------- */
params[ 
	["_jsonData", btc_JSON, [[]]] 
];


private _mainHash = createHashMap;

_jsonData apply {
	_x params [
		["_function", [], ["",[]]], 
		["_data", [], ["",[]]]
	];
	// format will be first: [ "main_key", "secondary_key"]
	// second: "data"
	_function = parseSimpleArray _function;
	_function params [        
		["_main_key", "", [""]],  //btc_hm_cities, btc_hm_markers...
		["_secondary_key", "", [""]] //"Panochori", "Mine"...
	];

	private _thirdHash = [_data, 2] call CBA_fnc_parseJSON;
	if(isNil "_thirdHash") exitWith {
		[format["CBA_fnc_parseJSON failed to parse %1", _this], __FILE__, [btc_debug, true, false], true] call btc_debug_fnc_message;
	};

	//adjust keys so they can be used for params
	private _adjustedThirdHash = createHashMap;
	_thirdHash apply {_adjustedThirdHash set ["_" + _x, _y]};

	if (btc_debug) then {
		[format["PARSING: %1,%2", _function, _adjustedThirdHash], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
	};

	//Assign or merge all hashes
	
	private _firstHash = _mainHash getOrDefault [_main_key, createHashMap];
	private _secondHash = _firstHash getOrDefault [_secondary_key, createHashMap];

	_secondHash merge _adjustedThirdHash;

	_firstHash set [_secondary_key, _secondHash];
	_mainHash set [_main_key, _firstHash];
};

btc_JSON_data = _mainHash;