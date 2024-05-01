
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_drawResources3D

Description:
    Manages resources drawIcon3D on logistic fob objects

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fnc_drawResources3D;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define CONSTANT_K 10

if(!canSuspend) exitWith {
    ["Called in a non suspended envinronment", __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

[{
    remoteExecutedOwner publicVariableClient "btc_log_fob_create_objects";
    remoteExecutedOwner publicVariableClient "btc_log_fob_supply_objects";
}] remoteExecCall ["call", [0, 2] select isMultiplayer];
waitUntil {!(isNil "btc_log_fob_create_objects" && isNil "btc_log_fob_supply_objects")};

btc_log_resources_MEH = addMissionEventHandler ["draw3D", {
    _camera = [curatorCamera, focusOn] select (isNull curatorCamera);
    (btc_log_fob_create_objects + btc_log_fob_supply_objects) apply {     
        _distance = _camera distance _x;
        if(_distance > CONSTANT_K) then { continue };

        _pos = _x modelToWorldVisual [0,0,0.8];
        _screenPosition = worldToScreen _pos;
		if (_screenPosition isEqualTo []) then { continue };

        _k = CONSTANT_K / _distance;
        _alpha = linearConversion[0, CONSTANT_K, _distance, 1, 0, true];

        _flag = _x getVariable ["btc_log_fob_flag", objNull];
        _color = [[1,0,0, _alpha], [0,1,0, _alpha]] select (isNull _flag);
        _resources = [
            _flag getVariable ["btc_log_resources", -1],
            _x getVariable ["btc_log_resources", -1]
        ] select (isNull _flag);

        drawIcon3D [
            "", //texture
            _color, //color
            _pos, //position
            1 * _k, //width
            1 * _k, //height
            0, //angle
            format["%1: %2/%3", localize "STR_BTC_HAM_ACTION_LOGPOINT_RESOURCES", _resources, btc_log_fob_max_resources], //text
            true, //shadow
            0.02 * _k, //textSize
            "RobotoCondensed", //font
            "center", //textAlign
            false, //drawSideArrows
            0, //offsetX
            0 //offsetY
        ];
    };
}];

btc_log_resources_MEH