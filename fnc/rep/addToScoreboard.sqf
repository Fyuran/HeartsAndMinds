
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_addToScoreboard

Description:
    Adds or increments specified record to scoreboard

Parameters:


Returns:

Examples:
    (begin example)
        [] call btc_rep_fnc_addToScoreboard;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
    ["_key", "", [""]],
    ["_numb", 1, [123]],
    ["_instigator", objNull, [objNull]]
];

private _value = btc_scoreboard getOrDefault [_key, 0, true];
btc_scoreboard set [_key, _value + _numb];

private _rep_status = switch(true) do { 
    case (btc_global_reputation <= btc_rep_level_veryLow): {"Hostile"}; 
    case (btc_global_reputation <= btc_rep_level_low): {"Hated"}; 
    case (btc_global_reputation <= btc_rep_level_normal): {"Neutral"}; 
    case (btc_global_reputation >= btc_rep_level_high): {"Friendly"}; 
    default {"Unknown"}; 
};
btc_scoreboard set ["Reputation status", _rep_status];

if(!isNull _instigator) then {
    private _scoreboard = _instigator getVariable["btc_scoreboard", createHashMap];
    private _playerValue = _scoreboard getOrDefault[_key, 0];
    _scoreboard set [_key,  _playerValue + _numb];
    _instigator setVariable["btc_scoreboard", _scoreboard]; //getData is server side, so no broadcasting necessary

    if(btc_debug) then {
        [format["adding %1 to %2 for %3", _numb, _key, _instigator], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
} else {
    if(btc_debug) then {
        [format["adding %1 to %2", _numb, _key], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
};