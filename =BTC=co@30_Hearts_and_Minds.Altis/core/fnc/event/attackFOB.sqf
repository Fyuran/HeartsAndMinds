
/* ----------------------------------------------------------------------------
Function: btc_event_fnc_attackFOB

Description:
   Initiates a check that will determine if this FOB is a potential target for the FOB Attack Event.

Parameters:
    _activator - who activated this event [ObjNull]

Returns:
    _array - returns false when it's not being handled anymore

Examples:
    (begin example)
        [cursorObject] call btc_event_fnc_attackFOB;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define SCALE 6
#define TRIGGER_SCALE 4
#define FOB_ATTACK_PATROL_TYPE 2

if(!params[
	["_activator", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message; false};

if (_activator inArea [getMarkerPos "btc_base", btc_fob_minDistance, btc_fob_minDistance, 0, false]) exitWith {
    [format["%1 is too close to btc_base, aborting", getPosASL _activator], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};


private _fobs = btc_fobs param [1, [], [[]]]; //btc_fobs syntax is [[markers],[fob_structures],[fob_flags],[fob_loudspeakers]]
if(_fobs isEqualTo []) exitWith {
    ["_fobs is empty, are there any fobs yet?", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    false
};

private _scale = worldSize / SCALE + btc_city_radiusOffset;

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

private _maxGrps = 1; //toDo: scale amount of groups on formula btc_global_reputation and occupied(enemy) cities
for "_i" from 0 to _maxGrps do { 
    private _city = _nearCities select (_i % count _nearCities); //modulo % forbids from selecting out of range elements by looping back when it exceeds count _nearCities
    _grp = [_city, _structure, FOB_ATTACK_PATROL_TYPE] call btc_mil_fnc_send;
    [format["%1 is being sent to %2, distance: %3", _grp, _structure getVariable["FOB_name", ""], _city distance2D _structure] , __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
};

private _trigger = createTrigger ["EmptyDetector", getPosASL _structure, false];
_trigger setVariable["btc_event_fob_structure", _structure];
private _triggerArea = _scale/TRIGGER_SCALE;
_trigger setTriggerArea [_triggerArea, _triggerArea, 0, false];
_trigger setTriggerActivation [format["%1",btc_enemy_side], "PRESENT", false]; //arma 3 triggers are miserable
private _trgStatementOn = "
    thisTrigger call btc_event_fnc_attackFOB_alarmTrg;
";
_trigger setTriggerStatements ["this", _trgStatementOn, ""];

//Disable Respawn and Redeploy
_structure setVariable ["FOB_underAttack", true, true];
_BIS_respawn_EH = _structure getVariable["FOB_Respawn_EH", []];
_BIS_respawn_EH call BIS_fnc_removeRespawnPosition;

/*
if (_target getVariable["FOB_underAttack", false]) exitWith {
    [[localize "STR_BTC_HAM_O_FOB_CANTREDEPLOY"], [localize "STR_BTC_HAM_O_FOB_REDEPLOY_FOBUNDERATTACK"]] call CBA_fnc_notify;
    false
};
*/


if (btc_debug) then {
    private _name = _structure getVariable["FOB_name", ""];
    (getPosASL _structure) params ["_posx", "_posy"];
    private _marker = createMarker [format ["fob_%1", _name],_trigger];
    _marker setMarkerShape "ELLIPSE";
    _marker setMarkerBrush "SolidBorder";
    _marker setMarkerSize [_triggerArea, _triggerArea];
    _marker setMarkerAlpha 0.3;
    _marker setMarkerColor "ColorBlue";

    private _marke = createMarker [format ["fobn_%1",  _name], [_posx+10, _posy+10, 0]];
    _marke setMarkerType "Contact_dot1";
    private _spaces = "";
    for "_i" from 0 to count _name -1 do {
        _spaces = _spaces + " ";
    };
    _marke setMarkerText format [_spaces + "%1: alarm trigger range ", _name];
};

btc_event_activeEvents = btc_event_activeEvents + 1;
false