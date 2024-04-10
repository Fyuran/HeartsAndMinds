
/* ----------------------------------------------------------------------------
Function: btc_ui_fnc_progressBars

Description:
	Handles GUI for progression bars.

Parameters:


Returns:

Examples:
    (begin example)
		[] call btc_ui_fnc_progressBars;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#define _PROGRESS_THRESHOLD_ 61

if(!params[
	["_object", ObjNull, [ObjNull]],
	["_barName", "PLACEHOLDER", [""]],
	["_showProgress", true, [false]],
	["_max_cap_time", 1, [0]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;};

disableSerialization;

BTC_UI_PROGRESS_DISPLAY_INDEX = missionNamespace getVariable ["BTC_UI_PROGRESS_DISPLAY_INDEX", 1]; //supports more than one FOB attack progress

private _handle = _object getVariable ["btc_ui_progressionHandle", scriptNull];
if(!scriptDone _handle) exitWith {
	[format["progress bar on %1 is already active", _barName], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

// (ctrlPosition _text) params ["_textX", "_textY", "_textWidth", "_textHeight"];
// private _twoCharPadding = ( _textWidth / count ctrlText _text ) * 2;
// _text ctrlSetPosition[_textX, _textY + _textHeight * BTC_UI_PROGRESS_DISPLAY_INDEX, _textWidth + _twoCharPadding, _textHeight];
// _text ctrlCommit 0;

private _handle = [_object, _barName, _showProgress, _max_cap_time] spawn {
	params["_object", "_barName", "_showProgress", "_max_cap_time"];

	private _display = [] call BIS_fnc_displayMission; //returns display 46

	if(isNull _display) exitWith {
		[format["display 46 is null"], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
	};
	_bar =  _display ctrlCreate ["btc_UI_RscProgress", -1];
	if(!_showProgress) then {_bar progressSetPosition 1};	
	_flag = _display ctrlCreate ["btc_UI_RscProgressIcon", -1];
	_text = _display ctrlCreate ["btc_UI_RscProgressText", -1];
	_text ctrlSetText _barName;
	[_bar, _flag, _text] apply {
		(ctrlPosition _x) params ["_xPos", "_yPos", "_w", "_h"];
		_x ctrlSetPosition [_xPos, _yPos + _h * BTC_UI_PROGRESS_DISPLAY_INDEX];
		_x ctrlCommit 0;
	};

	_a = profilenamespace getvariable ['GUI_BCG_RGB_A',0.8];
	[profilenamespace getvariable ['Map_BLUFOR_R',0],
	profilenamespace getvariable ['Map_BLUFOR_G',1],
	profilenamespace getvariable ['Map_BLUFOR_B',1]] params ["_r1", "_g1", "_b1"];

	[profilenamespace getvariable ['Map_OPFOR_R',0],
	profilenamespace getvariable ['Map_OPFOR_G',1],
	profilenamespace getvariable ['Map_OPFOR_B',1]] params ["_r2", "_g2", "_b2"];

	BTC_UI_PROGRESS_DISPLAY_INDEX =  BTC_UI_PROGRESS_DISPLAY_INDEX + 1;

	while {round (_object getVariable["cap_time", 0]) < _max_cap_time} do {
		_cap_time = _object getVariable["cap_time", 0];
		
		_delta = linearConversion[0, _max_cap_time, _cap_time, 0, 1, true];
		_r = [_r1, _r2, _delta] call BIS_fnc_easeIn;
		_g = [_g1, _g2, _delta] call BIS_fnc_easeIn;
		_b = [_b1, _b2, _delta] call BIS_fnc_easeIn;
		_bar ctrlSetTextColor[_r, _g, _b, _a];
		if(_showProgress) then {
			_bar progressSetPosition _delta;
		};

		_time = _max_cap_time - _cap_time;
		if(_time > 60) then [
			{_time = format ["%1m:%2s", floor(_time / 60), round(_time % 60)]}, //adjust to show minutes
			{_time = format ["%1s", round _time]}
		]; 
		_text ctrlSetText format["%1: %2", _barName, _time];

		sleep 0.1;
		if(round (_object getVariable["cap_time", 0]) < 0) then {break;}; //-1 is the flag for GUI removal
	};

	_flag ctrlSetText "a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_exit_cross_ca.paa";
	_bar progressSetPosition 0;
	[_bar, _flag, _text] apply {_x ctrlSetFade 1; _x ctrlCommit 2};
	sleep 3;
	[_bar, _flag, _text] apply {ctrlDelete _x};
	
	BTC_UI_PROGRESS_DISPLAY_INDEX =  BTC_UI_PROGRESS_DISPLAY_INDEX - 1;
};

_object setVariable ["btc_ui_progressionHandle", _handle];

_handle