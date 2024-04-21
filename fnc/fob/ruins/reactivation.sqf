    
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_reactivation

Description:
    Reactivates destroyed FOB.

Parameters:
    _to - the ruins object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fob_fnc_reactivation;
    (end)

Author:
     Fyuran

---------------------------------------------------------------------------- */
params[
    ["_name", "UNKNOWN", [""]], 
    ["_ruins", objNull, [objNull]]
];
_toRemove = nearestObjects [_ruins, ["WeaponHolderSimulated"], (boundingBox _ruins)#2 + 100, true];
_toRemove append (_toRemove apply {
    _corpse = getCorpse _x;
    if(!isPlayer [_corpse]) then {_corpse} else {};
});
_toRemove call CBA_fnc_deleteEntity;

private _fob = [getPosATL _ruins, getDir _ruins, _name] call btc_fob_fnc_create_s;

btc_fobs_ruins deleteAt _name;
deleteVehicle _ruins;

["WarningDescriptionRepaired", ["", format[
    localize "$STR_BTC_HAM_REP_FOB_REPAIRED",
    _name
]]] call btc_task_fnc_showNotification_s;

_fob