#include "..\..\script_macros.hpp"
/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_request_data
	
	Description:
	    Parses collected JSON data
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_request_data;
	    (end)
	
	Author: Fyuran
	
---------------------------------------------------------------------------- */
#define _ERROR_ -1
#define _OK_ 0

if(!params[
	["_saveFile", "", [""]],
	["_category", "", [""]]
]) exitWith {
	[["%1: Invalid params", __FILE_NAME__], 6, "json/data"] call FUNC(debug,message);
};

//check if valid data inside JSON exists
("btc_ArmaToJSON" callExtension ["getPiecesByCategory", [_saveFile, _category]]) params [["_pieces", -1, ["", 123]], "_returnCode", "_errorCode"];
private _piecesExist = (_returnCode == _OK_) && {(_errorCode == _OK_)};
#ifdef BTC_DEBUG_JSON
[["%1: %2, pieces:%3", __FILE_NAME__, _category, _pieces], 2, "json/data"] call FUNC(debug,message);
#endif
if(!_piecesExist) exitWith {
	""
};

//Retrieve in how many pieces data has been split
_pieces = parseNumber _pieces;
if(_pieces <= -1) exitWith {
	#ifdef BTC_DEBUG_JSON
	[["%1: for %2, bad _pieces var, should be >= 1", __FILE_NAME__, _pieces], 6, "json/data"] call FUNC(debug,message);
	#endif
	""
};

//Parse data pieces
private _rawData = "";

for "_i" from 0 to (_pieces - 1) do {
	("btc_ArmaToJSON" callExtension ["getDataPiece", [_saveFile, str _i]]) params [["_piece", "", ["", 123]], "_returnCode", "_errorCode"];
	#ifdef BTC_DEBUG_JSON
	[["%1: Loading JSON Data returned for %2(%3)", __FILE_NAME__, _category, _piece], 2, "json/data"] call FUNC(debug,message);
	#endif
	_rawData = _rawData + _piece;
};
//_rawData = _rawData regexReplace ["\\\\", "\"]; //remove trailing slashes from file paths

_rawData;