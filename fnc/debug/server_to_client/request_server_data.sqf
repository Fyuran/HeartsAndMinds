
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_request_server_data

Description:
    Retrieves data based on _fncName and calls back _fncName with _args

Parameters:
	_fncName
Returns:

Examples:
    (begin example)
        _result = [true, "btc_debug_fnc_cities"] call btc_debug_fnc_request_server_data;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params[
	["_args", [], []],
	["_fncName", "", [""]]
];

private _hash = createHashMap;

switch(_fncName) do {
	case "btc_debug_fnc_cache": {

		_hash set ["cache_n", btc_cache_n];
		_hash set ["cache_pos", getPosASL btc_cache_obj];

		btc_debug_namespace setVariable ["cache", _hash, remoteExecutedOwner];
	};
	case "btc_debug_fnc_cities": {
		(values btc_city_all) apply {
			private _id = _x getVariable "id";
			private _occupied = _x getVariable "occupied";
			private _initialized = _x getVariable "initialized";
			private _name = _x getVariable "name";
			private _type = _x getVariable "type";
			private _cachingRadius = _x getVariable "cachingRadius";
			private _hasBeach = _x getVariable ["hasbeach", "empty"];
			private _pos = getPosASL _x;

			private _innerHash = ["_id", "_occupied", "_initialized", "_name", "_type", "_cachingRadius", "_hasBeach", "_pos"]
				createHashMapFromArray [_id, _occupied, _initialized, _name, _type, _cachingRadius, _hasBeach, _pos];
			_hash set [_id, _innerHash];
		};
		btc_debug_namespace setVariable ["cities", _hash, remoteExecutedOwner];
	};
	case "btc_debug_fnc_hideouts": {
		btc_hideouts apply {
			private _id = _x getVariable "id";
			private _pos = getPosASL _x;

			private _innerHash = ["_id", "_pos"] createHashMapFromArray [_id, _pos];
			_hash set [_id, _innerHash];
		};
		btc_debug_namespace setVariable ["hideouts", _hash, remoteExecutedOwner];
	};
	default {
		[format["bad switch case: %1 _fncName", _fncName], __FILE__, nil, true] call btc_debug_fnc_message;
	};
};


_args remoteExecCall [_fncName, remoteExecutedOwner];