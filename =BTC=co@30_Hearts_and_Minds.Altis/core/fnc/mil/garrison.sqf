
/* ----------------------------------------------------------------------------
Function: btc_mil_fnc_garrison

Description:
	Adds AI garrisons based on number of available building positions

Parameters:
    _structure -
	_group -

Returns:

Examples:
    (begin example)
        [player] call btc_mil_fnc_garrison;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_building", objNull, [objNull]],
	["_enemy_side", btc_enemy_side, [east]],
	["_type_units", btc_type_units, [[]]]
];
if(isNull _building) exitWith {["Invalid _building param", __FILE__, [false, true, false], true] call btc_debug_fnc_message;};

private _buildingPositions = _building buildingPos -1;
if (count _buildingPositions <= 0) exitWith {
	if(btc_debug) then {
		[format["No suitable positions found for garrison at %1", _pos], __FILE__, [false, true, false]] call btc_debug_fnc_message;
	};
};

private _group = createGroup _enemy_side;
//_group enableAttack false;

for "_i" from 1 to (count _buildingPositions) do {
	btc_delay_time = btc_delay_time + btc_delay_unit;
	[{
		btc_delay_time = btc_delay_time - btc_delay_unit;

		params [
			["_group", grpNull, [grpNull]],
			["_unit_type", "", [""]],
			["_buildingPositions", [], [[]]],
			["_building", objNull, [objNull]]
		];
		private _pos = _buildingPositions select (count (units _group));
		private _unit = _group createUnit [_unit_type, _pos, [], 0, "CAN_COLLIDE"];

		[_unit] joinSilent _group;
		doStop _unit;
		_unit setUnitPos "UP";
		_unit setDir (_building getDir _unit);

	}, [_group, selectRandom _type_units, _buildingPositions, _building], btc_delay_time - 0.01] call CBA_fnc_waitAndExecute;
};

(leader _group) setVariable ["acex_headless_blacklist", true];