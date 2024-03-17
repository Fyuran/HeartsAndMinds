
/* ----------------------------------------------------------------------------
Function: btc_debug_fnc_show_fps_init

Description:
    Init for the fps markers

Parameters:

Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
params
[
	["_strcorner","", [""]],
	["_distance",200,[0]]
];

private _Map_size = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
private _corner = call {
	if(_strcorner isEqualTo "") exitWith {[0,-50]};
	if(_strcorner isEqualTo "south_east") exitWith {[_Map_size,0]};
	if(_strcorner isEqualTo "north_west") exitWith {[0,_Map_size]};
	if(_strcorner isEqualTo "north_east") exitWith {[_Map_size,_Map_size]};
	[0,0]
};

["Server",_corner,_distance,0] call btc_debug_fnc_debug_marker_show_fps;

if(isDedicated) then {
	[{!((entities "HeadlessClient_F") isEqualTo [])},{
		params["_corner","_distance"];
		{
			[format["HC%1",_foreachIndex +1],_corner,_distance,_foreachIndex + 1] remoteExecCall ["btc_debug_fnc_debug_marker_show_fps",_x];
		}forEach entities "HeadlessClient_F";
	},[_corner,_distance]] call CBA_fnc_waitUntilAndExecute;
};