
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOB

Description:
   Initiates a check that will determine if this FOB is a potential target for the FOB Attack Event.
   btc_event_fobAttack_scalingFactor is defined in mission.sqf

Parameters:
    _structure - the FOB object [ObjNull]

Returns:
    _array - returns true if this FOB can be attacked [Array]

Examples:
    (begin example)
        [cursorObject] call btc_event_fnc_attackFOB;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define SCALE 6
if(!params[
	["_structure", ObjNull, [ObjNull]]
]);

private _fobs = btc_fobs select 1; //btc_fobs syntax is [["marker", fob_object, fob_flag]]
if(_fobs isEqualTo []) exitWith {
    ["btc_fobs is empty, are there any fobs yet?", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    [] call btc_event_fnc_eventManager;
    false
};

if(isNull _structure) then {
    _structure = selectRandom _fobs; 
};

private _scale = worldSize / SCALE + btc_city_radiusOffset; //toDo: find more appropriate formula for scaling
private _nearby = values btc_city_all select {
    (_x distance2D _structure) < _scale && 
        {_x getVariable ["occupied", false]}
}; 

if (_nearby isEqualTo []) exitWith {
    [format["_nearby is empty, skipping %1", _structure] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    [] call btc_event_fnc_eventManager;
    false
};

for "_i" from 0 to 4 do { //toDo: scale amount of groups on formula
    _grp = [selectRandom _nearby, _structure, 2] call btc_mil_fnc_send;
    [format["%1 is being sent to %2", _grp, getPosASL _structure] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};
private _trigger = createTrigger ["EmptyDetector", [], false];
_trigger setTriggerArea [_scale, _scale, 0, false, 800];
_trigger setTriggerActivation ["ANYPLAYER", "PRESENT", true];
_trigger setTriggerStatements ["this", "", ""];
_structure setVariable["btc_event_trigger", _trigger];

[] call btc_event_fnc_eventManager;
true