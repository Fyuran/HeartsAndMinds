/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_save
	
	Description:
	    Saves simpler data into JSON.
	
	Parameters:
	    _name - name of the game saved. [String]
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_save;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */

params [
	["_name", btc_db_saveName, [""]]
];

if (btc_debug) then {
	[format ["Saving JSON data for %1", _name], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_16", 1, [0.03, 0.28, 0.03, 1]]] call btc_fnc_show_custom_hint;


// METADATA
private _simpleData = createHashMapFromArray[
	[
		"metadata",
		(
		[format["btc_hm_%1_version", _name], format ["btc_hm_%1_date", _name],
		format ["btc_hm_%1_rep", _name], format ["btc_hm_%1_ho_sel", _name]]
		createHashMapFromArray
		[btc_version select 1, date, btc_global_reputation, btc_hq getVariable ["id", 0]]
		)
	]
];

// CITIES
private _cities_status = createHashMap;
{
	private _name = _y getVariable ["name", ""];
	if (_name isEqualTo "") then {
		_name = _y getVariable "id"
	};

	private _hash = ["id", "initialized", "spawn_more", "occupied",
		"data_units", "has_ho", "ho_units_spawned", "ieds",
		"has_suicider", "btc_rep_civKilled", "name",
	"cachingRadius", "type"] createHashMapFromArray [
		_y getVariable ["id", -1],
		_y getVariable ["initialized", false],
		_y getVariable ["spawn_more", false],
		_y getVariable ["occupied", false],
		_y getVariable ["data_units", createHashMap],
		_y getVariable ["has_ho", false],
		_y getVariable ["ho_units_spawned", false],
		_y getVariable ["ieds", []],
		_y getVariable ["has_suicider", false],
		_y getVariable ["civKilled", []],
		_y getVariable ["name", ""],
		_y getVariable ["cachingRadius", 100],
		_y getVariable ["type", ""]
	];

	_cities_status set [_name, _hash];
} forEach btc_city_all;

// HIDEOUTS
private _array_ho = createHashMap;
{
	(getPos _x) params ["_xx", "_yy"];

	private _ho_markers = [];
	{
		private _marker = [];
		_marker pushBack (getMarkerPos _x);
		_marker pushBack (markerText _x);
		_ho_markers pushBack _marker;
	} forEach (_x getVariable ["markers", []]);

	private _hash = [
		"pos", "id_hideout", "rinf_time",
	"cap_time", "assigned_to", "markers_saved"] createHashMapFromArray [
		[_xx, _yy, 0],
		_x getVariable ["id", 0],
		_x getVariable ["rinf_time", 0],
		_x getVariable ["cap_time", 0],
		(_x getVariable ["assigned_to", objNull]) getVariable "id",
		_ho_markers
	];

	_array_ho set [(_x getVariable ["assigned_to", _forEachIndex]) getVariable "id", _hash];
} forEach btc_hideouts;

// CACHE
private _cache_markers = [];
{
	private _data = [];
	_data pushBack (getMarkerPos _x);
	_data pushBack (markerText _x);
	_cache_markers pushBack _data;
} forEach btc_cache_markers;

private _array_cache = createHashMap;
_array_cache set ["cache", [
	"cache_pos", "cache_n", "cache_info",
	"cache_markers", "cache_pictures", "isChem", "cache_unitsSpawned"
] createHashMapFromArray [
	(getPosATL btc_cache_obj),
	btc_cache_n,
	btc_cache_info,
	_cache_markers,
	[btc_cache_pictures select 0, btc_cache_pictures select 1, []],
	(btc_cache_obj in btc_chem_contaminated),
	btc_cache_obj getVariable ["btc_cache_unitsSpawned", false]
]];

// FOBS
private _fobs = createHashMap;
{
	if !(isNull ((btc_fobs select 2) select _forEachIndex)) then {
		private _hash = ["name", "pos", "direction"] createHashMapFromArray[
			markerText _x,
			getMarkerPos [_x, true],
			getDir ((btc_fobs select 1) select _forEachIndex)
		];
		_fobs set [markerText _x, _hash];
	};
} forEach (btc_fobs select 0);

// OBJECTS
private _array_obj = createHashMap;
{
	if !(!alive _x || isNull _x) then {
		private _data = [_x] call btc_db_fnc_saveObjectStatus;
		private _hash =
		["type", "pos", "direction", "", "cargo",
			"inventory", "vectorPos", "isChem", "dogtagDataTaken",
			"flagTexture", "turretMagazines", "customName", "tagTexture",
			"properties"
		] createHashMapFromArray _data;
		_array_obj set [_forEachindex, _hash];
	};
} forEach (btc_log_obj_created select {
	!(isObjectHidden _x) &&
	isNull objectParent _x &&
	isNull isVehicleCargo _x
});

// VEHICLES
private _array_veh = createHashMap;
private _vehicles = btc_vehicles - [objNull];
private _vehiclesNotInCargo = _vehicles select {isNull isVehicleCargo _x && {isNull isVehicleCargo attachedTo _x}};
private _vehiclesInCargo = _vehicles - _vehiclesNotInCargo;
{
	(_x call btc_db_fnc_saveObjectStatus) params [
		"_type", "_pos", "_dir", "_no1", "_cargo",
		"_inventory", "_vectorPos", "_no2", "_no3",
		["_flagTexture", "", [""]],
		["_turretMagazines", [], [[]]],
		"_no4",
		["_tagTexture", "", [""]],
		["_properties", [], [[]]]
	];

	private _hash = [
		"type", "pos", "direction", "fuel", "allHitPointsDamage", "cargo",
		"inventory", "EDENinventory", "vectorPos",
		"flagTexture", "turretMagazines",
		"tagTexture", "properties"
	]createHashMapFromArray[
		_type, getPosASL _x, _dir, fuel _x, getAllHitPointsDamage _x,
		_cargo, _inventory, _x getVariable ["btc_EDENinventory", []], _vectorPos,
		_flagTexture, _turretMagazines, _tagTexture, _properties
	];
	_array_veh set [_forEachIndex, _hash];
} forEach (_vehiclesNotInCargo + _vehiclesInCargo);

// PLAYERS
private _slots_serialized = (missionNamespace getVariable ["btc_JSON_data", createHashMap]); 
_slots_serialized = _slots_serialized getOrDefault [format["btc_hm_%1_" + "slotsSerialized", _name], createHashMap];

((allPlayers - entities "HeadlessClient_F") apply {
	if (alive _x) then {
		private _hash = [_x] call btc_json_fnc_serialize_players;
		_slots_serialized set [_hash get "uid", _hash];
	};
});

// MARKERS
private _player_markers = createHashMap;
{
	private _hash =
	["markerText", "markerPos", "markerColor", "markerType", "markerSize",
		"markerAlpha", "markerBrush", "markerDir", "markerShape",
	"markerPolyline", "markerChannel"] createHashMapFromArray
	[markerText _x, markerPos _x, markerColor _x, markerType _x,
		markerSize _x, markerAlpha _x, markerBrush _x, markerDir _x,
	markerShape _x, markerPolyline _x, markerChannel _x];

	_player_markers set [_forEachIndex, _hash];
}forEach (allMapMarkers select {
	"_USER_DEFINED" in _x
});

// Combine all together
encodedHashes = [
	_simpleData, _player_markers, _cities_status,
	_array_ho, _array_cache, _fobs,
	_array_obj, _slots_serialized, _array_veh] apply {
		[_x] call btc_json_fnc_encodeJSON;// CBA_fnc_encodeJSON uses "format" which has a hard limit of 2048 chars
	};

private _json =
format["btc_hm_%1", _name] + " " +// JSON fileName
"{
    " + endl +
    format ["""btc_hm_%1""", _name] + ":" + encodedHashes#0 + ", " +
    format ["""btc_hm_%1_markers""", _name] + ":" + encodedHashes#1 + ", " +
    format ["""btc_hm_%1_cities""", _name] + ":" + encodedHashes#2 + ", " +
    format ["""btc_hm_%1_ho""", _name] + ":" + encodedHashes#3 + ", " +
    format ["""btc_hm_%1_cache""", _name] + ":" + encodedHashes#4 + ", " +
    format ["""btc_hm_%1_fobs""", _name] + ":" + encodedHashes#5 + ", " +
    format ["""btc_hm_%1_objs""", _name] + ":" + encodedHashes#6 + ", " +
    format ["""btc_hm_%1_slotsSerialized""", _name] + ": " + encodedHashes#7 + ", " +
    format ["""btc_hm_%1_vehs""", _name] + ":" + encodedHashes#8 +
    "
}";

private _returnString = "btc_ArmaToJSON" callExtension _json;
[[_returnString, 1, [0, 1, 0, 1]]] call btc_fnc_show_custom_hint;

[] call btc_json_fnc_fileviewer_r_server;

_returnString