//The player command returns the Headless Client Entity on the Headless Client's machine.
[{!isNull player}, {
    [] call btc_eh_fnc_headless;

    if(btc_p_debug_fps) then {
        private _name = vehicleVarName player;
        private _slot = parseNumber (_name select [(count _name)-1]); //get the last number as slot ex: btc_hc_1 means slot=1
        if(_slot isEqualTo 0) then {
            [format["%1 is invalid as obj name, should be NAME_NUMBER", _name], __FILE__, [btc_debug, btc_debug_log, false], true] call btc_debug_fnc_message;
        } else {
            [_name, [0, -50], 200, _slot] call btc_debug_fnc_show_fps;
        };
    };
}] call CBA_fnc_waitUntilAndExecute;