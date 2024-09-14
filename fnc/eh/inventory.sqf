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
    if(btc_debug) then {
        [format["removing %1 from %2", assignedItems[_unit, true, true] + [backpack _unit], _unit], __FILE__, [btc_debug, btc_debug_log, false], false] call btc_debug_fnc_message;
    };
    [[_unit, false, true]] remoteExecCall ["removeAllAssignedItems", _unit];
    [_unit] remoteExecCall ["removeBackpack", _unit];
};