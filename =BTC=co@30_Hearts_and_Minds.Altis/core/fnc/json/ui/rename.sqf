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

if (btc_debug) then {
	[format ["Renaming JSON data for %1 to %2", _path, _name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _returnString = ("btc_ArmaToJSON" callExtension ["renameData", [_path, _name]]) select 0;

if(_custom_hint isEqualTo "") then {
	[[format["%1 changed to %2", _path, _name], 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;
} else {
	[[_custom_hint, 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;
};

[] call btc_json_fnc_fileviewer_r_server;