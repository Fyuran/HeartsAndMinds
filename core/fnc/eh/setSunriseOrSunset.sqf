#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_setSunriseOrSunset

Description:
    Periodically checks if current time is over sunset or sunrise

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_setSunriseOrSunset;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
    ["_isSunrise", true, [false, 0]]
];

if(!isNil "btc_sunrise_nightfall_handle") then {
    [btc_sunrise_nightfall_handle] call CBA_fnc_removePerFrameHandler;
};
if(_isSunrise >= 2) exitWith {
	[btc_sunrise_nightfall_handle] call CBA_fnc_removePerFrameHandler;
};
if(_isSunrise isEqualType 0) then {
	_isSunrise = [false, true] select _isSunrise;
};

#ifdef BTC_DEBUG_EH
[["%1: Added CBA PFH %2 preserver", __FILE_NAME__, ["Night", "Day"] select _isSunrise], 2, "eh"] call FUNC(debug,message);
#endif
btc_sunrise_nightfall_handle = [{

	_currentDate = date;
	_dayTime = dayTime;
	_sunriseSunsetTime = _currentDate call BIS_fnc_sunriseSunsetTime;
	
	_hasExpired = [
		(_dayTime > _sunriseSunsetTime#0) and (_dayTime < _sunriseSunsetTime#1), //night
		(_dayTime < _sunriseSunsetTime#0) or (_dayTime > _sunriseSunsetTime#1)] select _args; //day

	if(_hasExpired) then {
		_nextTime = _sunriseSunsetTime select not _args; //BIS_fnc_sunriseSunsetTime returns [Dawn, Nightfall] order
		_dateOffset = (_nextTime - _dayTime + 24) % 24;
		_nextDate = [_currentDate, _dateOffset + 0.1, "h"] call BIS_fnc_calculateDateTime; //add 0.1 to offset in order to avoid triggering condition

		setDate _nextDate;		
		#ifdef BTC_DEBUG_EH
		[["%1: Date: %2 has been changed to %3", __FILE_NAME__, _currentDate, _nextDate], 2, "eh"] call FUNC(debug,message);
		#endif
	};
}, [60, 1] select btc_debug, _isSunrise] call CBA_fnc_addPerFrameHandler;
