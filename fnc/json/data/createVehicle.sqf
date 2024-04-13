
/* ----------------------------------------------------------------------------
Function: btc_json_fnc_createVehicle

Description:
    Creates an empty object of given classname type.

Parameters:
    _veh_type - Vehicle className. [String]
    _veh_pos - Desired placement position. [Array]
    _veh_dir - Desired direction. [Number]
    _customization - Customized appearance [Array]
    _isMedicalVehicle - Set the ACE parameter is a medical vehicle. [Boolean]
    _isRepairVehicle - Set the ACE parameter is a repair vehicle. [Boolean]
    _fuelSource - Define the ACE cargo fuel source. [Array]
    _pylons - Set pylon loadout. [Array]
    _isContaminated - Set a vehicle contaminated. [Boolean]
    _supplyVehicle - Is supply vehicle and current supply count. [Boolean]
    _EDENinventory - Load EDEN inventory define in mission.sqm. [Array]
    _veh_allHitPointsDamage - Apply hit point damage to the vehicle. [Array]

Returns:

Examples:
    (begin example)
        _veh = ["vehicle_class_name", getPos player] call btc_json_fnc_createVehicle;
    (end)

Author:
    Vdauphin, Fyuran

---------------------------------------------------------------------------- */


params [
    ["_veh_type", "", [""]],
    ["_veh_pos", [0, 0, 0], [[]]],
    ["_veh_dir", 0, [0]],
    ["_veh_fuel", 1, [0]],
    ["_veh_allHitPointsDamage", [], [[]]],
    ["_veh_cargo", [], []],
    ["_veh_inventory", [], []],
    ["_EDENinventory", [], [[]]],
    ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]]],
    ["_flagTexture", "", [""]],
    ["_turretMagazines", [],[]],
    ["_tagTexture", "", [""]],
    ["_properties", [], [[]], 8]
];
_properties params [
    ["_customization", [false, false], [[]]],
    ["_isMedicalVehicle", false, [true]],
    ["_isRepairVehicle", false, [true]],
    ["_fuelSource", [], [[]]],
    ["_pylons", [], [[]]],
    ["_isContaminated", false, [false]],
    ["_supplyVehicle", [], [[]]],
    ["_objectTexture", [], [[]]]
];

if(_veh_pos isEqualTo [0,0,0]) exitWith {
    [format ["invalid _veh_pos"], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _veh  = createVehicle [_veh_type, _veh_pos, [], 0, "CAN_COLLIDE"];
_veh setDir _veh_dir;
_veh setPosATL _veh_pos;
_veh setFuel _veh_fuel;
_veh setVectorDirAndUp _vectorDirAndUp;
[_veh, _turretMagazines] call btc_db_fnc_setTurretMagazines;

[_veh, _cargo, _inventory] call btc_db_fnc_loadCargo;

if (_EDENinventory isNotEqualTo []) then {
    _veh setVariable ["btc_EDENinventory", _EDENinventory];
    [_veh, _EDENinventory] call btc_log_fnc_inventorySet;
};

if (unitIsUAV _veh) then {
    createVehicleCrew _veh;
};

if (_veh_allHitPointsDamage isNotEqualTo []) then {
    {//Disable explosion effect on vehicle creation
        [_veh, _forEachindex, _x, false] call ace_repair_fnc_setHitPointDamage;
    } forEach (_veh_allHitPointsDamage select 2);
    if ((_veh_allHitPointsDamage select 2) select {_x < 1} isEqualTo []) then {
        _veh setDamage [1, false];
    };
};

if (_flagTexture isNotEqualTo "") then {
    _veh forceFlagTexture _flagTexture;
};

if (_tagTexture isNotEqualTo "") then {
    [objNull, [], _tagTexture, _veh, objNull, "", "", true] call ace_tagging_fnc_createTag;
};

[_veh, _customization, _isMedicalVehicle,
    _isRepairVehicle, _fuelSource, _pylons,
        _isContaminated, _supplyVehicle, _objectTexture] call btc_veh_fnc_propertiesSet;

_veh call btc_veh_fnc_add;

_veh
