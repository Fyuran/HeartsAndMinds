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
if(btc_debug) then {
	[format["Refreshing JSON File viewer list with: %1(fileviewer:%2)", _this, _fileviewer], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
};

//refresh listBox items
if(!isNull _fileviewer) then {
	private _listBox = _fileviewer displayCtrl 1500;
	lbClear _listBox;
	private _lbRows = _files apply {_listBox lbAdd _x};
};



