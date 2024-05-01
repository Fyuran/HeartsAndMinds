/* ----------------------------------------------------------------------------
	Function: btc_json_fnc_fileviewer
	
	Description:
	    Retrieves list of JSON files and allow saving, deleting or copying
	
	Parameters:
	
	Returns:
	
	Examples:
	    (begin example)
	        [] call btc_json_fnc_fileviewer;
	    (end)
	
	Author:
	    Fyuran
	
---------------------------------------------------------------------------- */
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
disableSerialization;

private _display = [] call BIS_fnc_displayMission;
if(isNull _display) exitWith {[format["Could not find display 46: %1", _display], __FILE__, nil, true] call btc_debug_fnc_message;};

private _fileviewer = _display createDisplay "Rsc_btcJSON";
private _exitButton = _fileviewer displayCtrl 2;

//ListBox
uiNamespace setVariable ["btc_JSON_fileviewer_textlbCurSel", ""]; //ensure var is set to "" to avoid undefined behaviour
private _listBox = _fileviewer displayCtrl 1500;
_listBox ctrlAddEventHandler ["LBSelChanged", {
	params ["_listBox", "_lbCurSel"];
	uiNamespace setVariable ["btc_JSON_fileviewer_textlbCurSel", _listBox lbText _lbCurSel];
}];
[] remoteExecCall ["btc_json_fnc_fileviewer_r_server", 2]; //retrieve list of files from server

//RscEdit
private _rscEdit = _fileviewer displayCtrl 1400;
_rscEdit ctrlEnable false;
_rscEdit ctrlAddEventHandler ["KeyDown", {
	params ["_rscEdit", "_key", "_shift", "_ctrl", "_alt"];
	if (_key isEqualTo DIK_RETURN || _key isEqualTo DIK_NUMPADENTER) then {
		_fncName = uiNamespace getVariable ["btc_JSON_fileviewer_rscEdit_fnc", ""]; 
		_path = uiNamespace getVariable ["btc_JSON_fileviewer_textlbCurSel", ""];
		_name = ctrlText _rscEdit;
		if (_fncName isNotEqualTo "" && {_name isNotEqualTo "" && {_path isNotEqualTo ""}}) then {
			[_path, _name] remoteExecCall [_fncName, 2];
			_rscEdit ctrlEnable false;
			uiNamespace setVariable ["btc_JSON_fileviewer_rscEdit_fnc", nil]; 
		};
	};
}];
_rscEdit ctrlAddEventHandler ["KillFocus", {
	params ["_rscEdit"];
	_rscEdit ctrlSetText "";
	_rscEdit ctrlEnable false;
}];

//Save Button
private _saveButton = _fileviewer displayCtrl 1602;
_saveButton ctrlAddEventHandler ["ButtonClick", {
	params ["_saveButton"];
	[] remoteExecCall ["btc_json_fnc_save", 2];
	private _fileviewer = ctrlParent _delButton;
	private _listBox = _fileviewer displayCtrl 1500;
}];

//Copy Button
private _copyButton = _fileviewer displayCtrl 1601;
_copyButton ctrlAddEventHandler ["ButtonClick", {
	params ["_copyButton"];
	_path = uiNamespace getVariable ["btc_JSON_fileviewer_textlbCurSel", ""];
	if(_path isNotEqualTo "") then {
		[_path] remoteExecCall ["btc_json_fnc_copy_file", 2];
		private _fileviewer = ctrlParent _delButton;
		private _listBox = _fileviewer displayCtrl 1500;
	};
}];

//Delete Button
private _delButton = _fileviewer displayCtrl 1600;
_delButton ctrlAddEventHandler ["ButtonClick", {
	params ["_delButton"];
	_path = uiNamespace getVariable ["btc_JSON_fileviewer_textlbCurSel", ""];
	if(_path isNotEqualTo "") then {
		[_path] remoteExecCall ["btc_json_fnc_delete_file", 2];
		private _fileviewer = ctrlParent _delButton;
		private _listBox = _fileviewer displayCtrl 1500;
	};
}];

//Load Button
private _loadButton = _fileviewer displayCtrl 1604;
_loadButton ctrlAddEventHandler ["ButtonClick", {
	params ["_loadButton"];
	_path = uiNamespace getVariable ["btc_JSON_fileviewer_textlbCurSel", ""];
	if(_path isNotEqualTo "") then {
		[_path] remoteExecCall ["btc_json_fnc_load_file", 2];
		private _fileviewer = ctrlParent _delButton;
		private _listBox = _fileviewer displayCtrl 1500;
	};
}];

//Rename Button
private _renameButton = _fileviewer displayCtrl 1603;
_renameButton ctrlAddEventHandler ["ButtonClick", {
	params ["_renameButton"];
	_fileviewer = ctrlParent _renameButton;
	private _rscEdit = _fileviewer displayCtrl 1400;
	_rscEdit ctrlEnable true;
	_rscEdit ctrlSetText "Insert valid name...(Press Enter to Commit)";
	ctrlSetFocus _rscEdit;
	uiNamespace setVariable ["btc_JSON_fileviewer_rscEdit_fnc", "btc_json_fnc_rename_file"]; 
	private _listBox = _fileviewer displayCtrl 1500;
}];
//[message, header, okButton, cancelButton, parent, useParentBox, pause] call BIS_fnc_guiMessage
//[text, title, buttonOK, buttonCancel, icon, parentDisplay] call BIS_fnc_3DENShowMessage