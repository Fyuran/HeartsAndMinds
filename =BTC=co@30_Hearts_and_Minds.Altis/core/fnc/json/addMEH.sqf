
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
if(!isNil "btc_JSON_MEH") exitWith {};

btc_JSON_MEH = addMissionEventHandler ["ExtensionCallback", {
	params ["_name", "_function", "_data"];
    
    if(_name isNotEqualTo "btc_ArmaToJSON") exitWith {};
    if(!isNil "btc_JSON_data") exitWith {}; //avoid multiple reloads, preInit is fickle

    if (btc_debug) then {
        [format["CallExtension returning data: %1", _this], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
    };
    if(_function isEqualTo "EXCEPTION") exitWith {
        [format["%1", _data], __FILE__, nil, true] call btc_debug_fnc_message;
    };
    if(_function isEqualTo "FinishedLoading") exitWith {
        removeMissionEventHandler ["ExtensionCallback", _thisEventHandler];
        [] call btc_json_fnc_parse_data;
    };
    if(isNil "btc_JSON") then {
        btc_JSON = [];
    };
    
    btc_JSON pushBack[_function, _data];

}];