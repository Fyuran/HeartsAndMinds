#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_check

Description:
    Constantly check if player is around by calling btc_ied_fnc_checkLoop. If yes, trigger the explosion.

Parameters:
    _city - City where IED has been created. [Object]

Returns:

Examples:
    (begin example)
        [_city, _ieds] call btc_ied_fnc_check;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_city", objNull, [objNull]]
];

private _array = _city getVariable ["ieds", []];
if (_array isEqualTo []) exitWith {};

private _ieds = _array apply {_x call FUNC(ied,create)};

#ifdef BTC_DEBUG_IED
[["%1: IED CHECK OF CITY ID %2", __FILE_NAME__, _city getVariable "id"], 2, "ied"] call FUNC(debug,message);
#endif
private _ieds_check = _ieds select {(_x select 2) isNotEqualTo objNull};

[_city, _ieds, _ieds_check] call FUNC(ied,checkLoop);
