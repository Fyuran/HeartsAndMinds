/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_delete
	
	Description:
	    Deletes JSON file.
	
	Parameters:
	    _path - where the file is located. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_delete;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_path", "", [""]]
];

private _returnString = ("btc_ArmaToJSON" callExtension ["deleteData", [_path]]) select 0;
[[_returnString, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;

[] call btc_json_fnc_fileviewer_r_server;