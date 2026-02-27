#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_suicider_activeLoop

Description:
    Detect and force the suicider to run in the direction of the soldier nearby.

Parameters:
    _suicider - Suicider. [Object]
    _trigger - Trigger triggring the suicider explosion. [Object]

Returns:

Examples:
    (begin example)
        [_suicider, _trigger] call btc_ied_fnc_suicider_activeLoop;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

[{
    params ["_suicider", "_trigger"];

    if (alive _suicider) then {
        private _array = _suicider nearEntities [btc_player_type, 30];
        _array = _array select {side group _x isEqualTo btc_player_side && {!captive _x}};
        if (_array isNotEqualTo []) then {
            _suicider doMove (position (_array select 0));
        };
        _this call FUNC(ied,suicider_activeLoop);
    } else {
        deleteVehicle _trigger;
        group _suicider setVariable ["suicider", false];

        #ifdef BTC_DEBUG_IED
        [["%1: _suicider = %2 POS %3 END LOOP", __FILE_NAME__, _suicider, getPos _suicider], 2, "ied"] call FUNC(debug,message);
        #endif};
}, _this, 0.5] call CBA_fnc_waitAndExecute;
