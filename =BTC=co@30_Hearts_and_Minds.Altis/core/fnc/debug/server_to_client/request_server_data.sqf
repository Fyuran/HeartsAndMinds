
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

switch(_fncName) do {
	case "btc_debug_fnc_cache": {
		btc_debug_namespace setVariable ["cache_n", btc_cache_n, remoteExecutedOwner];
		btc_debug_namespace setVariable ["cache_pos", getPosASL btc_cache_obj, remoteExecutedOwner];
	};
	case "btc_debug_fnc_cities": {
		private _arr = [];
		(values btc_city_all) apply {
			private _id = _x getVariable "id";
			private _has_en = _x getVariable "occupied";
			private _name = _x getVariable "name";
			private _type = _x getVariable "type";
			private _cachingRadius = _x getVariable "cachingRadius";
			private _hasBeach = _x getVariable ["hasbeach", "empty"];
			private _pos = getPosASL _x;

			_arr pushBack [_id, _has_en, _name, _type, _cachingRadius, _hasBeach, _pos];
		};
		btc_debug_namespace setVariable ["cities", _arr, remoteExecutedOwner];
	};
	case "btc_debug_fnc_hideouts": {
		private _arr = [];
		btc_hideouts apply {
			private _id = _x getVariable "id";
			private _pos = getPosASL _x;
			_arr pushBack [_id, _pos];
		};
		btc_debug_namespace setVariable ["hideouts", _arr, remoteExecutedOwner];
	};
	default {
		[format["bad switch case: %1 _fncName", _fncName], __FILE__, nil, true] call btc_debug_fnc_message;
	};
};


_args remoteExecCall [_fncName, remoteExecutedOwner];