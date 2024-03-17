
/* ----------------------------------------------------------------------------
Function: btc_fnc_debug_marker_show_fps

Description:
    Inserts marker which holds fps and display it on the map

Parameters:

Returns:

Examples:
    (begin example)
    (end)

Author:
    =BTC=Fyuran

---------------------------------------------------------------------------- */
#define _MARKER_SIZE 0.7
params[
	["_sourcestr","",[""]],
	["_corner",[-200,0],[[]],2],
	["_distance",200,[0]],
	["_slot",0,[0]]
];
_corner params ["_corner_x","_corner_y"];
private _myfpsmarker = createMarker [ format ["fpsmarker%1", _sourcestr ], [ _corner_x, _corner_y - (_distance * _slot) ] ];
_myfpsmarker setMarkerType "mil_start";
_myfpsmarker setMarkerSize [ _MARKER_SIZE, _MARKER_SIZE ];
private _handle=[{
	_args params ["_myfpsmarker","_sourcestr"];
	_myfps = round diag_fps;
	_localagents = { local _x } count (entities "Man" - allUnits);
	_localunits = { local _x } count entities "CAManBase";
	_localvehicles = { local _x } count vehicles;
	_localgroups = {local _x} count allGroups;

	_myfpsmarker setMarkerText format [ "%1: %2 fps, %3 agents, %4 units, %5 vehicles, %6 groups", _sourcestr, _myfps,_localagents, _localunits, _localvehicles, _localgroups];
	
	_myfpsmarker setMarkerAlpha 0.7;
	_myfpsmarker setMarkerColor "ColorGREEN";
	if ( _myfps < 30 ) exitWith { _myfpsmarker setMarkerColor "ColorYELLOW"; };
	if ( _myfps < 20 ) exitWith { _myfpsmarker setMarkerColor "ColorORANGE"; };
	if ( _myfps < 10 ) exitWith { _myfpsmarker setMarkerColor "ColorRED"; };

},
1, [_myfpsmarker,_sourcestr]] call CBA_fnc_addPerFrameHandler;

if(btc_debug) then {
	[format["showing fps for client: %1", clientOwner], __FILE__, [btc_debug, btc_debug_log, true], false] call btc_debug_fnc_message;
};

[_myfpsmarker,_handle]