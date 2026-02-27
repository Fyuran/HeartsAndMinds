#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_ied_fnc_checkLoop

Description:
    Loop over IED and check if player is around. If yes, trigger the explosion.

Parameters:
    _city - City where IED has been created. [Object]
    _ieds - All IED (even FAKE IED). [Array]
    _ieds_check - Real IED triggering the explosion. [Array]

Returns:

Examples:
    (begin example)
       [_city, _ieds, _ieds_check] call btc_ied_fnc_checkLoop;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */

[{
    params ["_city", "_ieds", "_ieds_check"];

    if (_city getVariable ["active", false]) exitWith {
        {
            _x params ["_wreck", "_type", "_ied"];

            if (!isNull _ied && {alive _ied}) then {
                {
                    if (side _x isEqualTo btc_player_side && {
                        (
                            _x isKindOf "UGV_02_Base_F" &&
                            {speed _x > 10}
                        ) ||
                        !(_x isKindOf "UGV_02_Base_F") && {
                            driver _x != _x ||
                            speed _x > 5
                        }
                    }) then {
                        private _threshold = _ied getVariable["btc_ied_threshold", 0];
                        _threshold = _threshold + 0.5;
                        _ied setVariable["btc_ied_threshold", _threshold];
                        #ifdef BTC_DEBUG_IED
                        [["%1: IED at %2 is threatened, increasing threshold to %3", __FILE_NAME__, getPosASL _ied, _threshold], 3, "ied"] call FUNC(debug,message);
                        #endif
                        if (_threshold >= 1) then {
                            #ifdef BTC_DEBUG_IED
                            [["%1: IED at %2 blew up", __FILE_NAME__, getPosASL _ied], 2, "ied"] call FUNC(debug,message);
                            #endif
                            [_wreck, _ied] call FUNC(ied,boom);
                            if (0.5 < random 1) then {
                                [getPos _wreck] call FUNC(rep,call_militia);
                            };
                        }
                    } else {
                        private _threshold = _ied getVariable["btc_ied_threshold", 0];
                        if (_threshold <= 0) then {
                            continue;
                        };
                        _threshold = _threshold - 0.5;
                        _ied setVariable["btc_ied_threshold", _threshold];
                        #ifdef BTC_DEBUG_IED
                        [["%1: IED at %2 isn't threatened anymore, lowering threshold to %3", __FILE_NAME__, getPosASL _ied, _threshold], 3, "ied"] call FUNC(debug,message);
                        #endif
                    };
                } forEach (_ied nearEntities ["allVehicles", btc_ied_range]);
            } else {
                _ieds_check = _ieds_check - [_ied];
            };
        } forEach _ieds_check;
        [_city, _ieds, _ieds_check] call FUNC(ied,checkLoop);
    };

    private _data = [];
    {
        _x params ["_wreck", "_type", "_ied"];

        if (!isNull _wreck && {alive _wreck}) then {
            _data pushBack [getPosATL _wreck, _type, getDir _wreck, _ied isNotEqualTo objNull];

            deleteVehicle _ied;
            deleteVehicle _wreck;
        };
    } forEach _ieds;

    _city setVariable ["ieds", _data];

    #ifdef BTC_DEBUG_IED
    [["%1: IED LOOP OF CITY ID %2", __FILE_NAME__, _city getVariable "id"], 2, "ied"] call FUNC(debug,message);
    #endif
}, _this, 1] call CBA_fnc_waitAndExecute;
