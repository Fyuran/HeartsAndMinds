#include "..\..\script_macros.hpp"
#include "\x\cba\addons\main\script_macros_mission.hpp"
/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_medical_deserializeState
	
	Description:
	    Deserializes ace medical state to a unit
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [
                ace_player,
                [[5.89533,98.4275,[95,142],100,1,0.468805,true,0,[["rightleg",[[11,1,0.0485834,0.883525]]]],[],[],[0,0,0,0,0,0],[0,0,0,0,0,36.1055],0,[["ACE_tourniquet",1,36.1055]],[0,0,0,0,0,0.883525]],[[]],"Injured"]
            ] call btc_json_fnc_medical_deserializeState;
	    (end)
	
	Author: BaerMitUmlaut, Fyuran
	
---------------------------------------------------------------------------- */
#include "\z\ace\addons\medical\script_component.hpp"

params [
    ["_unit", objNull, [objNull]], 
    ["_state", createHashMap, [createHashMap,[]]]
];

if (isNull _unit) exitWith {};
if (!local _unit) exitWith { ERROR_1("unit [%1] is not local",_unit) };
if(_state isEqualType []) then {_state = createHashMap;};  //fromJSON defaults empty objects to array, pretty fucking stupid

// If unit is not initialized yet, wait until event is raised
if !(_unit getVariable [QGVAR(initialized), false]) exitWith {
    [QEGVAR(medical_status,initialized), {
        params ["_unit"];
        _thisArgs params ["_target"];

        if (_unit == _target) then {
            _thisArgs call FUNC(db,medical_deserializeState);
            [_thisType, _thisId] call CBA_fnc_removeEventHandler;
        };
    }, _this] call CBA_fnc_addEventHandlerArgs;
};

// Migration from old array wounding storage serialized in old versions (<= 3.16.0)
[VAR_OPEN_WOUNDS, VAR_BANDAGED_WOUNDS, VAR_STITCHED_WOUNDS] apply {
    if ((_state getOrDefault [_x, createHashMap]) isEqualType []) then {
        private _migratedWounds = createHashMap;

        (_state get _x) apply {
            _x params ["_class", "_bodyPartIndex", "_amountOf", "_bleeding", "_damage"];

            private _partWounds = _migratedWounds getOrDefault [ALL_BODY_PARTS select _bodyPartIndex, [], true];
            _partWounds pushBack [_class, _amountOf, _bleeding, _damage];
        };

        _state set [_x, _migratedWounds];
    };
};

// Set medical variables
 [
    [VAR_BLOOD_VOL, DEFAULT_BLOOD_VOLUME],
    [VAR_HEART_RATE, DEFAULT_HEART_RATE],
    [VAR_BLOOD_PRESS, [80, 120]],
    [VAR_PERIPH_RES, DEFAULT_PERIPH_RES],
    // State transition should handle this
    // [VAR_CRDC_ARRST, false],
    [VAR_HEMORRHAGE, 0],
    [VAR_PAIN, 0],
    [VAR_IN_PAIN, false],
    [VAR_PAIN_SUPP, 0],
    [VAR_OPEN_WOUNDS, createHashMap],
    [VAR_BANDAGED_WOUNDS, createHashMap],
    [VAR_STITCHED_WOUNDS, createHashMap],
    [VAR_FRACTURES, DEFAULT_FRACTURE_VALUES],
    // State transition should handle this
    // [VAR_UNCON, false],
    [VAR_TOURNIQUET, DEFAULT_TOURNIQUET_VALUES],
    [QEGVAR(medical,occludedMedications), nil],
    [QEGVAR(medical,ivBags), nil],
    [QEGVAR(medical,triageLevel), 0],
    [QEGVAR(medical,triageCard), []],
    [QEGVAR(medical,bodyPartDamage), [0,0,0,0,0,0]]
    // Offset needs to be converted
    // [VAR_MEDICATIONS, []]
] apply {
    _x params ["_key", "_default"];
    private _value = _state getOrDefault [_x, _default];

    // Handle wound hashmaps deserialized as CBA_namespaces
    if (typeName _value == "LOCATION") then {
        private _keys = allVariables _value;
        private _values = _keys apply {_value getVariable _x};
        _value = _keys createHashMapFromArray _values;
    };

    // Treat null as nil
    if (_value isEqualTo objNull) then {
        _value = _default;
    };

    _unit setVariable [_key, _value, true];
};

// Reset timers
_unit setVariable [QEGVAR(medical,lastWakeUpCheck), nil];

// Convert medications offset to time
private _medications = _state getOrDefault [VAR_MEDICATIONS, []];
_medications apply {
    _x set [1, _x#1 + CBA_missionTime];
};
_unit setVariable [VAR_MEDICATIONS, _medications, true];

// Update effects
[_unit] call EFUNC(medical_engine,updateDamageEffects);
[_unit] call EFUNC(medical_status,updateWoundBloodLoss);

// Transition within statemachine
private _currentState = [_unit, GVAR(STATE_MACHINE)] call CBA_statemachine_fnc_getCurrentState;
private _targetState = _state getOrDefault [QGVAR(statemachineState), "Default"];
[_unit, GVAR(STATE_MACHINE), _currentState, _targetState] call CBA_statemachine_fnc_manualTransition;

// Manually call wake up tranisition if necessary
if (_currentState in ["Unconscious", "CardiacArrest"] && {_targetState in ["Default", "Injured"]}) then {
    [_unit, false] call EFUNC(medical_status,setUnconsciousState);
};