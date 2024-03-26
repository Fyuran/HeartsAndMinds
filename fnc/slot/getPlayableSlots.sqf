
/* ----------------------------------------------------------------------------
Function: btc_slot_fnc_getPlayableSlots

Description:
    Retrieves all playable slots from mission.sqm

Parameters:
    _unit - Unit. [Object]

Returns:

Examples:
    (begin example)
        [] call btc_slot_fnc_getPlayableSlots;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
if(isNil "btc_db_missionPlayerSlots") exitWith {
    [format["btc_db_missionPlayerSlots has not been defined in mission.sqf"], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

private _cfg = (missionconfigfile >> "mission" >> "Mission" >> "Entities");
if(!isClass _cfg) exitWith {
    [format["mission.sqm was not included in description.ext"], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};
private _subClasses = _cfg call BIS_fnc_getCfgSubClasses;
private _slots = [];

_subClasses apply {
    private _isPlayable = getNumber(_cfg >> _x >> "Entities" >> "Item0" >> "Attributes" >> "isPlayable") isEqualTo 1;
    if(_isPlayable) then {
        _slots pushBack _x;
    };
};

_slots = [_slots, [], {getNumber(_cfg >> _x >> "Entities" >> "Item0" >> "id")}, "ASCEND"] call BIS_fnc_sortBy;
_slots apply {
    private _pos = (getArray(_cfg >> _x >> "Entities" >> "Item0" >> "PositionInfo" >> "position"));
    btc_db_missionPlayerSlots pushBack [_pos#0, _pos#2, 0]; //cfg doesn't use right-hand coords so Y and Z are swapped
};