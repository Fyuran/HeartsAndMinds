/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_delete_file
	
	Description:
	    Deletes JSON file.
	
	Parameters:
	    _path - where the file is located. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_delete_file;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_path", "", [""]],
	["_custom_hint", "", [""]]
];

if (btc_debug) then {
	[format ["Deleting JSON file for %1", _path], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

private _returnString = ("btc_ArmaToJSON" callExtension ["deleteFile", [_path]]) select 0;

if(_custom_hint isEqualTo "") then {
	[[_returnString, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
} else {
	[[_custom_hint, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
};

[] call btc_json_fnc_fileviewer_r_server;