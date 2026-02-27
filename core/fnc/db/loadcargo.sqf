#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_db_fnc_loadCargo

Description:
    Load ACE cargo and inventory of a vehicle/container.

Parameters:
    _obj - Vehicle or container. [Object]
    _cargo - Object to load in ACE cargo. [Array]
    _inventory - Weapon and item to load in inventory. [Array]

Returns:

Examples:
    (begin example)
        _result = [] call btc_db_fnc_loadCargo;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

[{
    params ["_obj", "_cargo", "_inventory"];

    //handle cargo
    {
        _x params ["_type", "", "_inventory",
            ["_isContaminated", false, [false]],
            ["_dogtagDataTaken", [], [[]]],
            ["_turretMagazines", [], [[]]],
            ["_customName", "", [""]],
            ["_properties", [], [[]]]
        ];

        private _l = createVehicle [_type, getPosATL _obj, [], 0, "CAN_COLLIDE"];
        [_l] call FUNC(log,init);
        private _isloaded = [_l, _obj, false] call ace_cargo_fnc_loadItem;
        #ifdef BTC_DEBUG_DB
        [["%1: Object loaded: %2 in veh/container %3 IsLoaded: %4", __FILE_NAME__, _l, _obj, _isloaded], 2, "db"] call FUNC(debug,message);
        #endif
        [_l, _inventory] call FUNC(log,inventorySet);

        if (_isContaminated) then {
            btc_chem_contaminated pushBack _l;
            publicVariable "btc_chem_contaminated";
        };

        [_l, _dogtagDataTaken] call FUNC(body,dogtagSet);

        if (_turretMagazines isNotEqualTo []) then {
            [_l, _turretMagazines] call FUNC(db,setTurretMagazines);
        };

        if (_customName isNotEqualTo "") then {
            _l setVariable ["ace_cargo_customName", _customName, true];
        };

        if (unitIsUAV _l) then {
            createVehicleCrew _l;
        };

        if (_properties isNotEqualTo []) then {
            ([_l] + _properties) call FUNC(veh,propertiesSet);
        };
    } forEach _cargo;

    //set inventory content for weapons, magazines and items
    [_obj, _inventory] call FUNC(log,inventorySet);
}, _this] call CBA_fnc_execNextFrame;
