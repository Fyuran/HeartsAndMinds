/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_load_new_file
	
	Description:
	    Changes profileNamespace JSON save file name to allow loading of new file on preInit
	
	Parameters:
	    _path - where the file is located. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_load_new_file;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_path", "", [""]],
	["_custom_hint", "", [""]]
];

if (btc_debug) then {
	[format ["btc_hm_%1_saveFile JSON set to %2", worldName, _path], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

profileNamespace setVariable [format["btc_hm_%1_saveFile", worldName], _path];

if(_custom_hint isEqualTo "") then {
	[[format["Restart mission to load %1", _path], 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;
} else {
	[[_custom_hint, 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;
};