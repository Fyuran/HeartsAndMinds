#include "fnc\script_macros.hpp"
//The player command returns the Headless Client Entity on the Headless Client's machine.
[{!isNull player}, {
    [] call FUNC(eh,headless);

    if(btc_p_debug_fps) then {
        private _name = vehicleVarName player;
        private _slot = parseNumber (_name select [(count _name)-1]); //get the last number as slot ex: btc_hc_1 means slot=1
        if(_slot isEqualTo 0) then {
            #ifdef BTC_DEBUG_DEBUG
                [["%1: %2 is invalid as obj name, should be 'NAME_NUMBER'", __FILE_NAME__, _name], 2] call FUNC(debug,message);  
            #endif
            [_name, [0, -50], 200, _slot] call FUNC(debug,show_fps);
        };
    };
}] call CBA_fnc_waitUntilAndExecute;