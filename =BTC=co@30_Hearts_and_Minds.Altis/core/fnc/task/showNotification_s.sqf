
/* ----------------------------------------------------------------------------
Function: btc_task_fnc_showNotification_s

Description:
    Shake mission notification.
	When one is already shown, queue the new request and display it afterwards.
	Uses templates defined in CfgNotifications in missionconfigfile unlike the original BIS function which uses configFile

Parameters:
	_this select 0 (Optional): STRING - template from CfgNotifications
	_this select 1 (Optional): ARRAY - arguments passed to the template

Returns:
	_data

Examples:
    (begin example)
    (end)

Author:
    Karel Moricky(BIS), Fyuran

---------------------------------------------------------------------------- */

private ["_template","_args","_cfgDefault","_cfgTemplate","_cfgTitle","_cfgIconPicture","_cfgIconText","_cfgDescription","_cfgColor","_cfgDuration","_cfgPriority","_cfgDifficulty","_cfgSound","_cfgSoundClose","_cfgSoundRadio","_title","_iconPicture","_iconText","_description","_color","_duration","_priority","_difficulty","_sound","_soundClose","_soundRadio","_iconSize","_data"];
_template = _this param [0,"Default",[""]];
_args = _this param [1,[],[[]]];

//--- Load notification params
_cfgDefault = missionconfigfile >> "CfgNotifications" >> "Default";
_cfgTemplate = [["CfgNotifications",_template],_cfgDefault] call bis_fnc_loadClass;

if (_cfgTemplate == _cfgDefault) then {["Template '%1' not found in CfgNotifications.",_template] call bis_fnc_error;};

_cfgTitle =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "title"));
_cfgIconPicture =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "iconPicture"));
_cfgIconText =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "iconText"));
_cfgDescription =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "description"));
_cfgColor =		[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "color"));
_cfgColorIconPicture =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "colorIconPicture"));
_cfgColorIconText =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "colorIconText"));
_cfgDuration =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "duration"));
_cfgPriority =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "priority"));
_cfgDifficulty =	[_cfgDefault,_cfgTemplate] select (isarray (_cfgTemplate >> "difficulty"));
_cfgSound =		[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "sound"));
_cfgSoundClose =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "soundClose"));
_cfgSoundRadio =	[_cfgDefault,_cfgTemplate] select (istext (_cfgTemplate >> "soundRadio"));
_cfgIconSize =		[_cfgDefault,_cfgTemplate] select (isnumber (_cfgTemplate >> "iconSize"));

_title =		gettext (_cfgTitle >> "title");
_iconPicture =		gettext (_cfgIconPicture >> "iconPicture");
_iconText =		gettext (_cfgIconText >> "iconText");
_description =		gettext (_cfgDescription >> "description");
_color =		(_cfgColor >> "color") call bis_fnc_colorCOnfigToRGBA;
_colorIconText =	(_cfgColorIconText >> "colorIconText") call bis_fnc_colorConfigToRGBA;
_colorIconPicture =	(_cfgColorIconPicture >> "colorIconPicture") call bis_fnc_colorConfigToRGBA;
_duration =		getnumber (_cfgDuration >> "duration");
_priority =		getnumber (_cfgPriority >> "priority");
_difficulty =		getarray (_cfgDifficulty >> "difficulty");
_sound =		gettext (_cfgSound >> "sound");
_soundClose =		gettext (_cfgSoundClose >> "soundClose");
_soundRadio =		gettext (_cfgSoundRadio >> "soundRadio");
_iconSize =		getnumber (_cfgIconSize >> "iconSize");

if !(isarray (_cfgTemplate >> "colorIconText")) then {_colorIconText = _color;};
if !(isarray (_cfgTemplate >> "colorIconPicture")) then {_colorIconPicture = _color;};

_data = [_title,_iconPicture,_iconText,_description,_color,_colorIconPicture,_colorIconText,_duration,_priority,_args,_sound,_soundClose,_soundRadio,_iconSize];

[_data] remoteExec ["btc_task_fnc_showNotification", [0, -2] select isDedicated];

_data