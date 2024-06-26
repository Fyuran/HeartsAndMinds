
/* ----------------------------------------------------------------------------
Function: btc_patrol_fnc_WPFOBCheck

Description:
    Performs a check for visibility in case a FOB is within range

Parameters:


Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params[
    ["_group", grpNull, [grpNull]],
    ["_isBoat", false, [false]]
];

if(_isBoat) exitWith {
    if (btc_debug) then {
        [format["P:%1 is on boat, aborting", _group getVariable ["btc_patrol_id", 0]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
    };
};

private _fobs = (btc_fobs select 1);
if(_fobs isEqualTo []) exitWith {
    if (btc_debug) then {
        [format["P:%1 _fobs is empty, aborting", _group getVariable ["btc_patrol_id", 0]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
    };
};
if (btc_debug) then {
    [format["P:%1 FOB WP checking", _group getVariable ["btc_patrol_id", 0]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

private _pos = getPosASL this;
private _fobIndex = _fobs findIf {(_x distance2D _pos) <= (_FOB_SIGHT_RANGE_ + btc_fob_alertRadius)};

if(_fobIndex isNotEqualTo -1) then {
    _fob = _fobs select _fobIndex;
    if(isNull _fob) exitWith {
        if (btc_debug) then {
            [format["P:%1 FOB is Null", _group getVariable ["btc_patrol_id", 0]], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
        };
    };

    [_group, _fob, 100, "PATROL"] call btc_mil_fnc_addWP;

    [{
        (_this select 0) inArea (((_this select 1) getVariable["FOB_Triggers", []]) select 0)
    }, {
        [_EVENT_FOB_ATTACK_, (_this select 1)] call btc_event_fnc_eventManager;
        _fob setVariable ["FOB_Event", true];
    }, [leader _group, _fob]] call CBA_fnc_waitUntilAndExecute;
    
    
    if (btc_debug) then {
        if (!isNil {_group getVariable "btc_patrol_id"}) then {
            private _patrol_id = _group getVariable ["btc_patrol_id", -1];
            format["Patrol_fant_begin_%1", _patrol_id] setMarkerPos getPosASL this;
            deleteMarker format ["Patrol_fant_end_%1", _patrol_id];
            for "_i" from 0 to 1 step 0.2 do {
                deleteMarker format["Patrol_fant_%1_%2", _patrol_id, _i];
            };
            btc_patrols_pos set [_patrol_id, [getMarkerPos format["Patrol_fant_begin_%1", _patrol_id], getPosASL _fob]];
            [format["P:%1 Found fob, redirecting patrol", _patrol_id], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
        };
    };
};