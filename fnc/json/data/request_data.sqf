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
	["_saveFile", "", [""]]
]) exitWith {
	[format["Invalid _saveFile"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

//check if valid data inside JSON exists
("btc_ArmaToJSON" callExtension ["getPieces", [_saveFile]]) params [["_pieces", -1, ["", 123]], "_returnCode", "_errorCode"];
private _piecesExist = (_returnCode == _OK_) && {(_errorCode == _OK_)};
if (btc_debug) then {
	[_pieces, __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};
if(!_piecesExist) exitWith {
	""
};

//Retrieve in how many pieces data has been split
_pieces = parseNumber _pieces;
if(_pieces <= -1) exitWith {
	if (btc_debug) then {
		[format["for %1, bad _pieces var, should be >= 1", _pieces], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
	};
	""
};

//Parse data pieces
private _rawData = "";

for "_i" from 0 to (_pieces - 1) do {
	("btc_ArmaToJSON" callExtension ["getDataPiece", [_saveFile, str _i]]) params [["_piece", "", ["", 123]], "_returnCode", "_errorCode"];
	if (btc_debug) then {
		[format ["Loading JSON Data returned for %1(%2)", _i + 1, _piece], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
	};
	_rawData = _rawData + _piece;
};
//_rawData = _rawData regexReplace ["\\\\", "\"]; //remove trailing slashes from file paths

_rawData;