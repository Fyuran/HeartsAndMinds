#include "..\..\script_macros.hpp"
/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_rename_file
	
	Description:
	    Renames JSON file
	
	Parameters:
	    _path - where the file is located. [String]
		_name - new file name [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_rename_file;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_path", "", [""]],
	["_name", "", [""]],
	["_custom_hint", "", [""]]
];

#ifdef BTC_DEBUG_JSON
[["%1: Renaming JSON file for %2 to %3", __FILE_NAME__, _path, _name], 2, "json/ui"] call FUNC(debug,message);
#endif
private _returnString = ("btc_ArmaToJSON" callExtension ["renameFile", [_path, _name]]) select 0;

if(_custom_hint isEqualTo "") then {
	[[format["%1 changed to %2", _path, _name], 1, [1,0.27,0,1]]] call FUNC(common,show_custom_hint);
} else {
	[[_custom_hint, 1, [1,0.27,0,1]]] call FUNC(common,show_custom_hint);
};

[] call FUNC(db,fileviewer_r_server);