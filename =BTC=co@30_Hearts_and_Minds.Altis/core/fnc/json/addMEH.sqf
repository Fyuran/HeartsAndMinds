
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_addMEH;

Description:
    Adds a MissionEventHandler that will handle loading JSON data into var.

Parameters:
    

Returns:
    JASOOOON
Examples:
    (begin example)
        [] call btc_json_fnc_addMEH;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

btc_JSON_MEH = addMissionEventHandler ["ExtensionCallback", {
	params ["_name", "_function", "_data"];
    
    if(_name isNotEqualTo "btc_ArmaToJSON") exitWith {};

    if (btc_debug) then {
        [format["CallExtension returning data: %1", _this], __FILE__, [btc_debug, true, false]] call btc_debug_fnc_message;
    };

    if(_function isEqualTo "EXCEPTION") exitWith {
        [format["%1", _data], __FILE__, nil, true] call btc_debug_fnc_message;
    };
    if(_function isEqualTo "FinishedLoading") exitWith {
        [] call btc_json_fnc_load;
    };

    if(isNil "btc_JSON_data") then {
        btc_JSON_data = createHashMapFromArray[];
    };

    // format will be first: [ "main_key", "secondary_key", "map_key"]
    // second: "data"
    _function = parseSimpleArray _function;
    _function params [        
        ["_main_key", "", [""]],  //cities, markers...
        ["_secondary_key", "", []], //"Panochori", "Mine"...
        ["_third_key", "", []] //"data_units", "data_animals"...
    ];
    _third_key = "_" + _third_key; //so keys can be used as params var names, i'm very very lazy.


    _parsedData = [];
    if(_third_key isEqualTo "_medical_status") then {
        _parsedData = [_data, 2] call CBA_fnc_parseJSON;
    } else {
        _parsedData = (parseSimpleArray _data) select 0;
    };
 
    private _firstHash = btc_JSON_data getOrDefault [_main_key, createHashMap];
    private _secondHash = _firstHash getOrDefault [_secondary_key, createHashMap];

    _firstHash set [_secondary_key, _secondHash];
    _secondHash set [_third_key, _parsedData];
    btc_JSON_data set [_main_key, _firstHash];
  
}];