
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
    Fyuran

---------------------------------------------------------------------------- */
params[
	["_object", objNull, [objNull]]
];

private _return = createHashMap;

//ace containers parsing
private _items = (_object getVariable["ace_cargo_loaded", []]) apply {
    if(_x isEqualType objNull) then {
        [typeOf _x, _x]
    } else {
        [_x, ""] //ace_cargo also stores class names in addition to objects
    };
    
}; //return array similiar to everyContainer cmd
private _itemsData = _items apply {
    _x params["_class", "_obj"];
    if(_obj isEqualType objNull) then {
	    createHashMapFromArray[[_class, [_obj] call btc_veh_fnc_getCargo]]
    } else {
        createHashMapFromArray[[_class, createHashMap]]
    };
};
_return set ["ace_containers", _itemsData];

//arma containers parsing
_items = everyContainer _object;
_itemsData = _items apply {
	createHashMapFromArray[[_x#0, [_x#1] call btc_veh_fnc_getCargo]]
};
_return set ["containers", _itemsData];

//itemCargo parsing
private _cargo = itemCargo _object;
_cargo = _cargo call BIS_fnc_consolidateArray;
private _itemsHash = createHashMapFromArray _cargo;
_return set ["itemCargo", _itemsHash];


//backpack parsing
_cargo = getBackpackCargo _object;
_cargo params[["_items", []], ["_counts", []]];
_itemsHash = createHashMap;
{
	_itemsHash set [_x, _counts#_forEachIndex];
}forEach _items;

_return set ["backpackCargo", _itemsHash];


//magazines parsing
_cargo = getMagazineCargo _object;
_cargo params[["_items", []], ["_counts", []]];
_itemsHash = createHashMap;
{
	_itemsHash set [_x, _counts#_forEachIndex];
}forEach _items;

_return set ["magazineCargo", _itemsHash];

//weapons parsing
_cargo = getWeaponCargo _object;
_cargo params[["_items", []], ["_counts", []]];
_itemsHash = createHashMap;
{
	_itemsHash set [_x, _counts#_forEachIndex];
}forEach _items;

_return set ["weaponCargo", _itemsHash];


//ace_cargo_customName
private _customName = _object getVariable ["ace_cargo_customName", ""];
_return set ["ace_cargo_customName", _object getVariable ["ace_cargo_customName", ""]];

_return