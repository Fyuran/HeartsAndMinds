
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

Global marker commands always broadcast the entire marker state over the network. 
As such, the number of network messages can be reduced by performing all but the last operation using local marker commands, 
then using a global marker command for the last change (and subsequent global broadcast of all changes applied to the marker).

---------------------------------------------------------------------------- */
#define _MARKER_SIZE 0.7

params[
	["_sourcestr", "", [""]],
	["_corner", [0,-50], [[]], 2],
	["_distance", 200, [0]],
	["_slot", 0, [0]]
];

if(_sourcestr isEqualTo "") then {
	_sourcestr = name player; //The player command returns the Headless Client Entity on the Headless Client's machine.
};
_corner params ["_corner_x","_corner_y"];
private _marker = createMarkerLocal[format["btc_debug_fps_%1", _sourcestr], [_corner_x, _corner_y - (_distance * _slot)]];
_marker setMarkerTypeLocal "mil_start";
_marker setMarkerAlphaLocal 0.7;
_marker setMarkerSizeLocal[_MARKER_SIZE, _MARKER_SIZE];

private _handle = [{
	_args params ["_marker","_sourcestr"];
	_FPS = round diag_fps;

	_markerText = format[ "%1: %2 fps", _sourcestr, _FPS];
	if(btc_debug) then {
		_units = {local _x} count entities "CAManBase";
		_groups = {local _x} count allGroups;
		_vehicles = {local _x} count vehicles;
		_agents = {local (agent _x)} count agents;
		
		_markerText = _markerText insert[-1, format[
			" -DEBUG: units:%1, groups:%2, vehicles:%3, agents:%4",
			_units, _groups, _vehicles, _agents
		]];
	};
	_marker setMarkerTextLocal _markerText;
	
	_markerColor = switch(true) do {
		case (_FPS <= 30): {"ColorYELLOW"};
		case (_FPS <= 20): {"ColorORANGE"};
		case (_FPS <= 10): {"ColorRED"};
		default {"ColorGREEN"}
	};
	_marker setMarkerColor _markerColor; //keep this one global not local to broadcast marker over clients

},
1, [_marker, _sourcestr]] call CBA_fnc_addPerFrameHandler;