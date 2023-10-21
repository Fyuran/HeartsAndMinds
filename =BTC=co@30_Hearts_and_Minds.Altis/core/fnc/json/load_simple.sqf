
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_load_simple

Description:
    Load database from HEM.JSON

Parameters:
    _name - Name of the saved game. [String]

Returns:

Examples:
    (begin example)
        [] call btc_json_fnc_load_simple;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#define MMAPGET btc_JSON_data get format["btc_hm_%1", _name]
#define MAPGET(ARG) btc_JSON_data get format["btc_hm_%1_" + ARG, _name]

params [
    ["_name", worldName, [""]]
];

if(isNil "btc_JSON_data") exitWith {
    ["btc_JSON_data is nil"] call BIS_fnc_error;
};

//Metadata
private _metadata = (MMAPGET) get "metadata";
(values _metadata) params _metadataParams;
setDate _btc_hm_Altis_date;
btc_global_reputation = _btc_hm_Altis_rep;
btc_version = _btc_hm_Altis_version;

//CITIES
MAPGET("cities") apply {
    (values _y) apply {
        (values _y) params (keys _y);

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
        };
        if (btc_debug_log) then {
            [format [
                "ID: %1 - _initialized %2 _spawn_more %3 _occupied %4 count _data_units %5 _has_ho %6",
                _id, _initialized, _spawn_more, 
                _occupied, count _data_units, _has_ho  
            ], __FILE__, [false]] call btc_debug_fnc_message;
            [format [
                "ID: %1 - _ho_units_spawned %2 count _ieds %3 _has_suicider %4 count _civKilled %5",
                _id, _ho_units_spawned, count _ieds, _has_suicider,
                count _civKilled  
            ], __FILE__, [false]] call btc_debug_fnc_message;
        };
    };
};

//HIDEOUT
MAPGET("ho") apply {
    (values _y) apply {
        (values _y) params (keys _y);
        [_pos, _id_hideout, _rinf_time, _cap_time, _id, _markers_saved] call btc_hideout_fnc_create;
    };
};

private _select_ho = (btc_hideouts apply {_x getVariable "id"}) find _btc_hm_Altis_ho_sel;
if (_select_ho isEqualTo - 1) then {
    btc_hq = objNull;
} else {
    btc_hq = btc_hideouts select _select_ho;
};

if (btc_hideouts isEqualTo []) then {[] spawn btc_fnc_final_phase;};

//CACHE


MAPGET("cache") apply {
    (values_y) params (keys _y);
    btc_cache_pos = _cache_pos;
    btc_cache_n = _cache_n;
    btc_cache_info = _cache_info;

    [_cache_pos, btc_p_chem, [1, 0] select _isChem] call btc_cache_fnc_create;
    btc_cache_obj setVariable ["btc_cache_unitsSpawned", _cache_unitsSpawned];

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


//FOB
MAPGET("fobs") apply {
    (values _y) apply {
        (values _y) params (keys _y);
        [_pos, _direction, _fob_name] call btc_fob_fnc_create_s;
    };
};

//Objects
(getMissionLayerEntities "btc_vehicles" select 0) apply {deleteVehicle _x};
if !(isNil "btc_vehicles") then {
    btc_vehicles apply {deleteVehicle _x};
    btc_vehicles = [];
};

[{ // Can't use ace_cargo for objects created during first frame.
    _this apply {
        (values _y) apply {
            (values _y) params (keys _y);

            [_type, _pos, _dir, "",
            _cargo, _inventory, _vectorPos,
            _isContaminated, _dogtagDataTaken, _flagTexture,
            _turretMagazines, _customName,_properties] call btc_db_fnc_loadObjectStatus;
        };
    };
}, MAPGET("objs")] call CBA_fnc_execNextFrame;

//VEHICLES
[{ // Can't be executed just after because we can't delete and spawn vehicle during the same frame.
    private _loadVehicle = {
        params["_x", "_y"];
        (values _y) params (keys _y);
        
        if (btc_debug_log) then {
            [format ["_veh = %1", _type], __FILE__, [false]] call btc_debug_fnc_message;
        };

        private _veh = [_veh_type, _veh_pos, _veh_dir, _customization, _isMedicalVehicle, _isRepairVehicle, _fuelSource, _pylons, _isContaminated, _supplyVehicle, _objectTexture, _EDENinventory, _veh_AllHitPointsDamage, _flagTexture, _tagTexture] call btc_log_fnc_createVehicle;
        _veh setVectorDirAndUp _vectorPos;
        _veh setFuel _veh_fuel;

        [_veh, _turretMagazines] call btc_db_fnc_setTurretMagazines;

        [_veh, _veh_cargo, _veh_inventory] call btc_db_fnc_loadCargo;

        if !(alive _veh) then {
            [_veh, objNull, objNull, nil, false] call btc_veh_fnc_killed;
        };
        if (_ViV isNotEqualTo []) then {
            _ViV apply {
                private _vehToLoad = _x call _loadVehicle;
                if !([_vehToLoad, _veh] call btc_tow_fnc_ViV) then {
                    _vehToLoad setVehiclePosition [_veh, [], 100, "NONE"];
                    private _marker = _vehToLoad getVariable ["marker", ""];
                    if (_marker isNotEqualTo "") then {
                        _marker setMarkerPos _vehToLoad;
                    };
                };
            };
        };

        _veh
    };
    _this apply {
        [values _y] call _loadVehicle;
    };
}, MAPGET("vehs")] call CBA_fnc_execNextFrame;

//Player slots
[{
    _this apply {
        if (_y isEqualTo []) then {continue};
        private _objtClass = _y select 6;
        if (_objtClass isEqualTo "") then {
            _objtClass = objNull;
        } else {
            _objtClass = nearestObject [ASLToATL (_y select 0), _objtClass];
        };
        _y set [6, _objtClass];
    };
}, MAPGET("slotsSerialized")] call CBA_fnc_execNextFrame; // Need to wait for vehicle creation
btc_slots_serialized = MAPGET("slotsSerialized");

//Player Markers
{
    (values _y) apply {
        (values _y) params (keys _y);

        private _marker = createMarker [format ["_USER_DEFINED #0/%1/%2", _forEachindex, _markerChannel], _markerPos, _markerChannel];
        _marker setMarkerText _markerText;
        _marker setMarkerColor _markerColor;
        _marker setMarkerType _markerType;
        _marker setMarkerSize _markerSize;
        _marker setMarkerAlpha _markerAlpha;
        _marker setMarkerBrush _markerBrush;
        _marker setMarkerDir _markerDir;

        _marker setMarkerShape _markerShape;
        if (_markerPolyline isNotEqualTo []) then {
            _marker setMarkerPolyline _markerPolyline;
        };
    };
} forEach MAPGET("markers");
