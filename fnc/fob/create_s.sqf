
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_create_s

Description:
   Create the FOB.

Parameters:
    _pos - Position of the FOB. [Array]
    _direction - Direction of the FOB between 0 to 360 degree. [Number]
    _FOB_name - Name of the FOB. [String]


Returns:
    _array - Return marker, structure and flag object. [Array]

Examples:
    (begin example)
        [getPos player, random 360, "My FOB"] call btc_fob_fnc_create_s;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#include "..\script_macros.hpp"

params [
    ["_pos", [], [[]]],
    ["_direction", 0, [0]],
    ["_FOB_name", "FOB ", [""]],
    ["_jailData", [], [[]]],
    ["_logObjData", [], [[]]],
    ["_resources", -1, [0]]
];

if(btc_debug) then {
    [format["%1", _this],
            __FILE__, [false, btc_debug_log, false], false] call btc_debug_fnc_message;  
};

private _building = createVehicle [btc_fob_structure, _pos, [], 0, "CAN_COLLIDE"];
_building setDir _direction;
private _flag = createVehicle [btc_fob_flag, _pos, [], 0, "CAN_COLLIDE"];
private _loudspeaker = createVehicle ["Land_Loudspeakers_F", _pos, [], 0, "CAN_COLLIDE"];

//JAIL
if(_jailData isNotEqualTo []) then {
    _jailData params [
        ["_pos", [0,0,0], [], 3],
        ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2]
    ];
    [_flag, _pos, _vectorDirAndUp] call btc_jail_fnc_createJail_s;
};

//LOG OBJ
_flag setVariable ["btc_log_resources", _resources];
if(_logObjData isNotEqualTo []) then {
    _logObjData params [
        ["_pos", [0,0,0], [], 3],
        ["_vectorDirAndUp", [[0,1,0],[0,0,1]], [[]], 2]
    ];
    [_flag, _pos, _vectorDirAndUp, _resources] call btc_log_fob_fnc_logObj_s;
};

(btc_fobs select 1) pushBack _building;
(btc_fobs select 2) pushBack _flag;
(btc_fobs select 3) pushBack _loudspeaker;

_building setVariable["FOB_name", _FOB_name, true];
_building setVariable["FOB_Loudspeaker", _loudspeaker];
private _BISEH_return = [btc_player_side, _flag, _FOB_name] call BIS_fnc_addRespawnPosition;
_building setVariable["FOB_Respawn_EH", _BISEH_return];
_building setVariable["FOB_Flag", _flag];
_flag setVariable["FOB", _building];

[_flag, "Deleted", {[_thisArgs select 0, _thisArgs select 1] call BIS_fnc_removeRespawnPosition}, _BISEH_return] call CBA_fnc_addBISEventHandler;
_building addEventHandler ["Killed", btc_fob_fnc_killed];

private _marker = createMarkerLocal [_FOB_name, _pos];
_marker setMarkerSizeLocal [1, 1];
_marker setMarkerTypeLocal "b_hq";
_marker setMarkerTextLocal _FOB_name;
_marker setMarkerColorLocal "ColorBlue";
_marker setMarkerShape "ICON";
(btc_fobs select 0) pushBack _marker;

//Garrison
if(btc_p_fob_garrison) then {
    if (btc_type_friendly_units isEqualTo []) exitWith {
        ["no suitable classes found for fob garrison", __FILE__, [btc_debug, btc_debug_log, true], true] call btc_debug_fnc_message;
    };
    [{[_this, btc_player_side, btc_type_friendly_units, true] call btc_garrison_fnc_spawn;}, _building] call CBA_fnc_execNextFrame;
};

//Alarm FOB Trigger
private _structBoundingSphere = sizeOf btc_fob_structure;
private _alertRadius = _structBoundingSphere + btc_fob_alertRadius;
private _conquestRadius = _structBoundingSphere + btc_fob_conquestRadius;

private _alarmTrg = createTrigger ["EmptyDetector", _pos, false];
_alarmTrg setTriggerArea [_alertRadius, _alertRadius, 0, false];
_alarmTrg setTriggerActivation [format["%1",btc_enemy_side], "PRESENT", true];

private _alarmTrgStatementOn = "
    [thisTrigger, thisList] call btc_fob_fnc_alarmTrg;
";
_alarmTrg setTriggerStatements ["this", _alarmTrgStatementOn, ""];

if (btc_debug) then {
    private _marker = createMarkerLocal [format ["fob_%1", _FOB_name],_alarmTrg];
    _marker setMarkerShapeLocal "ELLIPSE";
    _marker setMarkerBrushLocal "SolidBorder";
    _marker setMarkerSizeLocal [_alertRadius, _alertRadius];
    _marker setMarkerAlphaLocal 0.3;
    _marker setMarkerColor "ColorBlue";

    _pos params ["_posx", "_posy"];
    private _marke = createMarkerLocal [format ["fobn_%1",  _FOB_name], [_posx+10, _posy+10, 0]];
    _marke setMarkerTypeLocal "Contact_dot1";
    _marke setMarkerColorLocal "ColorBlue";
    private _spaces = "";
    for "_i" from 0 to count _FOB_name -1 do {
        _spaces = _spaces + " ";
    };
    _marke setMarkerText format [_spaces + "%1: alarm trigger range", _FOB_name];
    _building setVariable["alarmTrgMarker", [_marker, _marke]];
};

//Destroy FOB Trigger
private _destroyTrg = createTrigger ["EmptyDetector", _pos, false];
_destroyTrg setTriggerArea [_conquestRadius, _conquestRadius, 0, false];
_destroyTrg setTriggerActivation [format["%1",btc_enemy_side], "PRESENT", true];

private _destroyTrgStatementOn = "
    [thisTrigger] call btc_fob_fnc_destroyTrg;
";
_destroyTrg setTriggerStatements ["this && {round (CBA_missionTime % 1) == 0}", _destroyTrgStatementOn, ""];
_destroyTrg setTriggerInterval 0.2;

if (btc_debug) then {
    private _marker = createMarkerLocal [format ["fob_c%1", _FOB_name],_destroyTrg];
    _marker setMarkerShapeLocal "ELLIPSE";
    _marker setMarkerBrushLocal "SolidBorder";
    _marker setMarkerSizeLocal [_conquestRadius, _conquestRadius];
    _marker setMarkerAlphaLocal 0.4;
    _marker setMarkerColor "ColorPink";

    _pos params ["_posx", "_posy"];
    private _marke = createMarkerLocal [format ["fobn_c%1",  _FOB_name], [_posx-10, _posy-10, 0]];
    _marke setMarkerTypeLocal "Contact_dot1";
    _marke setMarkerColorLocal "ColorPink";
    private _spaces = "";
    for "_i" from 0 to count _FOB_name -1 do {
        _spaces = _spaces + " ";
    };
    _marke setMarkerText format [_spaces + "%1: conquest range", _FOB_name];
    _building setVariable["destroyTrgMarker", [_marker, _marke]];
};

_alarmTrg setVariable["btc_fob_structure", _building];
_destroyTrg setVariable["btc_fob_structure", _building];
_building setVariable["FOB_Triggers", [_alarmTrg, _destroyTrg]];

(btc_fobs select 4) pushBack [_alarmTrg, _destroyTrg];

[_marker, _building, _flag, _loudspeaker, jail]
