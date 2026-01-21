#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
	Function: btc_eh_fnc_inventory
	
	Description:
	    Manages inventory postInit
	
	Parameters:
	    _unit - passed unit object by event handler
	
	Returns:
	
	Examples:
	    (begin example)
	        [player] call btc_eh_fnc_inventory;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
params[
    ["_unit", objNull, [objNull]]
];

//remove all gear from civilians
if((side group _unit) isEqualTo civilian) then {
    #ifdef BTC_DEBUG_EH
    [["%1: removing %2 from %3", __FILE_NAME__, assignedItems[_unit, false, true] + [backpack _unit], _unit], 2, "eh"] call btc_debug_fnc_message;
    #endif[[_unit, false, true]] remoteExecCall ["removeAllAssignedItems", _unit];
    [_unit] remoteExecCall ["removeBackpack", _unit];
};