
/* ----------------------------------------------------------------------------
Function: btc_log_fob_fnc_drawResources3D

Description:
    Manages resources drawIcon3D on logistic fob objects

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_log_fob_fnc_drawResources3D;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define CONSTANT_K 10

[{
    remoteExecutedOwner publicVariableClient "btc_log_fob_create_objects";
    remoteExecutedOwner publicVariableClient "btc_log_fob_supply_objects";
}] remoteExecCall ["call", [0, 2] select isMultiplayer];

btc_log_resources_MEH = addMissionEventHandler ["draw3D", {
    (btc_log_fob_create_objects + btc_log_fob_supply_objects) apply {
        _camera = [curatorCamera, focusOn] select (isNull curatorCamera);
        _type = typeOf _x;

        _bbrMax = (boundingBox _x)#1;
        _height = (_bbrMax#2) + 0.2; 
        _pos = (getPosWorld _x) vectorAdd [0,0,_height];
         
        _screenPosition = worldToScreen (_x modelToWorldVisual [0,0,_height]);
		if (_screenPosition isEqualTo []) then { continue };
        // _visible = [_x, "VIEW", _camera] checkVisibility [getPosASL _camera, _pos];
        // if (_visible < 0.8) then { continue };
        _intersections = lineIntersectsSurfaces [eyePos _camera, _pos, _x, _camera, true, 1];
        if (_intersections isNotEqualTo []) then { continue };
        if(_type isEqualTo (btc_log_fob_create_obj_resupply#0)) then { continue }; //skip packed-up log fob objs

        _distance = _camera distance _x;
        _k = CONSTANT_K / _distance;
        _alpha = linearConversion[0, CONSTANT_K, _distance+0.2, 1, 0, true];
        _resources = _x getVariable ["btc_log_resources", 0];

        _color = [[0,1,0, _alpha], [1,0,0, _alpha]] select (_type isEqualTo btc_log_fob_create_obj);

        drawIcon3D [
            "", //texture
            _color, //color
            ASLtoAGL _pos, //position
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