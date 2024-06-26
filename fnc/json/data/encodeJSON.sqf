
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_encodeJSON

Description:
    Serializes input to a JSON string. Can handle
    - ARRAY
    - BOOL
    - CONTROL
    - GROUP
    - LOCATION
    - NAMESPACE
    - NIL (ANY)
    - NUMBER
    - OBJECT
    - STRING
    - TASK
    - TEAM_MEMBER
    - HASHMAP
    - Everything else will simply be stringified.

    modified to support more than 2048 chars - Fyuran

Parameters:
    _object - Object to serialize. <ARRAY, ...>

Returns:
    _json   - JSON string containing serialized object.

Examples:
    (begin example)
        private _settings = call CBA_fnc_createNamespace;
        _settings setVariable ["enabled", true];
        private _json = [_settings] call btc_json_fnc_encodeJSON;
    (end)

Author:
    BaerMitUmlaut CBA team
---------------------------------------------------------------------------- */

params [
    ["_object", nil, []]
];

if (isNil "_object") exitWith { "null" };

switch (typeName _object) do {
    case "SCALAR";
    case "BOOL": {
        str _object;
    };

    case "STRING": {
        {
            _object = [_object, _x#0, _x#1] call CBA_fnc_replace;
        } forEach [
            ["\", "\\"],
            ["""", "\"""],
            [toString [8], "\b"],
            [toString [12], "\f"],
            [endl, "\n"],
            [toString [10], "\n"],
            [toString [13], "\r"],
            [toString [9], "\t"]
        ];
        // Stringify without escaping inter string quote marks.
        """" + _object + """"
    };

    case "ARRAY": {
        if ([_object] call CBA_fnc_isHash) then {
            private _json = (([_object] call CBA_fnc_hashKeys) apply {
                private _name = _x;
                private _value = [_object, _name] call CBA_fnc_hashGet;

                str formatText ["%1: %2", [_name] call btc_json_fnc_encodeJSON, [_value] call btc_json_fnc_encodeJSON]
            }) joinString ", ";
            "{" + _json + "}"
        } else {
            private _json = (_object apply {[_x] call btc_json_fnc_encodeJSON}) joinString ", ";
            "[" + _json + "]"
        };
    };

    case "HASHMAP": {
        private _json = ((_object toArray false) apply {
            _x params ["_key", ["_value", objNull]];

            if !(_key isEqualType "") then {
                _key = str _key;
            };

            str formatText ["%1: %2", [_key] call btc_json_fnc_encodeJSON, [_value] call btc_json_fnc_encodeJSON]
        }) joinString ", ";
        "{" + _json + "}"
    };

    default {
        if !(typeName _object in (supportInfo "u:allVariables*" apply {_x splitString " " select 1})) exitWith {
            [str _object] call btc_json_fnc_encodeJSON
        };

        if (isNull _object) exitWith { "null" };

        private _json = ((allVariables _object) apply {
            private _name = _x;
            private _value = _object getVariable [_name, objNull];

            str formatText ["%1: %2", [_name] call btc_json_fnc_encodeJSON, [_value] call btc_json_fnc_encodeJSON]
        }) joinString ", ";
        "{" + _json + "}"
    };
};