/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_load
	
	Description:
	    load database from JSON
	
	Parameters:
	    _name - name of the saved game. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_load;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
#define MMAPGET btc_JSON_data get format["btc_hm_%1", _name]
#define MAPGET(ARG) btc_JSON_data get format["btc_hm_%1_" + ARG, _name]

params [
	["_name", btc_db_saveName, [""]]
];

[{!(isNil "btc_JSON_data")}, {
params[
	["_name", btc_db_saveName, [""]]
];
[["Loading Data", 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;

// METADATA
private _metadata = ((MMAPGET) get "metadata");
(values _metadata) params (keys _metadata);
setDate _btc_hm_Altis_date;
btc_global_reputation = _btc_hm_Altis_rep;

// CITIES
private _cities = (MAPGET("cities"));
if (_cities isNotEqualTo createHashMap) then {
	_cities apply {
		(values _y) params (keys _y);// iterate through cities' data

		private _city = btc_city_all get _id;
	
		_city setVariable ["initialized", _initialized];
		_city setVariable ["spawn_more", _spawn_more];
		_city setVariable ["occupied", _occupied];
		_city setVariable ["data_units", _data_units];
		_city setVariable ["has_ho", _has_ho];
		_city setVariable ["ho_units_spawned", _ho_units_spawned];
		_city setVariable ["ieds", _ieds];
		_city setVariable ["has_suicider", _has_suicider];
		_city setVariable ["btc_rep_civKilled", _civKilled];

		if (btc_debug) then {
			private _marker = _city getVariable ["marker", ""];
			if (_city getVariable ["occupied", false]) then {
				_marker setMarkerColor "colorRed";
			} else {
				_marker setMarkerColor "colorGreen";
			};
			if (btc_debug_log) then {
				[format ["_city = %1 at %2", _name, getPosASL _city], __FILE__, [false]] call btc_debug_fnc_message;
			};
		};
	};
};
// HIDEOUTS
private _ho = (MAPGET("ho"));
if (_ho isNotEqualTo createHashMap) then {
	_ho apply {
		(values _y) params (keys _y);
		[_pos, _id_hideout, _rinf_time, _cap_time, _assigned_to, _markers_saved] call btc_hideout_fnc_create;
	};
};
private _select_ho = (btc_hideouts apply {
	_x getVariable "id"
}) find _btc_hm_Altis_ho_sel;
if (_select_ho isEqualTo - 1) then {
	btc_hq = objNull;
} else {
	btc_hq = btc_hideouts select _select_ho;
};

if (btc_hideouts isEqualTo []) then {
	[] spawn btc_fnc_final_phase;
};

// CACHE
private _cache = (MAPGET("cache"));
if (_cache isNotEqualTo createHashMap) then {
	_cache apply {
		(values _y) params (keys _y);
		btc_cache_pos = _cache_pos;
		btc_cache_n = _cache_n;
		btc_cache_info = _cache_info;

		[_cache_pos, btc_p_chem, [1, 0] select _isChem] call btc_cache_fnc_create;
		btc_cache_obj setVariable ["btc_cache_unitsSpawned", _cache_unitsSpawned];

		if (btc_debug_log) then {
			[format ["_cache = %1 at %2", _cache_n, _cache_pos], __FILE__, [false]] call btc_debug_fnc_message;
		};

		btc_cache_markers = [];
		_cache_markers apply {
			_x params ["_pos", "_marker_name"];

			[_pos, 0, _marker_name] call btc_info_fnc_cacheMarker;
		};

		btc_cache_pictures = _cache_pictures;
		{
			(btc_cache_pictures select 2) pushBack ([
				_x,
				btc_cache_n,
				btc_cache_pictures select 1 select _forEachindex
			] remoteExecCall ["btc_info_fnc_cachePicture", [0, -2] select isDedicated, true]);
		} forEach (btc_cache_pictures select 0);
	};
};

// FOBS
private _fobs = (MAPGET("fobs"));
if (_fobs isNotEqualTo createHashMap) then {
	_fobs apply {
		(values _y) params (keys _y);
		[_pos, _direction, _name] call btc_fob_fnc_create_s;
		if (btc_debug_log) then {
			[format ["_fob = %1 at %2", _name, _pos], __FILE__, [false]] call btc_debug_fnc_message;
		};
	};
};

// OBJECTS
private _objs = (MAPGET("objs"));
if (_objs isNotEqualTo createHashMap) then {
	[{
		// Can't use ace_cargo for objects created during first frame.
		_this apply {
			(values _y) params (keys _y);

			[[_type, _pos, _direction, "",
				_cargo, _inventory, _vectorPos,
				_isChem, _dogtagDataTaken, _flagTexture,
			_turretMagazines, _customName, tagTexture, _properties]] call btc_db_fnc_loadObjectStatus;

			if (btc_debug_log) then {
				[format ["_obj = %1 at %2", _type, _pos], __FILE__, [false]] call btc_debug_fnc_message;
			};
		};
	}, _objs] call CBA_fnc_execNextFrame;
};

// VEHICLES
private _vehs = (MAPGET("vehs"));
if (_vehs isNotEqualTo createHashMap) then {
	(getMissionLayerEntities "btc_vehicles" select 0) apply {
		deleteVehicle _x
	};
	if !(isNil "btc_vehicles") then {
		btc_vehicles apply {
			deleteVehicle _x
		};
		btc_vehicles = [];
	};

	[{
		// Can't be executed just after because we can't delete and spawn vehicle during the same frame.
		_this apply {
			(values _y) params (keys _y);

			private _veh = [
				_type, _pos, _direction, _fuel,
				_vectorPos, _turretMagazines,
				_EDENinventory, _allHitPointsDamage, _flagTexture,
			_tagTexture, _properties] call btc_json_fnc_createVehicle;

			if (btc_debug_log) then {
				[format ["_veh = %1 at %2", _type, _pos], __FILE__, [false]] call btc_debug_fnc_message;
			};

			if !(alive _veh) then {
				[_veh, objNull, objNull, nil, false] call btc_veh_fnc_killed;
			};
		};
	}, _vehs] call CBA_fnc_execNextFrame;
};

// PLAYERS
private _players = (MAPGET("slotsSerialized"));
if (_players isNotEqualTo createHashMap) then {
	[{
		_this apply {
			(values _y) params (keys _y);

			[_pos, _direction, _loadout,
				_ForcedFlagTexture, _chem_contaminated, _medical_status,
					_acex_field_rations] remoteExecCall ["btc_json_fnc_deserialize_players", _uid call BIS_fnc_getUnitByUID];

			if (btc_debug_log) then {
				[format ["_player = %1 at %2", _uid, _pos], __FILE__, [false]] call btc_debug_fnc_message;
			};
		};

		//need to sanitize keys with '_' in front that were used by btc_json_fnc_load params
		_this apply {
			private _fixed_hash = ((keys _y) apply {_x trim["_", 1]}) createHashMapFromArray (values _y);
			_this deleteAt _x;
			_this set [_x, _fixed_hash];
		};

	}, _players] call CBA_fnc_execNextFrame; // Need to wait for vehicle creation

};

// MARKERS
private _markers = (MAPGET("markers"));
if (_markers isNotEqualTo createHashMap) then {
	{
		(values _y) params (keys _y);

		private _marker = createMarker [format ["_USER_DEFINED #0/%1/%2", _forEachindex, _markerChannel], _markerPos, _markerChannel];
		_marker setMarkerText _markerText;
		_marker setMarkerColor _markerColor;
		_marker setMarkerType _markerType;
		_marker setMarkerSize _markerSize;
		_marker setMarkerAlpha _markerAlpha;
		_marker setMarkerBrush _markerBrush;
		_marker setMarkerDir _markerDir;

		if (btc_debug_log) then {
			[format ["_marker = %1 at %2[%3]", _markerText, _markerPos], __FILE__, [false]] call btc_debug_fnc_message;
		};

		_marker setMarkerShape _markerShape;
		if (_markerPolyline isNotEqualTo []) then {
			_marker setMarkerPolyline _markerPolyline;
		};
	} forEach _markers;
};

[["Database loaded", 1, [0, 1, 0, 1]]] call btc_fnc_show_custom_hint;

}, _this] call CBA_fnc_waitUntilAndExecute;

