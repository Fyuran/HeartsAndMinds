#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_fnc_typeText

Description:
	Types a structured text on the screen, letter by letter, cursor blinking.
	* Every text block is an array of text and formatting tag.
	* Blocks don't have to span over whole line.

Parameters:
	_this:
		NUMBER:_posX,
		NUMBER:_posY,
		ARRAY:_data:
			ARRAYS...:
				STRING:_text
				STRING:_format
				NUMBER:_lifeTime

Returns:

Examples:
[
	safeZoneW + (safeZoneX * 2),
	safeZoneH + (safeZoneY * 2),
	[
		["SITREP:","align = 'center' shadow = '1' size = '0.7' font = 'PuristaBold'", 1, 0.1],
		["REASON:","align = 'center' color = '#cc0000' shadow = '1' size = '0.7'", 3, 0.1],
		["INSTIGATOR","align = 'center' shadow = '1' size = '0.7'", 3, 0.2]
	]
	
] spawn btc_fnc_typeText;

Author:
	Fyuran

---------------------------------------------------------------------------- */
if(!canSuspend) exitWith {
#ifdef BTC_DEBUG_COMMON
[["%1: Called in a non suspended envinronment", __FILE_NAME__], 6, "common"] call btc_debug_fnc_message;
#endif
};

btc_info_typeTextHandle = missionNamespace getVariable ["btc_info_typeTextHandle", scriptNull];
waitUntil{scriptDone btc_info_typeTextHandle};

btc_info_typeTextHandle = _this spawn {
	disableSerialization;
	forceUnicode 0;

	params[
		["_posX", 0, [123]],
		["_posY", 0, [123]],
		["_data", [], []]
	];

	private _fnc_getHiddenCursorFormat = {
		params[
			["_format", "", [""]]
		];
		private _colorRegex = "'#\S+'";
		private _shadowRegex = "'(?<=shadow = ')\d(?=')'";
		
		private _hasColor = count (_format regexFind [_colorRegex]) != 0;
		private _hasShadow = count (_format regexFind [_shadowRegex]) != 0;
		private _newFormat = _format;
		if(_hasColor) then {
			_newFormat = _newFormat regexReplace [_colorRegex, "'#00000000'"]; //replace color
		} else {
			_newFormat = _newFormat + " color = '#00000000' ";
		};
		if(_hasShadow) then {
			_newFormat = _newFormat regexReplace [_shadowRegex, "'0'"]; //replace shadow
		} else {
		_newFormat = _newFormat + " shadow = '0' "; 
		};

		_newFormat	 
	};

	//chars
	private _arrayChars = [];
	_data apply {
	_x params[
		["_text", "", [""]], 
		["_format", "", [""]],
		["_lifeTime", 1, [123]]
		];

		private _chars = (toArray _text) apply {toString [_x]};
		_arrayChars pushBack _chars;
	};

	("btc_InfoLogLayer" call BIS_fnc_rscLayer) cutrsc ["btc_RscDynamicText","plain"];
	private _display = uinamespace getVariable ["btc_dynamicText",displayNull];
	private _control = _display displayctrl 9999;
	_control ctrlSetPosition [_posX, _posY, 1, 1];
	_control ctrlCommit 0;
	waitUntil{ctrlCommitted _control};

	//compileBlocks
	private _joinedString = "";
	{
		private _format = (_data select _forEachIndex)#1;
		private _lifeTime = (_data select _forEachIndex)#2;
		private _charDelay = (_data select _forEachIndex)#3;

		private _block = [];
		private _charArray = _x;  
		_charArray apply {
			_joinedString = _joinedString + format["<t %2>%1</t>", _x, _format];
			
			if(_x isEqualRef (_charArray select -1) && {_charArray isNotEqualRef (_arrayChars select -1)}) then {//if last char but not last char array
				_joinedString  = _joinedString + "<br/>";
			};
			_control ctrlSetStructuredText parseText (_joinedString + format["<t %1>_</t>", _format]); 
			playSound ["ReadoutClick", true];
			sleep _charDelay;
		};
		
		private _time = CBA_missionTime + _lifeTime;
		private _hiddenCursorFormat = [_format] call _fnc_getHiddenCursorFormat;
		while{CBA_missionTime < _time} do {
			sleep 0.2;
			_control ctrlSetStructuredText parseText (_joinedString + format["<t %1>_</t>", _hiddenCursorFormat]);
			sleep 0.2;
			_control ctrlSetStructuredText parseText (_joinedString + format["<t %1>_</t>", _format]);
		};	 
	}forEach _arrayChars;

	("btc_InfoLogLayer" call BIS_fnc_rscLayer) cutFadeOut 0;
	sleep 0.1;
};