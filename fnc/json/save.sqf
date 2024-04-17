/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_save
	
	Description:
	    Saves simpler data into btc_JSON_save.
	
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
	["_name", worldName, [""]]
];

if (btc_debug) then {
	[format ["Saving btc_JSON_save data for %1", _name], __FILE__, [btc_debug, btc_debug_log, false]] call btc_debug_fnc_message;
};

[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_8", 1, [0.03, 0.28, 0.03, 1]]] call btc_fnc_show_custom_hint;

//METADATA
private _simpleData = createHashMapFromArray[
	[
		"metadata",
		(
			["version", "date", "rep", "ho_sel"]
			createHashMapFromArray
 			[btc_version select 1, date, btc_global_reputation, btc_hq getVariable ["id", 0]]
		)
	]
];

//CITIES
private _cities_status = createHashMap;
{
	if (_y getVariable ["active", false]) then {
        [_y] call btc_db_fnc_save_enabled_city; //activated cities won't record any new data until deactivation.
    };
	private _name = _y getVariable ["name", ""];
	if (_name isEqualTo "") then {
		_name = str(_y getVariable "id");
	};

	private _hash = ["id", "name", "initialized", "spawn_more", "occupied",
		"data_units", "has_ho", "ho_units_spawned", "ieds",
		"has_suicider", "data_animals", "data_tags", "btc_rep_civKilled"] createHashMapFromArray [
		_y getVariable ["id", -1],
		_name,
		_y getVariable ["initialized", false],
		_y getVariable ["spawn_more", false],
		_y getVariable ["occupied", false],
		_y getVariable ["data_units", []],
		_y getVariable ["has_ho", false],
		_y getVariable ["ho_units_spawned", false],
		_y getVariable ["ieds", []],
		_y getVariable ["has_suicider", false],
		_y getVariable ["data_animals", []],
    	_y getVariable ["data_tags", []],
		_y getVariable ["btc_rep_civKilled", []]
	];

	_cities_status set [_name, _hash];
} forEach btc_city_all;

//HIDEOUTS
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

//CACHE
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

//FOBS
private _fobs = createHashMap;
{
    private _flag = (btc_fobs select 2) select _forEachIndex;
    if !(isNull _flag) then {
        private _pos = getMarkerPos [_x, true];
        private _direction = getDir ((btc_fobs select 1) select _forEachIndex);
        private _array = [_pos, _direction, markerText _x, []];

        private _hash = ["pos", "direction", "FOB_name", "jailData"] createHashMapFromArray _array;

		private _jail = _flag getVariable ["btc_jail", objNull];
        if(alive _jail) then {
            _hash set ["jailData", [getPosATL _jail, [vectorDir _jail, vectorUp _jail]]];
        };

		_fobs set [markerText _x, _hash];
    };
} forEach (btc_fobs select 0);
private _fobs_ruins = createHashMap;
btc_fobs_ruins apply {
	private _hash = ["pos", "dir", "typeOf", "name"] createHashMapFromArray _y;
	_fobs_ruins set [_x, _hash];
};

//Vehicles status
private _array_veh = createHashMap;
private _vehicles = btc_vehicles - [objNull];
private _vehiclesNotInCargo = _vehicles select {isNull isVehicleCargo _x && {isNull isVehicleCargo attachedTo _x}};
private _vehiclesInCargo = _vehicles - _vehiclesNotInCargo;
{
	(_x call btc_db_fnc_saveObjectStatus) params [
		"_type", "_pos", "_dir", "_PLACEHOLDER1", "_cargo",
		"_inventory", "_vectorDirAndUp", "_PLACEHOLDER2", "_PLACEHOLDER3",
		["_flagTexture", "", [""]],
		["_turretMagazines", [], [[]]],
		"_no4",
		["_tagTexture", "", [""]],
		["_properties", [], [[]]]
	];
	private _hash = [
		"veh_type", "veh_pos", "veh_dir", "veh_fuel", "veh_allHitPointsDamage", "veh_cargo",
		"veh_inventory", "EDENinventory", "vectorDirAndUp",
		"flagTexture", "turretMagazines",
		"tagTexture", "properties"
	]createHashMapFromArray[
		_type, getPosATL _x, _dir, fuel _x, getAllHitPointsDamage _x,
		_cargo, _inventory, _x getVariable ["btc_EDENinventory", []], _vectorDirAndUp,
		_flagTexture, _turretMagazines, _tagTexture, _properties
	];
	_array_veh set [_forEachIndex, _hash];
} forEach (_vehiclesNotInCargo + _vehiclesInCargo);

//Objects status
private _array_obj = createHashMap;
{
	if !(!alive _x || isNull _x) then {
		private _data = [_x] call btc_db_fnc_saveObjectStatus;
		private _hash =
		["type", "pos", "dir", "", "cargo",
			"inventory", "vectorDirAndUp", "isChem", "dogtagDataTaken",
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

//Player Tags
private _tags = btc_tags_player select {alive (_x select 0)};
private _tags_properties = createHashMap;
_tags apply {
    private _tag = _x select 0;
    private _hash = createHashMapFromArray [
        ["tagPosASL", getPosASL _tag],
        ["vectorDirAndUp", [vectorDir _tag, vectorUp _tag]],
        ["texture", _x select 1],
        ["typeObject", typeOf (_x select 2)],
        ["tagModel", typeOf _tag]
    ];
	_tags_properties set [_tag, _hash];
};

//Player respawn tickets and bodies
private _respawn_tickets = +btc_respawn_tickets;
private _deadPlayers = createHashMap;
if (btc_p_respawn_ticketsAtStart >= 0) then {
    private _deadBodyPlayers = [btc_body_deadPlayers] call btc_body_fnc_get;    
	_deadBodyPlayers apply {
		private _hash = [ 
			"type", "pos", "dir", "loadout", "dogtag", "isContaminated", "flagTexture" 
		] createHashMapFromArray _x;

		_deadPlayers set [(_x#4)#2, _hash]; //btc_UID from the dogtag as key
	};
};

//Player slots
btc_slots_serialized = createHashMap;
(allPlayers - entities "HeadlessClient_F") apply {
    if (alive _x) then {
        [getPlayerUID _x] call btc_slot_fnc_getData;
    };
};
private _slots_serialized = +btc_slots_serialized;

//Player Markers
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

//Explosives
private _explosives = [];
btc_explosives apply {
    _x params ["_explosive", "_dir", "_pitch"];
    if (isNull _explosive) then {continue};

	private _hash = createHashMapFromArray[
        ["explosiveType", typeOf _explosive],
        ["dir", _dir],
        ["pitch", _pitch],
        ["pos", getPosATL _explosive],
        ["side", _explosive getVariable ["btc_side", sideEmpty]]
    ];
	_explosives set [count _explosives, _hash];
};
(allMines select {_x isKindOf "APERSMineDispenser_Mine_Ammo"}) apply {
    private _hash = createHashMapFromArray[
        ["explosiveType", typeOf _x],
        ["dir", _x],
        ["pitch", _x],
        ["pos", getPosATL _x],
        ["side", _x getVariable ["btc_side", side group ((getShotParents _x) select 0)]]
    ];

	_explosives set [count _explosives, _hash];
};

//Combine all together
btc_JSON_save = [
	_simpleData, _player_markers, _cities_status,
	_array_ho, _array_cache, _fobs, _fobs_ruins,
	_array_obj, _tags_properties, _respawn_tickets, _deadPlayers, _slots_serialized, _array_veh, _explosives] apply {
		[_x] call btc_json_fnc_encodeJSON;// CBA_fnc_encodeJSON uses "format" which has a hard limit of 2048 chars
	};

private _json =
format["btc_hm_%1", _name] + " " +// btc_JSON_save fileName
"{
    " + endl +
    format ["""%1""", _name] + ":" + btc_JSON_save#0 + ", " +
    """player_markers""" + ":" + btc_JSON_save#1 + ", " +
    """cities_status""" + ":" + btc_JSON_save#2 + ", " +
    """array_ho""" + ":" + btc_JSON_save#3 + ", " +
    """array_cache""" + ":" + btc_JSON_save#4 + ", " +
    """fobs""" + ":" + btc_JSON_save#5 + ", " +
	"""fobs_ruins""" + ":" + btc_JSON_save#6 + ", " +
    """array_obj""" + ":" + btc_JSON_save#7 + ", " +
	"""tags_properties""" + ":" + btc_JSON_save#8 + ", " +
	"""respawn_tickets""" + ":" + btc_JSON_save#9 + ", " +
	"""deadPlayers""" + ":" + btc_JSON_save#10 + ", " +
    """slots_serialized""" + ": " + btc_JSON_save#11 + ", " +
    """array_veh""" + ":" + btc_JSON_save#12 + ", " +
	"""explosives""" + ": " + btc_JSON_save#13 + 
    "
}";

private _path = "btc_ArmaToJSON" callExtension _json;
if(_path isEqualTo "") exitWith {
	[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_16", 1, [1, 0, 0, 1]]] call btc_fnc_show_custom_hint;
	[format["Invalid _path, could not save file."], __FILE__, nil, true] call btc_debug_fnc_message;
};
profileNamespace setVariable [format["btc_hm_%1_saveFile", worldName], _path];

[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_9", 1, [0, 1, 0, 1]]] call btc_fnc_show_custom_hint;
[] call btc_json_fnc_fileviewer_r_server;

_path