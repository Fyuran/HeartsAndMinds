#include "..\script_macros.hpp"
#define __CHAT__ 1
#define __LOGS__ 2
#define __ERROR__ 4
#define __GLOBAL__ 8
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_message

Description:
    Reports diagnostics information to rpt and user screen

Parameters:
    _message - [String]
    _mode - [Array]
    _file - [String]

Returns:

Examples:
    (begin example)
        [["Hello World"], 1, "debug"] call btc_debug_fnc_message;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_message", ["BTC Message debug"], [[""]]],
    ["_mode", 0, [123]],
    ["_title", "DEBUG", [""]]
];
if (mode <= 0 || mode > 15) exitWith {
    #ifdef BTC_DEBUG_DEBUG
    [["%1: invalid mode: %2 passed to btc_debug_fnc_message", __FILE_NAME__, _mode], 6, "debug"] call btc_debug_fnc_message;  
    #endif
};

private _useChat = [_mode, __CHAT__] call BIS_fnc_bitflagsCheck;
private _useLogs = [_mode, __LOGS__] call BIS_fnc_bitflagsCheck;
private _isError = [_mode, __ERROR__] call BIS_fnc_bitflagsCheck;
private _global = [_mode, __GLOBAL__] call BIS_fnc_bitflagsCheck;

if(_title isNotEqualTo "DEBUG") then {
    _title = format["[BTC] (hem-%1)", toUpper _title];
};

if(!_isError) then {
    [format _message, _title, [_useChat, _useLogs, _global]] call CBA_fnc_debug2;
} else { //it's an error message
    ["%1", format _message] remoteExecCall ["BIS_fnc_error", 0];
    [format _message, _title, [_useChat, _useLogs, _global]] call CBA_fnc_debug2;
};

