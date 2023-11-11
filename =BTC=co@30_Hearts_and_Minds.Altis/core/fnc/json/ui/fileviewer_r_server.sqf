/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_fileviewer_r_server
	
	Description:
	    Client Broadcast of server held JSON files to refresh list
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_fileviewer_r_server;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
params[
	["_client", 0, [0]]
];

private _files = ("btc_ArmaToJSON" callExtension ["retrieveList", []]) select 0;
_files = parseSimpleArray _files;

if(btc_debug) then {
	[format["Broadcasting %1 to clientID: %2", _files, _this], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

[_files] remoteExecCall ["btc_json_fnc_fileviewer_r_client", _client];