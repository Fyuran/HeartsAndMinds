
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_reactivation

Description:
    Manages reactivation to repair disabled FOBs.

Parameters:
    _to - the ruins object. [Object]

Returns:

Examples:
    (begin example)
        _result = [] call btc_fob_fnc_reactivation;
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

private _marker = createMarker [format["btc_fobs_ruins_%1", _name], getPosASL _ruins];
_marker setMarkerSize [1, 1];
_marker setMarkerType "b_hq";
_marker setMarkerText format[localize "STR_BTC_HAM_ACTION_FOB_RUINS", _name];
_marker setMarkerColor "ColorCIV";
_marker setMarkerShape "ICON";

private _flagPos = [_ruins] call btc_fnc_getBoundingCornersPos;
_flagPos = selectRandom _flagPos;
_flagPos set [2, 0];
private _flag = createVehicle ["Flag_White_F", _flagPos, [], 0, "NONE"];
[_flag, 0, true] call BIS_fnc_animateFlag;
_flag allowDamage false;

private _actionPos = _flag modelToWorld((boundingCenter _flag) vectorDiff [0.2,0.75,6.4]); //position the action node at the base of the flag
private _actionObj = createVehicle["CBA_NamespaceDummy", _actionPos, [], 0, "CAN_COLLIDE"];

if(btc_debug) then {
    private _sphere = createVehicle ["Sign_Sphere25cm_F", _actionPos, [], 0, "CAN_COLLIDE"];
    _sphere setObjectTextureGlobal [0,'#(argb,8,8,3)color(1,0,1,1,ca)'];
    _sphere attachTo [_actionObj];
};

//Actions
[_actionObj, _name, _flag, _ruins, _marker] remoteExecCall ["btc_fob_fnc_reactivationActions", [0, -2] select isDedicated, _flag];

