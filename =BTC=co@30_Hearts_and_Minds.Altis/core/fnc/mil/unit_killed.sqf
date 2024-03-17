
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_unit_killed

Description:
    Fill me when you edit me !

Parameters:
    _unit - Object the event handler is assigned to. [Object]
    _killer - Object that killed the unit. Contains the unit itself in case of collisions. [Object]
    _instigator - Person who pulled the trigger. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_mil_fnc_unit_killed;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params ["_unit", "_causeOfDeath", "_killer", "_instigator"];

private _unitSide = side group _unit;
if ((_unitSide isNotEqualTo btc_enemy_side) && (_unitSide isNotEqualTo btc_player_side)) exitWith {hint format ["%1", _this]};

if (_unitSide isEqualTo btc_enemy_side) then {
    if (random 100 > btc_info_intel_chance) then {
        _unit setVariable ["intel", true];
    };
};

if (isPlayer _instigator) then {
    private _isSurrendering = _unit getVariable ["ace_captives_isSurrendering", false];
    if(_isSurrendering) then {
        [_instigator, _CAPTIVE_KILLED_] call btc_rep_fnc_change;
    } else {
        if((_unitSide isEqualTo btc_player_side) && (!isPlayer _unit)) then {  
            [_instigator, _FRIENDLY_KILLED_] call btc_rep_fnc_change;
        } else {
            [_instigator, _HOSTILE_KILLED_] call btc_rep_fnc_change;
        };
    };
};
