
/* ----------------------------------------------------------------------------
Function: btc_db_fnc_saveObjectStatus

Description:
    Save all data from an object like position, ACE cargo, inventory ...

Parameters:
    _object - Object to get data. [Object]

Returns:
    _data - Data array (type, position, direction ...). [Array]

Examples:
    (begin example)
        [cursorObject] call btc_db_fnc_saveObjectStatus;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

params [
    ["_object", objNull, [objNull]]
];


private _cargo = (_object getVariable ["ace_cargo_loaded", []]) apply {
    if (_x isEqualType "") then {
        [_x, nil, [[], [], []]]
    } else {
        [
            typeOf _x,
            nil,
            _x call btc_log_fnc_inventoryGet,
            _x in btc_chem_contaminated,
            _x call btc_body_fnc_dogtagGet,
            magazinesAllTurrets _x,
            _x getVariable ["ace_cargo_customName", ""],
            [_x] call btc_veh_fnc_propertiesGet
        ]
    };    
};

[
    typeOf _object,
    getPosASL _object,
    getDir _object,
    "",
    _cargo,
    _object call btc_log_fnc_inventoryGet,
    [vectorDir _object, vectorUp _object],
    _object in btc_chem_contaminated,
    _object call btc_body_fnc_dogtagGet,
    getForcedFlagTexture _object,
    magazinesAllTurrets _object,
    _object getVariable ["ace_cargo_customName", ""],
    _object getVariable ["btc_tag_vehicle", ""],
    [_object] call btc_veh_fnc_propertiesGet
]
