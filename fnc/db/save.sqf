
/* ----------------------------------------------------------------------------
Function: btc_db_fnc_save

Description:
    Save the current game into profileNamespace.

Parameters:
    _name - Name of the game saved. [String]

Returns:

Examples:
    (begin example)
        [] call btc_db_fnc_save;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_name", worldName, [""]]
];


[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_8", 1, [0.03, 0.28, 0.03, 1]]] call btc_fnc_show_custom_hint;
[false] call btc_db_fnc_delete;

//Version
profileNamespace setVariable [format ["btc_hm_%1_version", _name], btc_version select 1];

//World Date
profileNamespace setVariable [format ["btc_hm_%1_date", _name], date];

//City status
private _cities_status = [];
{
    if (_y getVariable ["active", false]) then {
        [_city] call btc_db_fnc_save_enabled_city; //activated cities won't record any new data until deactivation.
    };

    private _city_status = [];
    _city_status pushBack _x;
    _city_status pushBack (_y getVariable "initialized");
    _city_status pushBack (_y getVariable "spawn_more");
    _city_status pushBack (_y getVariable "occupied");
    _city_status pushBack (_y getVariable "data_units");
    _city_status pushBack (_y getVariable ["has_ho", false]);
    _city_status pushBack (_y getVariable ["ho_units_spawned", false]);
    _city_status pushBack (_y getVariable ["ieds", []]);
    _city_status pushBack (_y getVariable ["has_suicider", false]);
    _city_status pushBack (_y getVariable ["data_animals", []]);
    _city_status pushBack (_y getVariable ["data_tags", []]);
    _city_status pushBack (_y getVariable ["data_supplies", []]);
    _city_status pushBack (_y getVariable ["btc_rep_civKilled", []]);

    _cities_status pushBack _city_status;
} forEach btc_city_all;
profileNamespace setVariable [format ["btc_hm_%1_cities", _name], +_cities_status];

//HIDEOUT
private _array_ho = [];
{
    private _data = [];
    (getPos _x) params ["_xx", "_yy"];
    _data pushBack [_xx, _yy, 0];
    _data pushBack (_x getVariable ["id", 0]);
    _data pushBack (_x getVariable ["rinf_time", 0]);
    _data pushBack (_x getVariable ["cap_time", 0]);
    _data pushBack ((_x getVariable ["assigned_to", objNull]) getVariable "id");

    private _ho_markers = [];
    {
        private _marker = [];
        _marker pushBack (getMarkerPos _x);
        _marker pushBack (markerText _x);
        _ho_markers pushBack _marker;
    } forEach (_x getVariable ["markers", []]);
    _data pushBack _ho_markers;
    if (btc_debug_log) then {
        [format ["HO %1 DATA %2", _x, _data], __FILE__, [false]] call btc_debug_fnc_message;
    };
    _array_ho pushBack _data;
} forEach btc_hideouts;
profileNamespace setVariable [format ["btc_hm_%1_ho", _name], +_array_ho];

profileNamespace setVariable [format ["btc_hm_%1_ho_sel", _name], btc_hq getVariable ["id", 0]];

//CACHE
private _array_cache = [];
_array_cache pushBack (getPosATL btc_cache_obj);
_array_cache pushBack btc_cache_n;
_array_cache pushBack btc_cache_info;
private _cache_markers = [];
{
    private _data = [];
    _data pushBack (getMarkerPos _x);
    _data pushBack (markerText _x);
    _cache_markers pushBack _data;
} forEach btc_cache_markers;
_array_cache pushBack _cache_markers;
_array_cache pushBack [btc_cache_pictures select 0, btc_cache_pictures select 1, []];
_array_cache pushBack (btc_cache_obj in btc_chem_contaminated);
_array_cache pushBack (btc_cache_obj getVariable ["btc_cache_unitsSpawned", false]);
profileNamespace setVariable [format ["btc_hm_%1_cache", _name], +_array_cache];

//REPUTATION
profileNamespace setVariable [format ["btc_hm_%1_rep", _name], btc_global_reputation];

//FOBS
private _fobs = [];
{
    private _flag = (btc_fobs select 2) select _forEachIndex;
    if !(isNull _flag) then {
        private _pos = getMarkerPos [_x, true];
        private _direction = getDir ((btc_fobs select 1) select _forEachIndex);
        private _array = [_pos, _direction, markerText _x, [], [], _flag getVariable ["btc_log_resources", -1]];

		private _jail = _flag getVariable ["btc_jail", objNull];
        if(alive _jail) then {
            _array pushBack [getPosATL _jail, [vectorDir _jail, vectorUp _jail]];
        };

		private _create_obj = _flag getVariable ["btc_log_create_obj", objNull];
        if(alive _create_obj) then {
            _array pushBack [getPosATL _create_obj, [vectorDir _create_obj, vectorUp _create_obj]];
        };

		_fobs pushBack _array;
    };
} forEach (btc_fobs select 0);
profileNamespace setVariable [format ["btc_hm_%1_fobs", _name], +_fobs];
profileNamespace setVariable [format ["btc_hm_%1_fobs_ruins", _name], +btc_fobs_ruins];


//Vehicles status
private _array_veh = [];
private _vehicles = btc_vehicles - [objNull];
private _vehiclesNotInCargo = _vehicles select {
    isNull isVehicleCargo _x &&
    {isNull isVehicleCargo attachedTo _x}
};
private _vehiclesInCargo = _vehicles - _vehiclesNotInCargo;
{
    (_x call btc_db_fnc_saveObjectStatus) params [
        "_type", "_pos", "_dir", "", "_cargo",
        "_inventory", "_vectorDirAndUp", "_isContaminated", "",
        ["_flagTexture", "", [""]],
        ["_turretMagazines", [], [[]]],
        ["_notuse", "", [""]],
        ["_tagTexture", "", [""]],
        ["_properties", [], [[]]]
    ];

    private _data = [];
    _data pushBack _type;
    _data pushBack _pos;
    _data pushBack _dir;
    _data pushBack (fuel _x);
    _data pushBack (getAllHitPointsDamage _x);
    _data pushBack _cargo;
    _data pushBack _inventory;
    _data append ([_x] call btc_veh_fnc_propertiesGet);
    _data pushBack (_x getVariable ["btc_EDENinventory", []]);
    _data pushBack _vectorDirAndUp;
    _data pushBack []; // ViV
    _data pushBack _flagTexture;
    _data pushBack _turretMagazines;
    _data pushBack _tagTexture;
    _data pushBack _properties;

    private _fakeViV = isVehicleCargo attachedTo _x;
    if (
        isNull _fakeViV &&
        {isNull isVehicleCargo _x}
    ) then {
         _array_veh pushBack _data;
    } else {
        private _vehicleCargo = if (isNull _fakeViV) then {
            isVehicleCargo _x
        } else {
            _fakeViV
        };
        private _index = _vehiclesNotInCargo find _vehicleCargo;
        ((_array_veh select _index) select 17) pushBack _data;
    };

    if (btc_debug_log) then {
        [format ["VEH %1 DATA %2", _x, _data], __FILE__, [false]] call btc_debug_fnc_message;
    };
} forEach (_vehiclesNotInCargo + _vehiclesInCargo);
profileNamespace setVariable [format ["btc_hm_%1_vehs", _name], +_array_veh];

//Objects status
private _array_obj = [];
{
    if !(!alive _x || isNull _x) then {
        private _data = [_x] call btc_db_fnc_saveObjectStatus;
        _array_obj pushBack _data;
    };
} forEach (btc_log_obj_created select {
    !(isObjectHidden _x) &&
    isNull objectParent _x &&
    isNull isVehicleCargo _x
});
profileNamespace setVariable [format ["btc_hm_%1_objs", _name], +_array_obj];

//Supplies
private _array_fob_log_supplies = [];
{
	private _pos = getPosATL _x;
	private _dir = getDir _x;
	private _resources = _x getVariable ["btc_log_resources", 0];
	private _class = typeOf _x;

	_array_fob_log_supplies pushBack [_pos, _dir, _resources, _class];
} forEach (btc_log_fob_supply_objects select {
	isNull objectParent _x &&
	{!(isObjectHidden _x)} &&
	{isNull isVehicleCargo _x}  
});
profileNamespace setVariable [format ["btc_hm_%1_fob_log_supplies", _name], +_array_fob_log_supplies];

//Player Tags
private _tags = btc_tags_player select {alive (_x select 0)};
private _tags_properties = _tags apply {
    private _tag = _x select 0;
    [
        getPosASL _tag,
        [vectorDir _tag, vectorUp _tag],
        _x select 1,
        typeOf (_x select 2),
        typeOf _tag
    ]
};
profileNamespace setVariable [format ["btc_hm_%1_tags", _name], +_tags_properties];

//Player respawn tickets and bodies
if (btc_p_respawn_ticketsAtStart >= 0) then {
    profileNamespace setVariable [format ["btc_hm_%1_respawnTickets", _name], +btc_respawn_tickets];

    private _deadBodyPlayers = [btc_body_deadPlayers] call btc_body_fnc_get;
    profileNamespace setVariable [format ["btc_hm_%1_deadBodyPlayers", _name], +_deadBodyPlayers];
};

//Player slots
btc_slots_serialized = createHashMap;
(allPlayers - entities "HeadlessClient_F") apply {
    if (!isNull _x) then {
		private _uid = getPlayerUID _x;
		if(_uid isEqualTo "_SP_PLAYER_") then { continue };
        [_uid, _x] call btc_slot_fnc_saveData;
    };
};
profileNamespace setVariable [format ["btc_hm_%1_slotsSerialized", _name], +btc_slots_serialized];

//Player Markers
private _player_markers = allMapMarkers select {"_USER_DEFINED" in _x};
private _markers_properties = _player_markers apply {
    [markerText _x, markerPos _x, markerColor _x, markerType _x, markerSize _x, markerAlpha _x, markerBrush _x, markerDir _x, markerShape _x, markerPolyline _x, markerChannel _x]
};
profileNamespace setVariable [format ["btc_hm_%1_markers", _name], +_markers_properties];

//Explosives
private _explosives = [];
{
    _x params ["_explosive", "_dir", "_pitch"];
    if (isNull _explosive) then {continue};
    _explosives pushBack [
        typeOf _explosive,
        _dir,
        _pitch,
        getPosATL _explosive,
        _explosive getVariable ["btc_side", sideEmpty]
    ]
} forEach btc_explosives;
{
    _explosives pushBack [
        typeOf _x,
        getDir _x,
        0,
        getPosATL _x,
        _x getVariable ["btc_side", side group ((getShotParents _x) select 0)]
    ]
} forEach (allMines select {_x isKindOf "APERSMineDispenser_Mine_Ammo"});
profileNamespace setVariable [format ["btc_hm_%1_explosives", _name], +_explosives];

//End
profileNamespace setVariable [format ["btc_hm_%1_db", _name], true];
saveProfileNamespace;

[[localize "STR_BTC_HAM_O_COMMON_SHOWHINTS_9", 1, [0, 1, 0, 1]]] call btc_fnc_show_custom_hint;