
/* ----------------------------------------------------------------------------
Function: btc_task_fnc_showNotification

Description:
    Handles sent notification by server on each client

Parameters:

Returns:

Examples:
    (begin example)
    (end)

Author:
    Karel Moricky(BIS), Fyuran

---------------------------------------------------------------------------- */

params[
	["_data", [], [[]], 14]
];

private _duration = _data param [7];
private _priority = _data param [8];
private ["_queue","_queuePriority","_process","_processDone"];

//--- Add to the queue
_queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
_queue resize (_priority max (count _queue));
if (isnil {_queue select _priority}) then {_queue set [_priority,[]];};
_queuePriority = _queue select _priority;
_queuePriority set [count _queuePriority,_data];
missionnamespace setvariable ["BIS_fnc_showNotification_queue",_queue];

//--- Increase the counter
["BIS_fnc_showNotification_counter",+1] call bis_fnc_counter;

//--- Process the queue
_process = missionnamespace getvariable ["BIS_fnc_showNotification_process",true];
_processDone = if (typename _process == typename true) then {true} else {scriptdone _process};
if (_processDone) then {
	_process = [_data] spawn {
		params[
			["_data", [], [[]], 14]
		];
		scriptname "BIS_fnc_showNotification: queue";
		_queue = missionnamespace getvariable ["BIS_fnc_showNotification_queue",[]];
		_layers = [
			("RscNotification_1" call bis_fnc_rscLayer),
			("RscNotification_2" call bis_fnc_rscLayer)
		];
		_layerID = 0;
		while {count _queue > 0} do {
			_queueID = count _queue - 1;
			_queuePriority = _queue select _queueID;
			if !(isnil {_queuePriority}) then {
				if (count _queuePriority > 0) then {
					_dataID = count _queuePriority - 1;
					_data = +(_queuePriority select _dataID);
					if (count _data > 0 && (alive player || ismultiplayer)) then {
						_duration = _data select 7;

						//--- Show
						missionnamespace setvariable ["RscNotification_data",_data];
						(_layers select _layerID) cutrsc ["RscNotification","plain"];
						_layerID = (_layerID + 1) % 2;
						["BIS_fnc_showNotification_counter",-1] call bis_fnc_counter;

						sleep _duration;
						_queuePriority set [_dataID,[]];
					} else {
						_queuePriority resize _dataID;
					};
				};
				if (count _queuePriority == 0) then {
					_queue resize _queueID;
				};
			} else {
				if (_queueID == count _queue - 1) then {_queue resize _queueID;};
			};
		};
	};
	missionnamespace setvariable ["BIS_fnc_showNotification_process",_process];

	//["[ ] loop exited | _process: %3 | _queue: %1 | BIS_fnc_showNotification_queue: %2",_queue,BIS_fnc_showNotification_queue,_process] call bis_fnc_logFormat;
};