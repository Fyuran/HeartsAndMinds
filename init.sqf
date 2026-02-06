enableSaving [false, false];

[] call compileScript ["define_mod.sqf"];
[] call compileScript ["def.sqf"]; 

if (isServer) then {
    [] call compileScript ["core\init_server.sqf"];
};

if (!isDedicated && hasInterface) then {
    [] call compileScript ["core\init_player.sqf"];
};

if (!isDedicated && !hasInterface) then {
    [] call compileScript ["core\init_headless.sqf"];
};