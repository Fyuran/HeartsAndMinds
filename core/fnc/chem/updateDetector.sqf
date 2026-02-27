#include "..\script_macros.hpp"
/* ----------------------------------------------------------------------------
Function: btc_chem_fnc_updateDetector

Description:
    Per-frame update loop that continuously monitors chemical contamination and updates the detector screen display showing threat level based on distance to nearest contaminated object. Exits when detector view is closed.

Parameters:
    _obj[CONTROL]: Screen control object for the chemical detector display (default: controlNull)

Returns:
    NOTHING

Examples:
    (begin example)
        private _ui = uiNamespace getVariable "RscWeaponChemicalDetector";
        private _obj = _ui displayCtrl 101;
        [_obj] call btc_chem_fnc_updateDetector;
    (end)

Author:
    Vdauphin

---------------------------------------------------------------------------- */

[{
    params ["_arguments", "_idPFH"];
    _arguments params [
        ["_obj", controlNull, [controlNull]]
    ];

    if !(visibleWatch) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };
    if (btc_chem_contaminated isEqualTo []) exitWith {
        _obj ctrlAnimateModel ["Threat_Level_Source", 0, true];
    };

    private _level = selectMin (btc_chem_contaminated apply {player distance _x});
    if (_level < btc_chem_range) then {
        _level = 1;
    } else {
        _level = (floor (btc_chem_range / _level * 10)) / 10;
    };

    _obj ctrlAnimateModel ["Threat_Level_Source", _level, true]; //Displaying a threat level (value between 0.0 and 1.0)
}, 0.3, _this] call CBA_fnc_addPerFrameHandler;
