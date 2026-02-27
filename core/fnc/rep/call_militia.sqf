#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_rep_fnc_call_militia

Description:
    Call militia to a position.

Parameters:
    _pos - Position to calling for militia. [Array]

Returns:

Examples:
    (begin example)
        [getPos player] call btc_rep_fnc_call_militia;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_pos", [0, 0, 0], [[]]]
];

btc_rep_militia_called = time;

private _players = if (isMultiplayer) then {playableUnits} else {switchableunits};

//is there an hideout close by?
private _start_pos = objNull;
private _hideouts = btc_hideouts inAreaArray [_pos, 2000, 2000];
if (_hideouts isNotEqualTo []) then {
    _hideouts = _hideouts select {_players inAreaArray [getPosWorld _x, 500, 500] isEqualTo []};
    if (_hideouts isNotEqualTo []) then {_start_pos = selectRandom _hideouts};
};

#ifdef BTC_DEBUG_REP
[["%1: _start_pos : %2 (HIDEOUTS)", __FILE_NAME__, _start_pos], 2, "rep"] call FUNC(debug,message);
#endif
if (_start_pos isEqualTo objNull) then {
    _start_pos = [_pos, values btc_city_all select {
        !(_x getVariable ["active", false]) &&
        _x getVariable ["type", ""] != "NameMarine"
    }, false] call FUNC(common,find_closecity);
};

private _ratio = if (_pos distance _start_pos > 1000) then {0.2} else {0.6};

#ifdef BTC_DEBUG_REP
[["%1: POS : %2 STARTPOS : %3 - RATIO = %4", __FILE_NAME__, _pos, _start_pos, _ratio], 2, "rep"] call FUNC(debug,message);
#endif
if ((random 1) > _ratio) then { //MOT
    [_start_pos, _pos, 1] call FUNC(mil,send);

    #ifdef BTC_DEBUG_REP
    [["%1: MOT %2 POS %3", __FILE_NAME__, _group, _pos], 2, "rep"] call FUNC(debug,message);
    #endif
} else { //INF
    [_start_pos, _pos, 0, "", "WEDGE"] call FUNC(mil,send);

    #ifdef BTC_DEBUG_REP
    [["%1: INF %2", __FILE_NAME__, _group], 2, "rep"] call FUNC(debug,message);
    #endif
};
