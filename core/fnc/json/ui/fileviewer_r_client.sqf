#include "..\..\script_macros.hpp"
	/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_fileviewer_r_client
	
	Description:
	    Refreshes lbList called by Server
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_fileviewer_r_client;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
disableSerialization;
params[
	["_files", [], [[]]]
];

private _fileviewer = findDisplay 7001;
#ifdef BTC_DEBUG_JSON
[["%1: Refreshing JSON File viewer list with: %2(fileviewer:%3)", __FILE_NAME__, _this, _fileviewer], 2, "json/ui"] call btc_debug_fnc_message;
#endif
//refresh listBox items
if(!isNull _fileviewer) then {
	private _listBox = _fileviewer displayCtrl 1500;
	lbClear _listBox;
	private _lbRows = _files apply {_listBox lbAdd _x};
	_listBox lbSetCurSel 0; //When a row is removed, lbCurSel will still refer to deleted row
	uiNamespace setVariable ["btc_JSON_fileviewer_textlbCurSel", _listBox lbText 0];
};



