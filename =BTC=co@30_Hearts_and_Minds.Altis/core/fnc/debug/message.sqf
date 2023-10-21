
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_message

Description:
    Fill me when you edit me !

Parameters:
    _message - [String]
    _folder - [String]
    _type - [Array]

Returns:

Examples:
    (begin example)
        _result = [] call btc_debug_fnc_message;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_message", "BTC Message debug", [""]],
    ["_folder", __FILE__, [""]],
    ["_type", [], [[]]],
    ["_isError", false, [false]]
];

_type params[
    ["_useChat", false, [true]],
    ["_useLog", true, [true]],
    ["_global", true, [true]]
];

private _startPosition = _folder find "fnc";
if (_startPosition isEqualTo -1) then {
    _startPosition = (_folder find worldName) + count worldName;
};

_folder = _folder select [_startPosition, (_folder find ".sqf") - _startPosition];
if(!_isError) then {
    [_message, _folder, _type] call CBA_fnc_debug;
} else {
    ["%2: %1", _message, _folder] remoteExecCall ["BIS_fnc_error"];
    [_message, _folder, [false, true, true]] call CBA_fnc_debug;
};

