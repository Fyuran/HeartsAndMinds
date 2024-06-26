
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_ruins

Description:
    Manages ruins to repair disabled FOBs.

Parameters:

Returns:

Examples:
    (begin example)
        _result = [] call btc_fob_fnc_ruins;
    (end)

Author:
     Fyuran

---------------------------------------------------------------------------- */
params [
    ["_fob", objNull, [objNull]],
    ["_ruins", objNull, [objNull]]
];

private _name = _ruins getVariable ["FOB_name", "UNKNOWN"];
if(!isNull _fob) then { //validates calls from db_load
    _name = _fob getVariable ["FOB_name", "UNKNOWN"];
    private _pos = getPosASL _fob;
    btc_fobs_ruins set [_name, [_pos, getDir _fob, typeOf _ruins, _name]];
};
if(isNull _ruins) exitWith {
    [format["_ruins is null"], __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
};

private _marker = createMarkerLocal [format["btc_fobs_ruins_%1", _name], getPosASL _ruins];
_marker setMarkerSizeLocal [1, 1];
_marker setMarkerTypeLocal "b_hq";
_marker setMarkerTextLocal format[localize "STR_BTC_HAM_ACTION_FOB_RUINS", _name];
_marker setMarkerColorLocal "ColorCIV";
_marker setMarkerShape "ICON";

private _flagPos = [_ruins] call btc_fnc_getBoundingCornersPos;
_flagPos = selectRandom _flagPos;
_flagPos set [2, 0];
private _flag = createVehicle ["Flag_White_F", _flagPos, [], 0, "NONE"];
_flag allowDamage false;

[{
    [_this, 0, true] call BIS_fnc_animateFlag;
}, _flag] call CBA_fnc_execNextFrame;

private _actionPos = _flag modelToWorld((boundingCenter _flag) vectorDiff [0.2,0.75,6.4]); //position the action node at the base of the flag
private _actionObj = createVehicle["CBA_NamespaceDummy", _actionPos, [], 0, "CAN_COLLIDE"];
[_actionObj, _flag] call BIS_fnc_attachToRelative;

if(btc_debug) then {
    private _sphere = createVehicle ["Sign_Sphere25cm_F", _actionPos, [], 0, "CAN_COLLIDE"];
    _sphere setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0,1,1,ca)'];
    _sphere attachTo [_actionObj];
};

//Actions
[_actionObj, _name, _flag, _ruins, _marker] remoteExecCall ["btc_fob_fnc_reactivationActions", [0, -2] select isDedicated, _flag];

