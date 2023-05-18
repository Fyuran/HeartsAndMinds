
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
#define FOB_ATTACK_PATROL_TYPE 2

if(!params[
	["_activator", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message; false};

private _fobs = btc_fobs param [1, [], [[]]];
if(_fobs isEqualTo []) exitWith {
    ["_fobs is empty, are there any fobs yet?", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};

private _scale = worldSize / SCALE + btc_city_radiusOffset; //toDo: find more appropriate formula for scaling

private _structure = [_fobs, _activator] call BIS_fnc_nearestPosition;

private _nearCities = values btc_city_all select {
    (_x distance2D _structure) <= _scale && 
        {_x getVariable ["occupied", false]}
}; 
if (_nearCities isEqualTo []) exitWith {
    [format["_nearCities is empty, skipping FOB: %1", _structure getVariable["FOB_name", ""]] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};
_nearCities = [_nearCities, [_structure], { _input0 distance2D _x }, "ASCEND"] call BIS_fnc_sortBy;

for "_i" from 0 to 4 do { //toDo: scale amount of groups on formula
    private _city = _nearCities select _i;
    _grp = [_city, _structure, FOB_ATTACK_PATROL_TYPE] call btc_mil_fnc_send;
    [format["%1 is being sent to %2, distance: %3", _grp, _structure getVariable["FOB_name", ""], _city distance2D _structure] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _trigger = createTrigger ["EmptyDetector", getPosASL _structure, false];
_trigger setVariable["btc_event_fob_structure", _structure];
_trigger setTriggerArea [_scale, _scale, 0, false, 800];
_trigger setTriggerActivation [btc_enemy_side, "PRESENT", true];
private _trgStatement = "
    _fob = thisTrigger getVariable [""btc_event_fob_structure"", objNull];
    _flag = _structure getVariable[""FOB_flag"", objNull];
";
_trigger setTriggerStatements ["this", _trgStatement, ""];

private _loudspeaker = _structure getVariable ["FOB_Loudspeaker", ObjNull];
playSound3d [getMissionPath "core\sounds\btc_event_FOB_Alert.ogg", _loudspeaker, false, getPosASL _loudspeaker, 5];

btc_event_activeEvents = btc_event_activeEvents + 1;
false