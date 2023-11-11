/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_copy
	
	Description:
	    load database from HEM.JSON
	
	Parameters:
	    _path - where the file is located. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_copy;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_path", "", [""]]
];

private _returnString = ("btc_ArmaToJSON" callExtension ["copyData", [_path]]) select 0;
[[_returnString, 1, [0, 0.5, 0.5, 1]]] call btc_fnc_show_custom_hint;

[] call btc_json_fnc_fileviewer_r_server;