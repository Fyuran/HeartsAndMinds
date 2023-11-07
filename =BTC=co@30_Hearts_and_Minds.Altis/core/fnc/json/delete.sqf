/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_delete
	
	Description:
	    Saves simpler data into JSON.
	
	Parameters:
	    _name - name of the game saved. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_delete;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params[
	["_name", btc_db_saveName, [""]]
];

private _returnString = ("btc_ArmaToJSON" callExtension ["deleteData", [format["btc_hm_%1", _name]]]) select 0;
[[_returnString, 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;