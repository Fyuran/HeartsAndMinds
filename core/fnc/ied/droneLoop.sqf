#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_droneLoop

Description:
    Search for soldier around the drone during a patrol. If soldier are in range, activate the drone.

Parameters:
    _driver_drone - Driver of the drone. [Object]
    _rpos - Position where the drone patrol. [Array]
    _area - Area of the patrol. [Array]
    _trigger - Trigger of the drone when is active. [Group]

Returns:

Examples:
    (begin example)
        [_driver_drone, _rpos, _area, _trigger] call btc_ied_fnc_droneLoop;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

[{
    params ["_driver_drone", "_rpos", "_area", "_trigger"];

    private _group = group _driver_drone;
    if (alive _driver_drone && !isNull _driver_drone) then {
        private _array = _driver_drone nearEntities [btc_player_type, 200];
        _array = _array select {side group _x isEqualTo btc_player_side && {!captive _x}};
        if (_array isEqualTo []) then {
            if (waypoints _group isEqualTo []) then {
                [_group, _rpos, _area, 4] call CBA_fnc_taskPatrol;
                (vehicle _driver_drone) flyInHeight 10;
                deleteVehicle (_trigger deleteAt 0);
            };
        } else {
            if (_trigger isEqualTo []) then {
                _trigger pushBack ([_driver_drone] call FUNC(ied,drone_active));
            };

            #ifdef BTC_DEBUG_IED
            hint format ["Distance with UAV IED : %1", (_array select 0) distance (vehicle _driver_drone)];
            #endif
            (vehicle _driver_drone) doMove (ASLtoAGL getPosASL (_array select 0));
        };
        _this call FUNC(ied,droneLoop);
    } else {
        deleteVehicle (_trigger deleteAt 0);
        _group setVariable ["btc_ied_drone", false];

        #ifdef BTC_DEBUG_IED
        [["%1: _driver_drone = %2 POS %3 END LOOP", __FILE_NAME__, _driver_drone, getPos _driver_drone], 2, "ied"] call FUNC(debug,message);
        #endif
    };
}, _this, 5] call CBA_fnc_waitAndExecute;
