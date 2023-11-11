/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_deserializePlayers
	
	Description:
	    Serialize player slot.
	
	Parameters:
	    _player - Unit. [Object]
	
	Returns:
	
	Examples:
	    (begin example)
	        [allPlayers#0] call btc_json_fnc_deserializePlayers;
	    (end)
	
	Author:
	    BaerMitUmlaut ACE3
	
---------------------------------------------------------------------------- */

[{
	!isNull player
}, {
	params [
		"_pos",
		"_dir",
		"_loadout",
		"_flagTexture",
		"_isContaminated",
		"_state",
		["_field_rations", [], [[]]]
	];
	if (btc_p_autoloadout isEqualTo 0) then {
		player setUnitLoadout _loadout;
	};
	player setPosASL _pos;
	player setDir _dir;
	player forceFlagTexture _flagTexture;

	if (_isContaminated) then {
		player call btc_chem_fnc_damageLoop;
	};

	_field_rations params [["_thirst", 0, [0]], ["_hunger", 0, [0]]];
	player setVariable ["acex_field_rations_thirst", _thirst];
	player setVariable ["acex_field_rations_hunger", _hunger];

	[_state] call btc_json_fnc_deserialize_medical_status;
}, _this] call CBA_fnc_waitUntilAndExecute;