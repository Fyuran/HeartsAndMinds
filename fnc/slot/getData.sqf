
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_getData

Description:
    Server replies with requested player data if it exists

Parameters:

Returns:

Examples:
    (begin example)
        [getPlayerUID player] spawn btc_slot_fnc_getData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_uid", "", [""]]
];

if(!canSuspend) exitWith {
	if(btc_debug) then {
		["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
	};
};

if(_uid isEqualTo "") exitWith {
    if(btc_debug) then {
        ["invalid _uid", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
};

if(remoteExecutedOwner isNotEqualTo 0) then { //relay back data to requesting client
    waitUntil{btc_hasLoadedDB};

    private _slot_data = btc_slots_serialized getOrDefault [_uid, createHashMap];
    ["btc_slot_loadPlayer", _slot_data, remoteExecutedOwner] call CBA_fnc_ownerEvent;

    if(btc_debug) then {
        private _unit = _uid call BIS_fnc_getUnitByUID;
        [format ["%1(%2) retrieving data", name _unit, _uid], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
    };
};