
/* ----------------------------------------------------------------------------
Function: btc_eh_fnc_playerConnected

Description:
    Fire the event playerConnected.

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_eh_fnc_playerConnected;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
if (_this select 2 isEqualTo "__SERVER__") exitWith {}; //_name

[{
    !isNull ((_this select 1) call BIS_fnc_getUnitByUID) //_uid
}, {
    params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];

    private _unit = _uid call BIS_fnc_getUnitByUID;
    private _key = getPlayerUID _unit;
    if (btc_debug) then {
        [format ["for %1, %2, %3, [%2]", _name, _unit, _key, _this], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
    };
    if(btc_p_slot_isShare) then {
        private _unitPos = getPosASL _unit;
        _unitPos set [2, 0];//discard height, it's not needed

        private _slotIndex = btc_db_missionPlayerSlots find _unitPos;
        if(_slotIndex != -1) then {
            if (btc_debug) then {
                [format ["%2's data assigned to slot: %1",_slotIndex+1, _name], __FILE__, [btc_debug, btc_debug_log, true]] call btc_debug_fnc_message;
            };
            _unit setVariable ["btc_slot_player", _slotIndex];
            _key = _slotIndex;
        };
    };

    if (_key in btc_slots_serialized) then {
        private _data = btc_slots_serialized get _key;
        if (_data select 4) then {
            if ((btc_chem_contaminated pushBackUnique _unit) > -1) then {
                publicVariable "btc_chem_contaminated";
                _unit call btc_chem_fnc_damageLoop;
            };
        };
        _data remoteExecCall ["btc_slot_fnc_deserializeState", _unit];
    } else {
        switch (btc_p_autoloadout) do {
            case 1: {
                private _arsenal_trait = _unit call btc_arsenal_fnc_trait;
                _unit setUnitLoadout ([_arsenal_trait select 0] call btc_arsenal_fnc_loadout);
            };
            case 2: {
                (weapons _unit) apply {          
                    _unit removeWeaponGlobal _x;
                };
            };
            default {};
        };
    };
}, _this, 20 * 60] call CBA_fnc_waitUntilAndExecute;