
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_loadCargo

Description:
    Loads cargo for vehicle

Parameters:
    _object - vehicles to which load cargo to. [Object]
    _hash - _cargo hash passed by btc_veh_fnc_getData

Returns:

Examples:
    (begin example)
        _result = [_object, createHashMap] call btc_veh_fnc_loadCargo;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
	["_object", objNull, [objNull]],
	["_hash", createHashMap, [createHashMap]]
];

if(_hash isEqualTo createHashMap) exitWith {};
if(!alive _object) exitWith {
	if (btc_debug) then {
		[format ["_object is dead or null"], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
	};
};
/*
[
	itemCargo
	ace_containers
	ace_cargo_customName
	containers
	magazineCargo
	weaponCargo
	backpackCargo
]
*/
(values _hash) params ((keys _hash) apply {"_" + _x});

//remove default stuff
clearWeaponCargoGlobal _object;
clearItemCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearBackpackCargoGlobal _object;

//bis items
_itemCargo apply {
	_object addItemCargoGlobal[_x, _y];
};
_magazineCargo apply {
	_object addMagazineCargoGlobal[_x, _y];
};
_weaponCargo apply {
	_object addWeaponCargoGlobal[_x, _y];
};
_backpackCargo apply {
	_object addBackpackCargoGlobal[_x, _y];
};
_object setVariable ["ace_cargo_customName", _ace_cargo_customName, true];

//bis inventory
if(_containers isNotEqualTo []) then {
	private _containerReferences = everyContainer _object; //returns [["CLASS", REF TO CONTAINER]]
	_containers apply {
		_x params[
			["_index", "", [""]], 
			["_content", createHashMap, [createHashMap]]
		];
		_content apply {
			private _class = _x;
			private _filteredRefs = (_containerReferences select {(_x#0) isEqualTo _class}) apply {_x#1};
			_filteredRefs resize (count((keys _content) select {_x isEqualTo _class})); //adjust so that we don't apply data to other items of the same class
			{
				[_x, _y] call btc_veh_fnc_loadCargo;		
			}forEach _filteredRefs;
		};

	};
};

if(_ace_containers isNotEqualTo []) then {
	[{ace_common_settingsInitFinished}, {
		//ace cargo
		private _loaded = _object getVariable ["ace_cargo_loaded", []];
		if (_loaded isNotEqualTo []) then {
			// Delete all cargo
			_loaded apply {
				if (_x isEqualType objNull) then {
					detach _x;
					deleteVehicle _x;
				};
			};
		};
		// Reset loaded list
		_object setVariable ["ace_cargo_loaded", [], true];
		
			_ace_containers apply {
				_x params[
					["_index", "", [""]], 
					["_content", createHashMap, [createHashMap]]
				];

				_content apply {
					private _class = _x;
					if([_class, _object, true] call ace_cargo_fnc_canLoadItemIn) then {
						private _ace_cargo = createVehicle [_class, [0,0,0], [], 0, "CAN_COLLIDE"];
						[_ace_cargo, _object, true] call ace_cargo_fnc_loadItem;
						[_ace_cargo, _y] call btc_veh_fnc_loadCargo;
					};
				};
			};
		
	}, [_object, _ace_containers], 30] call CBA_fnc_waitUntilAndExecute;
};

