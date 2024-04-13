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
#define MAPGET(ARG) btc_JSON get ARG

params[
	["_name", worldName, [""]]
];
[["Loading Data", 1, [1,0.27,0,1]]] call btc_fnc_show_custom_hint;

[] call btc_json_fnc_request_data;

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
private _cities = +(MAPGET("cities_status"));
if (_cities isNotEqualTo createHashMap) then {
	_cities apply {
		(values _y) params ((keys _y) apply {"_" + _x});// iterate through cities' data

		private _city = btc_city_all get _id;

		_city setVariable ["initialized", _initialized];
		_city setVariable ["spawn_more", _spawn_more];
		_city setVariable ["occupied", _occupied];
		_city setVariable ["data_animals", _data_animals];
		_city setVariable ["data_tags", _data_tags];
		_city setVariable ["data_units", _data_units];
		_city setVariable ["has_ho", _has_ho];
		_city setVariable ["ho_units_spawned", _ho_units_spawned];
		_city setVariable ["ieds", _ieds];
		_city setVariable ["has_suicider", _has_suicider];
		_city setVariable ["btc_rep_civKilled", _civKilled];

		if (btc_debug) then {
			private _marker = _city getVariable ["marker", ""];
			if (_city getVariable ["occupied", false]) then {
				_marker setMarkerColor (["colorRed", "ColorCIV"] select _initialized);
			} else {
				_marker setMarkerColor (["colorGreen", "ColorWhite"] select _initialized);
			};
			if (btc_debug_log) then {
				[format ["_city = %1 at %2", _name, getPosASL _city], __FILE__, [false]] call btc_debug_fnc_message;
			};
		};
	};
};
// HIDEOUTS
private _hos = +(MAPGET("array_ho"));
if (_hos isNotEqualTo createHashMap) then {
	_hos apply {
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
private _cache = +(MAPGET("array_cache"));
if (_cache isNotEqualTo createHashMap) then {
	_cache apply {
		(values _y) params ((keys _y) apply {"_" + _x});
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
private _fobs = +(MAPGET("fobs"));
if (_fobs isNotEqualTo createHashMap) then {
	_fobs apply {
		(values _y) params ((keys _y) apply {"_" + _x});

		[_pos, _direction, _FOB_name, _jailData] call btc_fob_fnc_create_s;
		if (btc_debug_log) then {
			[format ["_fob = %1 at %2", _name, _pos], __FILE__, [false]] call btc_debug_fnc_message;
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

        [objNull, _ruin] call btc_fob_fnc_reactivation;
    };
};

// VEHICLES
private _vehs = +(MAPGET("array_veh"));
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
			(values _y) params ((keys _y) apply {"_" + _x});
	
			private _veh = [
			_veh_type, _veh_pos, _veh_dir, _veh_fuel, _veh_allHitPointsDamage, _veh_cargo,
			_veh_inventory, _EDENinventory, _vectorDirAndUp,
			_flagTexture, _turretMagazines,
			_tagTexture, _properties] call btc_json_fnc_createVehicle;

			if (btc_debug_log) then {
				[format ["_veh = %1 at %2", _veh_type, _veh_pos], __FILE__, [false]] call btc_debug_fnc_message;
			};

			if !(alive _veh) then {
				[_veh, objNull, objNull, nil, false] call btc_veh_fnc_killed;
			};
		};
	}, _vehs] call CBA_fnc_execNextFrame;
};

// OBJECTS
private _objs = +(MAPGET("array_obj"));
if (_objs isNotEqualTo createHashMap) then {
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
	}, _objs] call CBA_fnc_execNextFrame;
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
private _markers = +(MAPGET("player_markers"));
if (_markers isNotEqualTo createHashMap) then {
	{
		(values _y) params ((keys _y) apply {"_" + _x});

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