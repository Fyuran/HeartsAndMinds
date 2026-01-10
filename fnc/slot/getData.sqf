#include "..\script_macros.hpp"
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
	#ifdef BTC_DEBUG_SLOT
    [["%1: Called in a non suspended envinronment", __FILE_NAME__], 6, "slot"] call btc_debug_fnc_message;
	#endif
};

if(_uid isEqualTo "") exitWith {
    #ifdef BTC_DEBUG_SLOT
    [["%1: invalid _uid", __FILE_NAME__], 6, "slot"] call btc_debug_fnc_message;
    #endif
};

if(remoteExecutedOwner isNotEqualTo 0) then { //relay back data to requesting client
    private _retries = 0;
    waitUntil{
        _retries = _retries + 1; 
        sleep 1;
        btc_hasLoadedDB || _retries >= 10
    };

    if(_retries >= 10) exitWith {
        #ifdef BTC_DEBUG_SLOT
        private _unit = _uid call BIS_fnc_getUnitByUID;
        [["%1: %2(%3) failed to retrieve data after %4 retries", __FILE_NAME__, name _unit, _uid, _retries], 6, "slot"] call btc_debug_fnc_message;
        #endif
        };
    
    private _slot_data = btc_slots_serialized getOrDefault [_uid, createHashMap];
    ["btc_slot_loadPlayer", _slot_data, remoteExecutedOwner] call CBA_fnc_ownerEvent;

        #ifdef BTC_DEBUG_SLOT
        private _unit = _uid call BIS_fnc_getUnitByUID;
        [["%1: %2(%3) retrieving data", __FILE_NAME__, name _unit, _uid], 2, "slot"] call btc_debug_fnc_message;
        #endif
};