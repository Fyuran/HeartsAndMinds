#include "..\..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_log_resupply_fnc_claim

Description:
    Claims supply object by removing it from city's data

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_resupply_fnc_claim
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!params[
    ["_from", objNull, [objNull]],
    ["_player", objNull, [objNull]]
]) exitWith{
    #ifdef BTC_DEBUG_LOG
    [["%1: bad params", __FILE_NAME__], 6, "log/resupply"] call FUNC(debug,message);
    #endif
};

//remove data about the claimed object
private _city = _from getVariable ["btc_city", objNull];
if(isNull _city) exitWith {
    ["_city is null", __FILE_NAME__, [btc_debug, btc_debug_log, false], true] call FUNC(debug,message);  
};
private _data_supplies = _city getVariable ["data_supplies", []];
private _supplies = _city getVariable ["supplies", []];
private _data = _from getVariable ["btc_resupply_data", []];
private _resources = _from getVariable ["btc_log_resources", -1];

_data_supplies deleteAt (_data_supplies find _data);
_supplies deleteAt (_supplies find _from);
_city setVariable ["data_supplies", _data_supplies];
_city setVariable ["supplies", _supplies];

private _markers = _from getVariable ["btc_info_markers", []];
_markers apply {deleteMarker (_x#0)}; //remove intel markers

private _pos = getPosATL _from;
[_pos, getDir _from, _resources] call FUNC(log_resupply,claimed_create);

[_player, 211] call FUNC(rep,change);

(attachedObjects _from) apply {deleteVehicle _x};
deleteVehicle _from;

#ifdef BTC_DEBUG_LOG
[["%1: claimed supply at %2[%3]", __FILE_NAME__, _city getVariable["id", -1], _pos], 2, "log/resupply"] call FUNC(debug,message);  
#endif