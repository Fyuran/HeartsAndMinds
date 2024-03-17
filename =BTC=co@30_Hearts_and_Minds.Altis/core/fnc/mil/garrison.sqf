
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
if(isNull _building) exitWith {["Invalid _building param", __FILE__, [false, true, true], true] call btc_debug_fnc_message;};
private _boundingSphere = sizeOf typeOf _building;

private _buildingPositions = _building buildingPos -1;
private _buildingPositionCount = (count _buildingPositions);
if (_buildingPositionCount <= 0) exitWith {
	if(btc_debug) then {
		[format["No suitable positions found for garrison at %1", _pos], __FILE__, [false, true, true]] call btc_debug_fnc_message;
	};
};

[_enemy_side, _building, _buildingPositions, _buildingPositionCount, _type_units] spawn {
	params ["_enemy_side", "_building", "_buildingPositions", "_buildingPositionCount", "_type_units"];

	private _group = createGroup _enemy_side;
	private _staticWeapons = _building nearObjects ["StaticWeapon", 50] select {locked _x != 2 && {_x emptyPositions "gunner" > 0}};

	for "_i" from 1 to _buildingPositionCount do {
		private _pos = _buildingPositions select (count (units _group));
		private _unit = _group createUnit [selectRandom _type_units, _pos, [], 0, "CAN_COLLIDE"];
		
		waitUntil {unitReady _unit};
		// This command causes AI to repeatedly attempt to crouch when engaged
		_unit setUnitPos "UP";
		doStop _unit;
		_unit disableAI "PATH";

		if (count _staticWeapons > 0) then {
			_unit moveInGunner (_staticWeapons select 0);
			_unit assignAsGunner (_staticWeapons deleteAt 0);
		};
		sleep 0.5;
		[objNull, _unit] call ace_medical_treatment_fnc_fullHeal; //units will sometimes spawn and get damaged
	};

	_building setVariable ["btc_mil_garrison", units _group];
	(leader _group) setVariable ["acex_headless_blacklist", true];
};



