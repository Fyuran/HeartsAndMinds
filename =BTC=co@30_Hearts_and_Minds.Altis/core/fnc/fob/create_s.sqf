
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_create_s

Description:
   Create the FOB.

Parameters:
    _pos - Position of the FOB. [Array]
    _direction - Direction of the FOB between 0 to 360 degree. [Number]
    _FOB_name - Name of the FOB. [String]
    _fob_structure - FOB structure. [Array]
    _fob_flag - Flag type. [Array]
    _fobs - Array of FOB. [Array]

Returns:
    _array - Return marker, structure and flag object. [Array]

Examples:
    (begin example)
        [getPos player, random 360, "My FOB"] call btc_fob_fnc_create_s;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */
#define EVENT_FOB_ATTACK 0
#define FOB_CONQUEST_RANGE 30

params [
    ["_pos", [], [[]]],
    ["_direction", 0, [0]],
    ["_FOB_name", "FOB ", [""]],
    ["_fob_structure", btc_fob_structure, [[]]],
    ["_fob_flag", btc_fob_flag, [[]]],
    ["_fobs", btc_fobs, [[]]]
];

private _flag = createVehicle [_fob_flag, _pos, [], 0, "CAN_COLLIDE"];
private _structure = createVehicle [_fob_structure, _pos, [], 0, "CAN_COLLIDE"];
private _loudspeaker = createVehicle ["Land_Loudspeakers_F", _pos, [], 0, "CAN_COLLIDE"];

_structure setDir _direction;
_structure setVariable["FOB_name", _FOB_name];
_structure setVariable["FOB_Loudspeaker", _loudspeaker];
private _BISEH_return = [btc_player_side, _flag, _FOB_name] call BIS_fnc_addRespawnPosition;
_structure setVariable["FOB_Respawn_EH", _BISEH_return];


private _marker = createMarker [_FOB_name, _pos];
_marker setMarkerSize [1, 1];
_marker setMarkerType "b_hq";
_marker setMarkerText _FOB_name;
_marker setMarkerColor "ColorBlue";
_marker setMarkerShape "ICON";

(_fobs select 0) pushBack _marker;
(_fobs select 1) pushBack _structure;
(_fobs select 2) pushBack _flag;
(_fobs select 3) pushBack _loudspeaker;

//Alarm FOB Trigger
if (btc_fob_showAlert) then {
	private _alarmTrg = createTrigger ["EmptyDetector", _pos, false];
    _alarmTrg setVariable["btc_fob_structure", _structure];
	_alarmTrg setTriggerArea [btc_fob_alertRadius, btc_fob_alertRadius, 0, false];
	_alarmTrg setTriggerActivation [format["%1",btc_enemy_side], "PRESENT", true]; //arma 3 triggers are miserable
	private _alarmTrgStatementOn = "
		thisTrigger call btc_fob_fnc_alarmTrg;
	";
	_alarmTrg setTriggerStatements ["this", _alarmTrgStatementOn, ""];

    if (btc_debug) then {
        private _marker = createMarker [format ["fob_%1", _FOB_name],_alarmTrg];
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerBrush "SolidBorder";
        _marker setMarkerSize [btc_fob_alertRadius, btc_fob_alertRadius];
        _marker setMarkerAlpha 0.3;
        _marker setMarkerColor "ColorBlue";

        _pos params ["_posx", "_posy"];
        private _marke = createMarker [format ["fobn_%1",  _FOB_name], [_posx+10, _posy+10, 0]];
        _marke setMarkerType "Contact_dot1";
        _marke setMarkerColor "ColorBlue";
        private _spaces = "";
        for "_i" from 0 to count _FOB_name -1 do {
            _spaces = _spaces + " ";
        };
        _marke setMarkerText format [_spaces + "%1: alarm trigger range", _FOB_name];
    };
};

//Destroy FOB Trigger
private _destroyTrg = createTrigger ["EmptyDetector", _pos, false];
_destroyTrg setTriggerArea [30, 30, 0, false];
_destroyTrg setTriggerActivation [format["%1",btc_enemy_side], "PRESENT", false]; //arma 3 triggers are miserable
private _destroyTrgStatementOn = "
	
";
_destroyTrg setTriggerStatements ["this", _destroyTrgStatementOn, ""];
if (btc_debug) then {
    private _marker = createMarker [format ["fob_c%1", _FOB_name],_destroyTrg];
    _marker setMarkerShape "ELLIPSE";
    _marker setMarkerBrush "SolidBorder";
    _marker setMarkerSize [FOB_CONQUEST_RANGE, FOB_CONQUEST_RANGE];
    _marker setMarkerAlpha 0.4;
    _marker setMarkerColor "ColorPink";

    _pos params ["_posx", "_posy"];
    private _marke = createMarker [format ["fobn_c%1",  _FOB_name], [_posx-10, _posy-10, 0]];
    _marke setMarkerType "Contact_dot1";
    _marke setMarkerColor "ColorPink";
    private _spaces = "";
    for "_i" from 0 to count _FOB_name -1 do {
        _spaces = _spaces + " ";
    };
    _marke setMarkerText format [_spaces + "%1: conquest range", _FOB_name];
};

[_flag, "Deleted", {[_thisArgs select 0, _thisArgs select 1] call BIS_fnc_removeRespawnPosition}, _BISEH_return] call CBA_fnc_addBISEventHandler;

_structure addEventHandler ["Killed", btc_fob_fnc_killed];

//FOB attack event - #define EVENT_FOB_ATTACK 0 
[EVENT_FOB_ATTACK, _structure] call btc_event_fnc_eventManager;

[_marker, _structure, _flag]
