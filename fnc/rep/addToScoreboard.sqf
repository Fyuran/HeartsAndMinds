
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

if(!isNull _instigator) then {
    private _uid = getPlayerUID _instigator;
    private _playerHash = btc_slots_serialized getOrDefault[_uid, createHashMap, true];
    private _playerValue = _playerHash getOrDefault[_key, _value];
    _playerHash set [_key,  _playerValue + _numb];

    if(btc_debug) then {
        [format["adding %1 to %2 for %3", _numb, _key, _instigator], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
} else {
    if(btc_debug) then {
        [format["adding %1 to %2", _numb, _key], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
};