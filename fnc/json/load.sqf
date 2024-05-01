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
#define MAPGET(ARG) btc_JSON getOrDefault [ARG, createHashMap]

params[
	["_name", worldName, [""]]
];
[["Loading Data", 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;

btc_JSON = [] call btc_json_fnc_request_data;
if(btc_JSON isEqualTo createHashMap) exitWith {
	[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_17", 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
};

// METADATA
private _metadata = +(MAPGET(_name));
private _btc_ho_sel = -1;
if (_metadata isNotEqualTo createHashMap) then {
	
	_metadata apply {
		(values _y) params ((keys _y) apply {"_" + _x});
		setDate _date;
		btc_global_reputation = _rep;
		_btc_ho_sel = _ho_sel;
	};

};


// CITIES
private _cities_status = +(MAPGET("cities_status"));
if (_cities_status isNotEqualTo createHashMap) then {
	_cities_status apply {
		(values _y) params ((keys _y) apply {"_" + _x});// iterate through cities' data

		private _city = btc_city_all get _id;

		_city setVariable ["initialized", _initialized];
		_city setVariable ["spawn_more", _spawn_more];
		_city setVariable ["occupied", _occupied];
		_city setVariable ["data_units", _data_units];
		_city setVariable ["has_ho", _has_ho];
		_city setVariable ["ho_units_spawned", _ho_units_spawned];
		_city setVariable ["ieds", _ieds];
		_city setVariable ["has_suicider", _has_suicider];
		_city setVariable ["data_animals", _data_animals];
		_city setVariable ["data_tags", _data_tags];
		_city setVariable ["data_supplies", _data_supplies];
		_city setVariable ["btc_rep_civKilled", _civKilled];

		_data_supplies apply {
			_markers = _x param[3, [], [[]]];
			_markers apply {
				private _marker = createMarkerLocal[_x#0, _x#1];
				_marker setMarkerTypeLocal "hd_unknown";
				_marker setMarkerTextLocal format ["%1m", btc_info_supply_radius];
				_marker setMarkerSizeLocal[0.4, 0.4];
				_marker setMarkerAlphaLocal 0.35;
				_marker setMarkerColor "ColorPink";
			};
		};
		if (btc_debug) then {
			[format ["_city = %1 at %2", _name, getPosASL _city], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
		};
	};
};
// HIDEOUTS
private _array_ho = +(MAPGET("array_ho"));
if (_array_ho isNotEqualTo createHashMap) then {
	_array_ho apply {
		(values _y) params ((keys _y) apply {"_" + _x});
		[_pos, _id_hideout, _rinf_time, _cap_time, _assigned_to, _markers_saved] call btc_hideout_fnc_create;
	};
};
private _select_ho = (btc_hideouts apply {
	_x getVariable "id"
}) find _btc_ho_sel;
if (_select_ho isEqualTo - 1) then {
	btc_hq = objNull;
} else {
	btc_hq = btc_hideouts select _select_ho;
};

if (btc_hideouts isEqualTo []) then {
	[] spawn btc_fnc_final_phase;
};

// CACHE
private _array_cache = +(MAPGET("array_cache"));
if (_array_cache isNotEqualTo createHashMap) then {
	_array_cache apply {
		(values _y) params ((keys _y) apply {"_" + _x});
		btc_cache_pos = _cache_pos;
		btc_cache_n = _cache_n;
		btc_cache_info = _cache_info;

		[_cache_pos, btc_p_chem, [1, 0] select _isChem] call btc_cache_fnc_create;
		btc_cache_obj setVariable ["btc_cache_unitsSpawned", _cache_unitsSpawned];

		if (btc_debug_log) then {
			[format ["_array_cache = %1 at %2", _cache_n, _cache_pos], __FILE__, [false]] call btc_debug_fnc_message;
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
private _fobs = +(MAPGET("fobs"));
if (_fobs isNotEqualTo createHashMap) then {
	_fobs apply {
		(values _y) params ((keys _y) apply {"_" + _x});

		[_pos, _direction, _FOB_name, _jailData, _logObjData, _resources] call btc_fob_fnc_create_s;
		if (btc_debug_log) then {
			[format ["_fob = %1 at %2", _FOB_name, _pos], __FILE__, [false]] call btc_debug_fnc_message;
		};
	};
};
btc_fobs_ruins = +(MAPGET("fobs_ruins"));
if(btc_fobs_ruins isNotEqualTo createHashMap) then {
    btc_fobs_ruins apply { // _[key,[_pos, _dir, _typeOf]]
		(values _y) params ((keys _y) apply {"_" + _x});
        private _ruin = createSimpleObject [_typeOf, _pos, false];
        _ruin setDir _dir;
        _ruin setVariable["FOB_name", _name, true];

        [objNull, _ruin] call btc_fob_fnc_ruins;
    };
};

// VEHICLES
private _array_veh = +(MAPGET("array_veh"));
if (_array_veh isNotEqualTo createHashMap) then {
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
			(values _y) params ((keys _y) apply {"_" + _x});
	
			private _veh = [
			_veh_type, _veh_pos, _veh_dir, _veh_fuel, _veh_allHitPointsDamage, _veh_cargo,
			_veh_inventory, _EDENinventory, _vectorDirAndUp,
			_flagTexture, _turretMagazines,
			_tagTexture, _properties] call btc_json_fnc_createVehicle;

			if (btc_debug_log) then {
				[format ["_veh = %1 at %2", _veh_type, _veh_pos], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
			};

			if !(alive _veh) then {
				[_veh, objNull, objNull, nil, false] call btc_veh_fnc_killed;
			};
		};
	}, _array_veh] call CBA_fnc_execNextFrame;
};

// OBJECTS
private _array_obj = +(MAPGET("array_obj"));
if (_array_obj isNotEqualTo createHashMap) then {
	[{
		// Can't use ace_cargo for objects created during first frame.
		_this apply {
			(values _y) params ((keys _y) apply {"_" + _x});

			[[_type, _pos, _dir, "",
				_cargo, _inventory, _vectorDirAndUp,
				_isChem, _dogtagDataTaken, _flagTexture,
			_turretMagazines, _customName, tagTexture, _properties]] call btc_db_fnc_loadObjectStatus;

			if (btc_debug_log) then {
				[format ["_obj = %1 at %2", _type, _pos], __FILE__, [false]] call btc_debug_fnc_message;
			};
		};
	}, _array_obj] call CBA_fnc_execNextFrame;
};

//Supplies
private _array_fob_log_supplies = +(MAPGET("array_fob_log_supplies"));
if (_array_fob_log_supplies isNotEqualTo createHashMap) then {
	[{
		_this apply {
			(values _y) params ((keys _y) apply {"_" + _x});

		    [_pos, _dir, _resources, _class] call btc_log_resupply_fnc_claimed_create;
		};
	}, _array_fob_log_supplies] call CBA_fnc_execNextFrame;
};


//Player Tags 
private _tags_properties = +(MAPGET("tags_properties"));
private _id = ["ace_tagCreated", {
    params ["_tag", "_texture", "_object"];
    btc_tags_player pushBack [_tag, _texture, _object];
}] call CBA_fnc_addEventHandler;
_tags_properties apply {
    (values _y) params ((keys _y) apply {"_" + _x});
    private _object = objNull;
    if (_typeObject isNotEqualTo "") then {
        _object = nearestObject [ASLToATL _tagPosASL, _typeObject];
    };
    [_tagPosASL, _vectorDirAndUp, _texture, _object, objNull, "",_tagModel] call ace_tagging_fnc_createTag;
};
["ace_tagCreated", _id] call CBA_fnc_removeEventHandler;

//Player respawn tickets and bodies
if (btc_p_respawn_ticketsAtStart >= 0) then {
    btc_respawn_tickets = +(MAPGET("respawn_tickets"));

    private _deadBodyPlayers = +(MAPGET("deadPlayers"));
    btc_body_deadPlayers  = [values _deadBodyPlayers] call btc_body_fnc_create;
};

// PLAYERS
btc_slots_serialized = +(MAPGET("slots_serialized"));

// MARKERS
private _player_markers = +(MAPGET("player_markers"));
if (_player_markers isNotEqualTo createHashMap) then {
	{
		(values _y) params ((keys _y) apply {"_" + _x});

		private _marker = createMarkerLocal [format ["_USER_DEFINED #0/%1/%2", _forEachindex, _markerChannel], _markerPos, _markerChannel];
		_marker setMarkerTextLocal _markerText;
		_marker setMarkerColorLocal _markerColor;
		_marker setMarkerTypeLocal _markerType;
		_marker setMarkerSizeLocal _markerSize;
		_marker setMarkerAlphaLocal _markerAlpha;
		_marker setMarkerBrushLocal _markerBrush;
		_marker setMarkerDir _markerDir;

		if (btc_debug_log) then {
			[format ["_marker = %1 at %2[%3]", _markerText, _markerPos], __FILE__, [false]] call btc_debug_fnc_message;
		};

		_marker setMarkerShape _markerShape;
		if (_markerPolyline isNotEqualTo []) then {
			_marker setMarkerPolyline _markerPolyline;
		};
	} forEach _player_markers;
};

//Explosives
private _explosives = +(MAPGET("explosives"));
if (_explosives isNotEqualTo createHashMap) then {
	btc_explosives = _explosives apply {
		(values _y) params ((keys _y) apply {"_" + _x});

		private _explosive = createVehicle [_explosiveType, _pos, [], 0, "CAN_COLLIDE"];
		_explosive setPosATL _pos;
		[_explosive, _dir, _pitch] call ACE_Explosives_fnc_setPosition;
		_explosive setVariable ["btc_side", _side];
		if (_side isEqualTo btc_player_side) then {
			_explosive setShotParents [btc_explosives_objectSide, objNull];
		};
		[
			_explosive,
			_dir,
			_pitch
		];
	};
};

[["Database loaded", 1, [0, 1, 0, 1]]] call btc_fnc_show_custom_hint;