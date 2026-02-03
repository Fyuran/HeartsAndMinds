#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_veh_fnc_getCargo

Description:
    Retrieves container data from object

Parameters:
    _object - vehicles to which retrieve cargo data from. [Object]

Returns:

Examples:
    (begin example)
        _result = [cursorObject] call btc_veh_fnc_getCargo;
    (end)

Author:
    =BTC= Fyuran

---------------------------------------------------------------------------- */
params[
	["_object", objNull, [objNull]]
];

private _return = createHashMap;
private _objectContainers = everyContainer _object;
private _dummyHoldersClasses = [];
_objectContainers apply {
    _dummyHoldersClasses pushBackUnique _x#0;
};

//ace containers parsing
private _ace_items = (_object getVariable["ace_cargo_loaded", []]) apply {
    if(_x isEqualType objNull) then {
        [typeOf _x, _x]
    } else {
        [_x, ""] //ace_cargo also stores class names in addition to objects
    };
    
}; //return array similar to everyContainer cmd
private _aceCargo = [];
{
    _x params["_class", "_ref"];
    if(_ref isEqualType objNull) then {
	    _aceCargo pushBack [_class, [_ref] call btc_veh_fnc_getCargo];
    } else {
        _aceCargo pushBack [_class, createHashMap]; //empty JSON object
    };
} forEach _ace_items;
_return set ["ace_containers", _aceCargo];

//containers parsing
private _containers = [];
{
    _x params["_class", "_refObj"];
	_containers pushBack [_class, [_refObj] call btc_veh_fnc_getCargo];
}forEach _objectContainers;

_return set ["containers", _containers];

//itemCargo parsing
private _itemCargo = itemCargo _object;
_itemCargo = _itemCargo call BIS_fnc_consolidateArray;
//remove item holders
_itemCargo = _itemCargo select {
    _x params["_class"];
    !(_class in _dummyHoldersClasses);
};
private _itemsCargoHash = createHashMapFromArray _itemCargo;
_return set ["itemCargo", _itemsCargoHash];


/* //backpack parsing
private _backpacksCargo = getBackpackCargo _object;
_backpacksCargo params[["_backpacks", []], ["_counts", []]];
private _backpacksCargoHash = createHashMap;
{
	_backpacksCargoHash set [_x, _counts#_forEachIndex];
}forEach _backpacks;

_return set ["backpackCargo", _backpacksCargoHash]; */


//magazines parsing
private _magazineCargo = getMagazineCargo _object;
_magazineCargo params[["_magazines", []], ["_counts", []]];
private _magazinesCargoHash = createHashMap;
{
	_magazinesCargoHash set [_x, _counts#_forEachIndex];
}forEach _magazines;

_return set ["magazineCargo", _magazinesCargoHash];

//weapons parsing
private _weaponsCargo = getWeaponCargo _object;
_weaponsCargo params[["_weapons", []], ["_counts", []]];
private _weaponsCargoHash = createHashMap;
{
	_weaponsCargoHash set [_x, _counts#_forEachIndex];
}forEach _weapons;

_return set ["weaponCargo", _weaponsCargoHash];


//ace_cargo_customName
private _customName = _object getVariable ["ace_cargo_customName", ""];
_return set ["ace_cargo_customName", _object getVariable ["ace_cargo_customName", ""]];

_return