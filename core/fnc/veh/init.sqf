#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_init

Description:
    Add custom ACE interaction depends one vehicle type (static weapon, land vehicle, helicopter and ship).

Parameters:
    _type - Type of vehicle to add custom ACE interaction. [String]

Returns:

Examples:
    (begin example)
        ["B_Truck_01_fuel_F"] call btc_veh_fnc_init;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params [
    ["_type", "", [""]],
    ["_vehicle", objNull, [objNull]]
];

if (isNil "btc_actions_veh") then {btc_actions_veh = [];};
if ((btc_actions_veh pushBackUnique _type) isEqualTo -1) exitWith {};
#ifdef BTC_DEBUG_VEH
[["%1: for %2 at %3", __FILE_NAME__, _vehicle, getPosASL _vehicle], 2, "veh"] call btc_debug_fnc_message;
#endif
switch true do {
    case (_type isKindOf "UGV_02_Base_F") : {};
    case (_type isKindOf "StaticWeapon") : {};
    case (_type isKindOf "LandVehicle" || {_type isKindOf "Ship"}) : {
        _type call btc_tow_fnc_int;

        _type call btc_flag_fnc_int;
    };
    case (_type isKindOf "Helicopter") : {
        _type call btc_tow_fnc_int;

        //Lift Fncs
        #ifdef BTC_DEBUG_VEH
        if(!isClass (configFile >> "CfgPatches" >> "btc_lift")) then {
            [["%1: btc_lift addon is NOT loaded, adding HeM native lift for %2 at %3", __FILE_NAME__, _vehicle, getPosASL _vehicle], 2, "veh"] call btc_debug_fnc_message;
            [] call btc_lift_fnc_addActions;
        } else {
            [["%1: btc_lift is loaded, aborting HeM native lift for %2 at %3", __FILE_NAME__, _vehicle, getPosASL _vehicle], 2, "veh"] call btc_debug_fnc_message;
        };
        #else
        if(!isClass (configFile >> "CfgPatches" >> "btc_lift")) then {
            [] call btc_lift_fnc_addActions;
        };
        #endif

        _type call btc_flag_fnc_int;
    };
    case (_type isKindOf "Plane") : {
        _type call btc_tow_fnc_int;
    };
};


