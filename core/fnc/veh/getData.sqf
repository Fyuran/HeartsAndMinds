#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_getData

Description:
    Retrieves data from vehicle

Parameters:
    _object - vehicles to which retrieve data from. [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] call btc_veh_fnc_getData;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */
params[
	["_object", objNull, [objNull]]
];
if(!alive _object) exitWith {
	#ifdef BTC_DEBUG_VEH
	[["%1: _object is dead or null", __FILE_NAME__], 6, "veh"] call btc_debug_fnc_message;
	#endif
};

private _turretsMagazines = magazinesAllTurrets _object;
_turretsMagazines apply {_x resize 3};
_turretsMagazines = _turretsMagazines call BIS_fnc_consolidateArray; //remove repetitions
private _turretsHash = createHashMap;
_turretsMagazines apply { //MAGINFO: [["AMMOCLASS", [TURRETPATH], AMMO], ITERATIONS]
	private _magInfo = _x#0;
	private _magClass = _magInfo#0;
	_magInfo deleteAt 0;
	private _iterations = _x#1; //how many times are we supposed to add this type of mag
	
	_turretsHash set[_magClass, _magInfo + [_x#1]]; //" AMMMO_CLASS : [[TURRETPATH], AMMO, ITERATIONS]  
};

//return data
createHashMapFromArray[
	["typeOf", typeOf _object],
	["positionASL", getPosASL _object],
	["vectorDirAndUp", [vectorDir _object, vectorUp _object]],
	["direction", direction _object],
	["allHitPointsDamage", (getAllHitPointsDamage _object)#2],
	["fuel", fuel _object],
	["turretsMagazines", _turretsHash], //remove from return useless data
	["lock", locked _object],
	["cargo", [_object] call btc_veh_fnc_getCargo],
	["customization", _object call BIS_fnc_getVehicleCustomization],
	["objectTextures", getObjectTextures _object], 
	["name", vehicleVarName _object],
	["isMedicalVehicle", _object call ace_medical_treatment_fnc_isMedicalVehicle],
	["isRepairVehicle", _object call ace_repair_fnc_isRepairVehicle],
	["pylons", getPylonMagazines _object],
	["isContaminated", _object in btc_chem_contaminated],
	["fuelSource", 
		[_object call ace_refuel_fnc_getFuel,
		_object getVariable ["ace_refuel_hooks", []],
		_object getVariable ["btc_EDEN_defaultFuelCargo", _object call ace_refuel_fnc_getFuel]]
	],
	["supplyVehicle",
		[_object call ace_rearm_fnc_isSource,
		_object call ace_rearm_fnc_getSupplyCount,
		_object getVariable ["btc_EDEN_defaultSupply", _object call ace_rearm_fnc_getSupplyCount]]
	],
	["btc_tag_vehicle", _object getVariable ["btc_tag_vehicle", ""]],
	["forcedFlagTexture", getForcedFlagTexture _object],
    ["dogtags", _object call btc_body_fnc_dogtagGet]
]