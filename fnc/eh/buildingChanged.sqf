
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_buildingChanged

Description:
    Handles buildingChanged event by relaying fncs.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_buildingChanged;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_from", objNull, [objNull]],
    ["_to", objNull, [objNull]],
    ["_isRuin", false, [false]]
];

if(btc_p_fob_disable_destruction) then {
    if(
        getObjectType _from isEqualTo 8 && //8 TypeVehicle - Some entity added by game
        {_isRuin} &&
        {typeOf _from isEqualTo btc_fob_structure} && 
        {(_from getVariable["FOB_name", ""]) isNotEqualTo ""}
    ) then {
        [_from, _to] call btc_fob_fnc_ruins;
    };
};

_this call btc_rep_fnc_buildingchanged;