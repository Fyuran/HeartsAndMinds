
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_replenishGarrison

Description:
    Manages garrison replenishment.

Parameters:
    _to - the ruins object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fob_fnc_replenishGarrison;
    (end)

Author:
     Fyuran

---------------------------------------------------------------------------- */
params[
    ["_building", objNull, [objNull]],
    ["_side", btc_enemy_side, [east]],
    ["_type_units", btc_type_units, [[]]],
    ["_outsideOnly", false, [true]]
];
_buildingPos = _building getVariable ["btc_mil_garrison_pos", []];
if(_buildingPos isEqualTo []) exitWith {
    if(btc_debug) then {
        [format ["%1(%2) has no positions available", _building, getPosASL _building], __FILE__, [btc_debug, btc_debug_log], true] call btc_debug_fnc_message;
    };
};

_garrisonUnits = (units(_building getVariable["btc_mil_garrison_group", []])) select {alive _x};
_emptyPos = [];
if(_garrisonUnits isEqualTo []) then {
    _this call btc_garrison_fnc_spawn; 
} else {
    _buildingPos apply {
        _soldiers = _x nearEntities ["Man", 1];
        _soldiers = _soldiers select {alive _x && {!isPlayer _x}};
    };
};