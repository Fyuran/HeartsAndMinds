
/* ----------------------------------------------------------------------------
Function: btc_fob_fnc_destroyProgress

Description:
	Handles GUI for FOBs that are being destroyed.

Parameters:


Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!params[
	["_structure", ObjNull, [ObjNull]]
]) exitWith {["Attempted to pass ObjNull", __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;};

disableSerialization;

BTC_FOB_CAP_DISPLAY_INDEX = missionNamespace getVariable ["BTC_FOB_CAP_DISPLAY_INDEX", 1]; //supports more than one FOB attack progress
private _display = [] call BIS_fnc_displayMission; //returns display 46
if(isNull _display) exitWith {
	[format["display 46 is null"], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
};

private _bar =  _display ctrlCreate ["RscProgressFOB", -1];
private _flag = _display ctrlCreate ["RscPicture_FOB_icon", -1];
private _text = _display ctrlCreate ["RscText_FOB_text", -1];
_text ctrlSetText (_structure getVariable ["FOB_name", "UNKNOWN"]);
[_bar, _flag, _text] apply {
	(ctrlPosition _x) params ["_xPos", "_yPos", "_w", "_h"];
	_x ctrlSetPosition [_xPos, _yPos + _h * BTC_FOB_CAP_DISPLAY_INDEX];
	_x ctrlCommit 0;
};
BTC_FOB_CAP_DISPLAY_INDEX =  BTC_FOB_CAP_DISPLAY_INDEX + 1;

[_structure, _bar, _flag, _text] spawn {
	params["_structure", "_bar", "_flag", "_text"];
	_a = profilenamespace getvariable ['GUI_BCG_RGB_A',0.8];
	[profilenamespace getvariable ['Map_BLUFOR_R',0],
	profilenamespace getvariable ['Map_BLUFOR_G',1],
	profilenamespace getvariable ['Map_BLUFOR_B',1]] params ["_r1", "_g1", "_b1"];

	[profilenamespace getvariable ['Map_OPFOR_R',0],
	profilenamespace getvariable ['Map_OPFOR_G',1],
	profilenamespace getvariable ['Map_OPFOR_B',1]] params ["_r2", "_g2", "_b2"];

	while {round (_structure getVariable["fob_conquest_time", 0]) < btc_p_fob_cap_time} do {
		_delta = linearConversion[0, btc_p_fob_cap_time, _structure getVariable["fob_conquest_time", 0], 0, 1, true];
		_r = [_r1, _r2, _delta] call BIS_fnc_easeIn;
		_g = [_g1, _g2, _delta] call BIS_fnc_easeIn;
		_b = [_b1, _b2, _delta] call BIS_fnc_easeIn;

		_bar ctrlSetTextColor[_r, _g, _b, _a];
		_bar progressSetPosition _delta;
		sleep 0.1;
		if(round (_structure getVariable["fob_conquest_time", 0]) < 0) then {break;}; //-1 is the flag for GUI removal
	};

	_flag ctrlSetText "a3\ui_f\data\GUI\Rsc\RscDisplayArcadeMap\icon_exit_cross_ca.paa";
	_bar progressSetPosition 0;
	[_bar, _flag, _text] apply {_x ctrlSetFade 1; _x ctrlCommit 2};
	sleep 3;
	[_bar, _flag, _text] apply {ctrlDelete _x};
	
	BTC_FOB_CAP_DISPLAY_INDEX =  BTC_FOB_CAP_DISPLAY_INDEX - 1;
};