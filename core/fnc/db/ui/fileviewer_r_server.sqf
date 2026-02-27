#include "..\..\script_macros.hpp"
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

private _files = ("btc_ArmaToJSON" callExtension ["retrieveList", []]) select 0;
if(_files isEqualTo "" or isNil "_files") exitWith {
	[["%1: No valid JSON files found", __FILE_NAME__], 6, "json/ui"] call FUNC(debug,message);
};
_files = parseSimpleArray _files;

#ifdef BTC_DEBUG_JSON
[["%1: Broadcasting %2 to clientID: %3", __FILE_NAME__, _files, remoteExecutedOwner], 2, "json/ui"] call FUNC(debug,message);
#endif
[_files] remoteExecCall ["btc_json_fnc_fileviewer_r_client", remoteExecutedOwner];