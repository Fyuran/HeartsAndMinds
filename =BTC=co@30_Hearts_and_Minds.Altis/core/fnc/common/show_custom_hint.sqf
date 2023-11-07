
/* ----------------------------------------------------------------------------
Function: btc_fnc_show_custom_hint

Description:
    Show CBA_fnc_notify.

Parameters:
	_content	Notifications content (lines).  ARRAY
		_text	Text to display or path to .paa or .jpg image (may be passed directly if only text is required).  <STRING, NUMBER>
		_size	Text or image size multiplier.  (optional, default: 1) <NUMBER>
		_color	RGB or RGBA color (range 0-1).  (optional, default: [1, 1, 1, 1]) ARRAY

	_skippable	Skip or overwrite this notification if another entered the queue.  (optional, default: false) <BOOL>
Returns:

Examples:
    (begin example)
        [["Banana", 1.5, [1, 1, 0, 1]], true] call btc_fnc_show_custom_hint;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
	["_lineContent", [], [[]]],
	["_skippable", false, [false]]
];

_lineContent params [
		["_text", "noText", [""]],
		["_size", 1, [0]],
		["_color", [1, 1, 1, 1], [[]], 4]	
	];

[[_text, _size, _color], _skippable] remoteExecCall ["CBA_fnc_notify", [0, -2] select isDedicated];