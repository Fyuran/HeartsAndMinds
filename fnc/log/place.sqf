
/* ----------------------------------------------------------------------------
Function: btc_log_fnc_place

Description:
    Carry and place an object with keys.

Parameters:
    _placing_obj - Object to place. [Object]

Returns:

Examples:
    (begin example)
        [cursorObject] call btc_log_fnc_place;
    (end)

Author:
    Giallustio, Fyuran

---------------------------------------------------------------------------- */

params [
    ["_placing_obj", objNull, [objNull]]
];

hint composeText [
    localize "STR_BTC_HAM_LOG_PLACE_HINT1", //Q/Z to raise/lower the object
    lineBreak,
    localize "STR_BTC_HAM_LOG_PLACE_HINT2", //X/C to rotate the object
    lineBreak,
    localize "STR_BTC_HAM_LOG_PLACE_HINT3", //F/R to tilt the object
    lineBreak,
    localize "STR_BTC_HAM_LOG_PLACE_HINT4", //SHIFT to increase the movement
    lineBreak,
    localize "STR_BTC_HAM_LOG_PLACE_HINT6" //T to reset height and orientation
];
[localize "STR_BTC_HAM_LOG_PLACE_RELEASE", ""] call ace_interaction_fnc_showMouseHint;

btc_log_placing_obj = _placing_obj;
btc_log_placing = true;
btc_log_yaw = 0;
btc_log_roll = 0;
btc_log_pitch = 0;
btc_log_placing_h = ((ASLtoAGL (eyePos player))#2) - 0.5;

private _bbr = 0 boundingBoxReal _placing_obj;
btc_log_placing_d = 1.5 + abs(((_bbr select 1) select 1) - ((_bbr select 0) select 1));


private _helpers = _placing_obj getVariable ["btc_log_helpers", []];
_helpers apply {_x hideObjectGlobal false};

_placing_obj attachTo [player, [0, btc_log_placing_d, btc_log_placing_h]];
[_placing_obj, [btc_log_yaw, btc_log_pitch, btc_log_roll]] call BIS_fnc_setObjectRotation;

private _currentWeapon = currentWeapon player;
[player] call ace_weaponselect_fnc_putWeaponAway;
[player, "blockThrow", "btc_log_placing", true] call ace_common_fnc_statusEffect_set;

//add actions to keys
private _leftActionEH = [player, "DefaultAction", {btc_log_placing}, {btc_log_placing = false;}] call ace_common_fnc_addActionEventHandler;
private _keyDownEH = (findDisplay 46) displayAddEventHandler ["KeyDown", btc_log_fnc_place_key_down];
private _MouseZChangedEH = (findDisplay 46) displayAddEventHandler ["MouseZChanged", btc_log_fnc_place_mouse_zchanged];

["btc_log_place_pickedUp", [_placing_obj, player]] call CBA_fnc_serverEvent;
[{
    !alive player || 
    player getVariable ["ACE_isUnconscious", false] || 
    !btc_log_placing || 
    (vehicle player != player)
}, {
    [{
        params [
            "_placing_obj", "_currentWeapon", "_leftActionEH", "_keyDownEH", "_MouseZChangedEH"
        ];

        hintSilent "";

        // remove actions
        [player, "DefaultAction", _leftActionEH, -1] call ace_common_fnc_removeActionEventHandler;
        (findDisplay 46) displayRemoveEventHandler ["KeyDown", _keyDownEH];
        (findDisplay 46) displayRemoveEventHandler ["MouseZChanged", _MouseZChangedEH];
        [] call ace_interaction_fnc_hideMouseHint;

        private _helpers = _placing_obj getVariable ["btc_log_helpers", []];
        _helpers apply {_x hideObjectGlobal true};

        detach _placing_obj;
        [player, _currentWeapon] call ace_weaponselect_fnc_selectWeaponMode;
        [player, "blockThrow", "btc_log_placing", false] call ace_common_fnc_statusEffect_set;
        ["btc_log_place_placedDown", [_placing_obj, player]] call CBA_fnc_serverEvent;

        btc_log_placing_obj = objNull;
    }, _this] call CBA_fnc_execNextFrame;

}, [_placing_obj, _currentWeapon, _leftActionEH, _keyDownEH, _MouseZChangedEH]] call CBA_fnc_waitUntilAndExecute;


_placing_obj