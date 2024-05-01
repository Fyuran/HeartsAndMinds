
/* ----------------------------------------------------------------------------
Function: btc_log_dialog_fnc_init_tables

Description:

Parameters:
    Initializes table for every btc_construction_array object
    sizeOf requires at least one object of the given classname has to be present in the current mission otherwise zero will be returned.

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_dialog_fnc_init_tables;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

(missionNamespace getVariable ["btc_construction_array", []]) params [
    ["_main_classes", [], [[]]], 
    ["_sub_classes", [], [[]]]
];
if(btc_construction_array isEqualTo []) exitWith {
    ["btc_construction_array is empty no cost table initialized", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};
if(count _main_classes isNotEqualTo count _sub_classes) exitWith {
    ["btc_construction_array: different sizes of main_classes and sub_classes", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _tables = createHashMap;
private _cfg = configFile >> "CfgVehicles";

(flatten _sub_classes) apply {
    private _displayName = getText (_cfg >> _x >> "displayName");
    if (not(_x isKindOf "Thing") && {not(_x isKindOf "Building")}) then { //some camo variations
        private _sideID = getNumber (_cfg >> _x >> "side");
        _displayName = format["%1(%2)", _displayName, _sideID call BIS_fnc_sideType];
    };

    //avoid TFAR_antennas_fnc_initRadioTower from triggering until it's ready to be deployed
    private _class = _x;
    if(_x in ((btc_construction_array select 1) select 8)) then {
        
        private _sourceAddonList = configSourceAddonList (_cfg >> _x);
        if("tfar_antennas" in _sourceAddonList) then {
            _class = configName (inheritsFrom (_cfg >> _x)); //get the parent class it's derived from
        };
    };
    
	private _obj = createVehicleLocal [_class, [0,0,0], [], 0, "CAN_COLLIDE"];
	private _cost = round(sizeOf _x) * btc_p_log_cost_multiplier;
	deleteVehicle _obj;
	_tables set [_x, [_displayName, _cost]];
};

if(btc_debug_log) then {
    [format["btc_log_dialog_tables initialized"], __FILE__, [false, btc_debug_log, false]] call btc_debug_fnc_message;
};

missionNamespace setVariable ["btc_log_dialog_tables", _tables];