class btc_hearts_and_minds {
    init = "call compileScript ['core\fnc\compile.sqf'];";
    serverInit = "[] call compileScript ['core\def\mission.sqf']; call compileScript ['core\fnc\json\data\addMEH.sqf']; 'btc_ArmaToJSON' callExtension ['getData', [format['btc_hm_%1.JSON', btc_db_saveName]]]";

};
