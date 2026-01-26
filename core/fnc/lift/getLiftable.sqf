#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_lift_fnc_getLiftable

Description:
    Fill me when you edit me !

Parameters:
    _heli - [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_lift_fnc_getLiftable;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

params ["_heli"];

private _array = [];
switch (typeOf _heli) do {
    case "B_SDV_01_F" : {
        _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "StaticWeapon", "Car", "Truck", "Wheeled_APC_F", "Tracked_APC", "APC_Tracked_01_base_F", "APC_Tracked_02_base_F", "Air", "Ship", "Tank"] + ((btc_construction_array select 1) select 3) + ((btc_construction_array select 1) select 4) + ((btc_construction_array select 1) select 5);
    };
    default {
        private _MaxCargoMass = getNumber (configOf _heli >> "slingLoadMaxCargoMass");
        switch (true) do {
            case (_MaxCargoMass <= 510) : {
                _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "Quadbike_01_base_F", "Strategic"];
            };
            case (_MaxCargoMass <= 2100) : {
                _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "StaticWeapon", "Car"];
            };
            case (_MaxCargoMass <= 4100) : {
                _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "StaticWeapon", "Car", "Truck_F", "Truck", "Wheeled_APC_F", "Air", "Ship"] + ((btc_construction_array select 1) select 3) + ((btc_construction_array select 1) select 4) + ((btc_construction_array select 1) select 5) + ((btc_construction_array select 1) select 8);
            };
            case (_MaxCargoMass <= 14000) : {
                _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "StaticWeapon", "Car", "Truck_F", "Truck", "Wheeled_APC_F", "Tracked_APC", "APC_Tracked_01_base_F", "APC_Tracked_02_base_F", "Air", "Ship", "Tank"] + ((btc_construction_array select 1) select 3) + ((btc_construction_array select 1) select 4) + ((btc_construction_array select 1) select 5) + ((btc_construction_array select 1) select 8);
            };
            default {
                _array = ["Motorcycle", "ReammoBox", "ReammoBox_F", "StaticWeapon", "Car", "Truck_F", "Truck", "Wheeled_APC_F", "Tracked_APC", "APC_Tracked_01_base_F", "APC_Tracked_02_base_F", "Air", "Ship", "Tank"] + ((btc_construction_array select 1) select 3) + ((btc_construction_array select 1) select 4) + ((btc_construction_array select 1) select 5) + ((btc_construction_array select 1) select 8);
            };
        };
    };
};
_array