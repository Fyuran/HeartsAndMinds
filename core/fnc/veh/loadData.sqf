#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_loadData

Description:
    Loads data for vehicle

Parameters:
    _object - vehicles to which load data to. [Object]
    _hash - passed hash by btc_veh_fnc_getData

Returns:

Examples:
    (begin example)
        _result = [cursorObject, createHashMap] call btc_veh_fnc_loadData;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */
if(!params[
	["_object", objNull, [objNull]],
	["_hash", createHashMap, [createHashMap]]
]) exitWith {
	#ifdef BTC_DEBUG_VEH
	[["%1: bad params", __FILE_NAME__], 6, "veh"] call btc_debug_fnc_message;	
	#endif
};
if(!alive _object) exitWith {
	#ifdef BTC_DEBUG_VEH
	[["_object is dead or null", __FILE_NAME__], 6, "veh"] call btc_debug_fnc_message;
	#endif
};

/*
[
	typeOf
	positionASL
	vectorDirAndUp
	allHitPointsDamage
	fuel
	turretsMagazines
	lock
	cargo
	customization
	objectTextures
	name
	isMedicalVehicle
	isRepairVehicle
	pylons
	isContaminated
	fuelSource
	supplyVehicle
	btc_tag_vehicle
	forcedFlagTexture
]
*/
(values _hash) params ((keys _hash) apply {"_" + _x});

if((typeOf _object) isNotEqualTo _typeOf) exitWith {
	#ifdef BTC_DEBUG_VEH
	[["%1: _object type not same type as data", __FILE_NAME__], 6, "veh"] call btc_debug_fnc_message;
	#endif
};

_object forceFlagTexture _forcedFlagTexture;
[_object, _dogtagDataTaken] call btc_body_fnc_dogtagSet;
_object setFuel _fuel;
_object lock _lock;

[
    _object, _customization, _isMedicalVehicle,
    _isRepairVehicle, _fuelSource, _pylons,
    _isContaminated, _supplyVehicle, _objectTextures
] call btc_veh_fnc_propertiesSet;
[_object] call btc_veh_fnc_propertiesSet;

if (_name != "") then {
    [_object, _name] remoteExecCall["setVehicleVarName", 0, _object];
    missionNamespace setVariable [_name, _object, true];
    _object setvariable ["#var", _name, true]; //BIS vanilla compatibility
};

if (unitIsUAV _object) then {
    createVehicleCrew _object;
};

if (_customName isNotEqualTo "") then {
    _object setVariable ["ace_cargo_customName", _customName, true];
};

if (_btc_tag_vehicle isNotEqualTo "") then {
    [objNull, [], _btc_tag_vehicle, _object, objNull, "", "", true] call ace_tagging_fnc_createTag;
};

if(_allHitPointsDamage isNotEqualTo []) then {
	private _allHitPoints = getAllHitPointsDamage _object;
	_allHitPoints set [2, _allHitPointsDamage];
	_allHitPoints params[
		["_hitpoints", [],[[]]],
		["_selections", [], [[]]],
		["_damage", [],[]]
	];

	{
		private _hitpoint = _hitpoints select _forEachIndex;
		if(_hitpoint isNotEqualTo "") then {
			_object setHitPointDamage [_hitpoint, _x, false, objNull, objNull, true]; //for hitpoints
		};

		private _selection = _selections select _forEachIndex;
		if(_selection isNotEqualTo "") then {
			_object setHit [_selection, _x, false, objNull, objNull, true]; //for selections
		};
	}forEach _damage;
};

if (_cargo isNotEqualTo []) then {
    [_object, _cargo] call btc_veh_fnc_loadCargo;
};