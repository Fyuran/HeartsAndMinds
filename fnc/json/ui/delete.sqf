#include "..\..\script_macros.hpp"
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

#ifdef BTC_DEBUG_JSON
[["%1: Deleting JSON file for %2", __FILE_NAME__, _path], 2, "json/ui"] call btc_debug_fnc_message;
#endif
private _returnString = ("btc_ArmaToJSON" callExtension ["deleteFile", [_path]]) select 0;

if(_custom_hint isEqualTo "") then {
	[[_returnString, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
} else {
	[[_custom_hint, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
};

[] call btc_json_fnc_fileviewer_r_server;