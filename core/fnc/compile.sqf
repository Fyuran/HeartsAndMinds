#include "script_macros.hpp"
/////////////////////SERVER\\\\\\\\\\\\\\\\\\\\\
if (isServer) then {
    //BODY
    FUNC(body,bagRecover_s) = compileScript ["core\fnc\body\bagRecover_s.sqf"];
    FUNC(body,createMarker) = compileScript ["core\fnc\body\createMarker.sqf"];
    FUNC(body,dogtagGet) = compileScript ["core\fnc\body\dogtagGet.sqf"];
    FUNC(body,dogtagSet) = compileScript ["core\fnc\body\dogtagSet.sqf"];
    FUNC(body,setBodyBag) = compileScript ["core\fnc\body\setBodyBag.sqf"];
    FUNC(body,create) = compileScript ["core\fnc\body\create.sqf"];
    FUNC(body,get) = compileScript ["core\fnc\body\get.sqf"];

    //CACHE
    FUNC(cache,find_pos) = compileScript ["core\fnc\cache\find_pos.sqf"];
    FUNC(cache,create) = compileScript ["core\fnc\cache\create.sqf"];
    FUNC(cache,create_attachto) = compileScript ["core\fnc\cache\create_attachto.sqf"];
    FUNC(cache,init) = compileScript ["core\fnc\cache\init.sqf"];

    //COMMON
    FUNC(common,check_los) = compileScript ["core\fnc\common\check_los.sqf"];
    FUNC(common,create_composition) = compileScript ["core\fnc\common\create_composition.sqf"];
    FUNC(common,house_addWP) = compileScript ["core\fnc\common\house_addWP.sqf"];
    FUNC(common,set_damage) = compileScript ["core\fnc\common\set_damage.sqf"];
    FUNC(common,road_direction) = compileScript ["core\fnc\common\road_direction.sqf"];
    FUNC(common,findsafepos) = compileScript ["core\fnc\common\findsafepos.sqf"];
    FUNC(common,find_closecity) = compileScript ["core\fnc\common\find_closecity.sqf"];
    FUNC(common,delete) = compileScript ["core\fnc\common\delete.sqf"];
    FUNC(common,deleteEntities) = compileScript ["core\fnc\common\deleteEntities.sqf"];
    FUNC(common,final_phase) = compileScript ["core\fnc\common\final_phase.sqf"];
    FUNC(common,findPosOutsideRock) = compileScript ["core\fnc\common\findposoutsiderock.sqf"];
    FUNC(common,typeOf) = compileScript ["core\fnc\common\typeOf.sqf"];
    FUNC(common,roof) = compileScript ["core\fnc\common\roof.sqf"];
    FUNC(common,moveOut) = compileScript ["core\fnc\common\moveOut.sqf"];
    FUNC(common,changeWeather) = compileScript ["core\fnc\common\changeWeather.sqf"];
    FUNC(common,find_highest_pos) = compileScript ["core\fnc\common\find_highest_pos.sqf"];
    FUNC(common,correct_position) = compileScript ["core\fnc\common\correct_position.sqf"];
    FUNC(common,circlePosAroundObj) = compileScript ["core\fnc\common\circlePosAroundObj.sqf"];
    FUNC(common,getCompositionBoundingBox) = compileScript ["core\fnc\common\getCompositionBoundingBox.sqf"];
    FUNC(common,getBoundingCornersPos) = compileScript ["core\fnc\common\getBoundingCornersPos.sqf"];
    FUNC(common,show_custom_hint) = compileScript ["core\fnc\common\show_custom_hint.sqf"];
    FUNC(common,getAddonClasses) = compileScript ["core\fnc\common\getAddonClasses.sqf"];
    FUNC(common,getFilteredLoadout) = compileScript ["core\fnc\common\getFilteredLoadout.sqf"];

    //CHEM
    FUNC(chem,checkLoop) = compileScript ["core\fnc\chem\checkLoop.sqf"];
    FUNC(chem,propagate) = compileScript ["core\fnc\chem\propagate.sqf"];
    FUNC(chem,handleShower) = compileScript ["core\fnc\chem\handleShower.sqf"];

    //CITY
    FUNC(city,activate) = compileScript ["core\fnc\city\activate.sqf"];
    FUNC(city,create) = compileScript ["core\fnc\city\create.sqf"];
    FUNC(city,de_activate) = compileScript ["core\fnc\city\de_activate.sqf"];
    FUNC(city,setClear) = compileScript ["core\fnc\city\setClear.sqf"];
    FUNC(city,setPlayerTrigger) = compileScript ["core\fnc\city\setPlayerTrigger.sqf"];
    FUNC(city,cleanUp) = compileScript ["core\fnc\city\cleanUp.sqf"];
    FUNC(city,trigger_free_condition) = compileScript ["core\fnc\city\trigger_free_condition.sqf"];
    FUNC(city,getHouses) = compileScript ["core\fnc\city\getHouses.sqf"];
    FUNC(city,send) = compileScript ["core\fnc\city\send.sqf"];

    //CIV
    FUNC(civ,add_grenade) = compileScript ["core\fnc\civ\add_grenade.sqf"];
    FUNC(civ,get_weapons) = compileScript ["core\fnc\civ\get_weapons.sqf"];
    FUNC(civ,get_grenade) = compileScript ["core\fnc\civ\get_grenade.sqf"];
    FUNC(civ,populate) = compileScript ["core\fnc\civ\populate.sqf"];
    FUNC(civ,create_patrol) = compileScript ["core\fnc\civ\create_patrol.sqf"];
    FUNC(civ,evacuate) = compileScript ["core\fnc\civ\evacuate.sqf"];
    FUNC(civ,createFlower) = compileScript ["core\fnc\civ\createFlower.sqf"];

    //DATA
    FUNC(data,add_group) = compileScript ["core\fnc\data\add_group.sqf"];
    FUNC(data,get_group) = compileScript ["core\fnc\data\get_group.sqf"];
    FUNC(data,spawn_group) = compileScript ["core\fnc\data\spawn_group.sqf"];

    //DEAF
    FUNC(deaf,earringing) = compileScript ["core\fnc\deaf\earringing.sqf"];

    //DB
    FUNC(db,initDefault) = compileScript ["core\fnc\db\initDefault.sqf"];
    FUNC(db,loadObjectStatus) = compileScript ["core\fnc\db\loadObjectStatus.sqf"];
    FUNC(db,saveObjectStatus) = compileScript ["core\fnc\db\saveObjectStatus.sqf"];
    FUNC(db,loadCargo) = compileScript ["core\fnc\db\loadcargo.sqf"];
    FUNC(db,autoRestart) = compileScript ["core\fnc\db\autoRestart.sqf"];
    FUNC(db,setTurretMagazines) = compileScript ["core\fnc\db\setTurretMagazines.sqf"];
    FUNC(db,autoRestartLoop) = compileScript ["core\fnc\db\autoRestartLoop.sqf"];
    FUNC(db,save_enabled_city) = compileScript ["core\fnc\db\save_enabled_city.sqf"]; 
    FUNC(db,save) = compileScript ["core\fnc\db\save.sqf"];
    FUNC(db,load) = compileScript ["core\fnc\db\load.sqf"];
    FUNC(db,createVehicle) = compileScript ["core\fnc\db\data\createVehicle.sqf"];
    FUNC(db,encodeJSON) = compileScript ["core\fnc\db\data\encodeJSON.sqf"];
    FUNC(db,parse_data) = compileScript ["core\fnc\db\data\parse_data.sqf"];
    FUNC(db,request_data) = compileScript["core\fnc\db\data\request_data.sqf"];
    FUNC(db,request_data_category) = compileScript["core\fnc\db\data\request_data_category.sqf"];
    FUNC(db,delete_file) = compileScript ["core\fnc\db\ui\delete.sqf"];
    FUNC(db,rename_file) = compileScript ["core\fnc\db\ui\rename.sqf"];
    FUNC(db,copy_file) = compileScript ["core\fnc\db\ui\copy.sqf"];
    FUNC(db,load_file) = compileScript ["core\fnc\db\ui\load.sqf"];
    FUNC(db,fileviewer_r_server) = compileScript ["core\fnc\db\ui\fileviewer_r_server.sqf"];
    FUNC(db,medical_serializeState) = compileScript ["core\fnc\db\data\medical_serializeState.sqf"]; 
    FUNC(db,medical_deserializeState) = compileScript ["core\fnc\db\data\medical_deserializeState.sqf"];
    

    //DELAY
    FUNC(delay,createUnit) = compileScript ["core\fnc\delay\createUnit.sqf"];
    FUNC(delay,createVehicle) = compileScript ["core\fnc\delay\createVehicle.sqf"];
    FUNC(delay,createAgent) = compileScript ["core\fnc\delay\createAgent.sqf"];
    FUNC(delay,exec) = compileScript ["core\fnc\delay\exec.sqf"];
    FUNC(delay,waitAndExecute) = compileScript ["core\fnc\delay\waitAndExecute.sqf"];

    //DEBUG
    FUNC(debug,request_server_data) = compileScript ["core\fnc\debug\server_to_client\request_server_data.sqf"];
    FUNC(debug,show_fps) = compileScript ["core\fnc\debug\show_fps.sqf"];

    //DOOR
    FUNC(door,lock) = compileScript ["core\fnc\door\lock.sqf"];
    FUNC(door,get) = compileScript ["core\fnc\door\get.sqf"];

    //EH
    FUNC(eh,server) = compileScript ["core\fnc\eh\server.sqf"];
    FUNC(eh,setSunriseOrSunset) = compileScript ["core\fnc\eh\setSunriseOrSunset.sqf"]; 
    FUNC(eh,buildingChanged) = compileScript ["core\fnc\eh\buildingChanged.sqf"];  
    FUNC(eh,inventory) = compileScript ["core\fnc\eh\inventory.sqf"];

    //EVENT
    FUNC(event,eventManager) = compileScript ["core\fnc\event\eventManager.sqf"];
    FUNC(event,canFOBBeAttacked) = compileScript ["core\fnc\event\FOB\canAttack.sqf"];
    FUNC(event,attackFOBChance) = compileScript ["core\fnc\event\FOB\chance.sqf"];
    FUNC(event,attackFOBspawn) = compileScript ["core\fnc\event\FOB\spawn.sqf"];

    //FOB
    FUNC(fob,create_s) = compileScript ["core\fnc\fob\create_s.sqf"];
    FUNC(fob,dismantle_s) = compileScript ["core\fnc\fob\dismantle_s.sqf"];
    FUNC(fob,killed) = compileScript ["core\fnc\fob\killed.sqf"];
    FUNC(fob,rallypointTimer) = compileScript ["core\fnc\fob\rallypointTimer.sqf"];
    FUNC(fob,alarmTrg) = compileScript ["core\fnc\fob\alarmTrg.sqf"];
    FUNC(fob,destroyTrg) = compileScript ["core\fnc\fob\destroyTrg.sqf"];
    FUNC(fob,ruins) = compileScript ["core\fnc\fob\ruins\ruins.sqf"];
    FUNC(fob,reactivation) = compileScript ["core\fnc\fob\ruins\reactivation.sqf"];

    //GARRISON
    FUNC(garrison,spawn) = compileScript ["core\fnc\garrison\spawn.sqf"];
    FUNC(garrison,replenish) = compileScript ["core\fnc\garrison\replenish.sqf"];

    //HIDEOUT
    FUNC(hideout,hd) = compileScript ["core\fnc\hideout\hd.sqf"];
    FUNC(hideout,create) = compileScript ["core\fnc\hideout\create.sqf"];
    FUNC(hideout,create_composition) = compileScript ["core\fnc\hideout\create_composition.sqf"];

    //IED
    FUNC(ied,boom) = compileScript ["core\fnc\ied\boom.sqf"];
    FUNC(ied,check) = compileScript ["core\fnc\ied\check.sqf"];
    FUNC(ied,checkLoop) = compileScript ["core\fnc\ied\checkLoop.sqf"];
    FUNC(ied,create) = compileScript ["core\fnc\ied\create.sqf"];
    FUNC(ied,fired_near) = compileScript ["core\fnc\ied\fired_near.sqf"];
    FUNC(ied,initArea) = compileScript ["core\fnc\ied\initArea.sqf"];
    FUNC(ied,suicider_active) = compileScript ["core\fnc\ied\suicider_active.sqf"];
    FUNC(ied,suicider_activeLoop) = compileScript ["core\fnc\ied\suicider_activeLoop.sqf"];
    FUNC(ied,suicider_create) = compileScript ["core\fnc\ied\suicider_create.sqf"];
    FUNC(ied,suiciderLoop) = compileScript ["core\fnc\ied\suiciderLoop.sqf"];
    FUNC(ied,suicider_fob_create) = compileScript ["core\fnc\ied\suicider_fob_create.sqf"];
    FUNC(ied,suicider_fobLoop) = compileScript ["core\fnc\ied\suicider_fobLoop.sqf"];
    FUNC(ied,allahu_akbar) = compileScript ["core\fnc\ied\allahu_akbar.sqf"];
    FUNC(ied,drone_active) = compileScript ["core\fnc\ied\drone_active.sqf"];
    FUNC(ied,drone_create) = compileScript ["core\fnc\ied\drone_create.sqf"];
    FUNC(ied,droneLoop) = compileScript ["core\fnc\ied\droneLoop.sqf"];
    FUNC(ied,drone_fire) = compileScript ["core\fnc\ied\drone_fire.sqf"];
    FUNC(ied,randomRoadPos) = compileScript ["core\fnc\ied\randomRoadPos.sqf"];

    //INFO
    FUNC(info,cache) = compileScript ["core\fnc\info\cache.sqf"];
    FUNC(info,give_intel) = compileScript ["core\fnc\info\give_intel.sqf"];
    FUNC(info,has_intel) = compileScript ["core\fnc\info\has_intel.sqf"];
    FUNC(info,hideout) = compileScript ["core\fnc\info\hideout.sqf"];
    FUNC(info,cacheMarker) = compileScript ["core\fnc\info\cacheMarker.sqf"];
    FUNC(info,path) = compileScript ["core\fnc\info\path.sqf"];
    FUNC(info,createIntels) = compileScript ["core\fnc\info\createIntels.sqf"];
    FUNC(info,supplies) = compileScript ["core\fnc\info\supplies.sqf"]; 

    //JAIL
    FUNC(jail,setCaptives_s) = compileScript ["core\fnc\jail\setCaptives_s.sqf"];
    FUNC(jail,detain_s) = compileScript ["core\fnc\jail\detain_s.sqf"];
    FUNC(jail,createJail_s) = compileScript ["core\fnc\jail\createJail_s.sqf"];
    FUNC(jail,removeJail_s) = compileScript ["core\fnc\jail\removeJail_s.sqf"];

    //LOG
    FUNC(log,createVehicle) = compileScript ["core\fnc\log\createVehicle.sqf"];
    FUNC(log,init) = compileScript ["core\fnc\log\init.sqf"];
    FUNC(log,delete) = compileScript ["core\fnc\log\services\delete.sqf"];
    FUNC(log,create_s) = compileScript ["core\fnc\log\services\create_s.sqf"];
    FUNC(log,server_repair_wreck) = compileScript ["core\fnc\log\services\server_repair_wreck.sqf"];

    FUNC(log_dialog,init_tables) = compileScript ["core\fnc\log\dialog\init_tables.sqf"];

    FUNC(log_fob,create_s) = compileScript ["core\fnc\log\fob\create_s.sqf"];
    FUNC(log_fob,remove) = compileScript ["core\fnc\log\fob\remove.sqf"];
    FUNC(log_fob,refund) = compileScript ["core\fnc\log\fob\refund.sqf"];
    FUNC(log_fob,payment) = compileScript ["core\fnc\log\fob\payment.sqf"];

    FUNC(log_resupply,doResupply) = compileScript ["core\fnc\log\resupply\doResupply.sqf"];
    FUNC(log_resupply,city_create) = compileScript ["core\fnc\log\resupply\city_create.sqf"];
    FUNC(log_resupply,claimed_create) = compileScript ["core\fnc\log\resupply\claimed_create.sqf"];
    FUNC(log_resupply,claim) = compileScript ["core\fnc\log\resupply\claim.sqf"];
    FUNC(log_resupply,delete) = compileScript ["core\fnc\log\resupply\delete.sqf"];

    //MIL
    FUNC(mil,addWP) = compileScript ["core\fnc\mil\addWP.sqf"];
    FUNC(mil,check_cap) = compileScript ["core\fnc\mil\check_cap.sqf"];
    FUNC(mil,create_group) = compileScript ["core\fnc\mil\create_group.sqf"];
    FUNC(mil,create_static) = compileScript ["core\fnc\mil\create_static.sqf"];
    FUNC(mil,create_patrol) = compileScript ["core\fnc\mil\create_patrol.sqf"];
    FUNC(mil,send) = compileScript ["core\fnc\mil\send.sqf"];
    FUNC(mil,set_skill) = compileScript ["core\fnc\mil\set_skill.sqf"];
    FUNC(mil,getStructures) = compileScript ["core\fnc\mil\getStructures.sqf"];
    FUNC(mil,getBuilding) = compileScript ["core\fnc\mil\getBuilding.sqf"];
    FUNC(mil,createVehicle) = compileScript ["core\fnc\mil\createVehicle.sqf"];
    FUNC(mil,createUnits) = compileScript ["core\fnc\mil\createUnits.sqf"];
    FUNC(mil,unit_killed) = compileScript ["core\fnc\mil\unit_killed.sqf"];
    FUNC(mil,create_staticOnRoof) = compileScript ["core\fnc\mil\create_staticOnRoof.sqf"];

    //PATROL
    FUNC(patrol,playersInAreaCityGroup) = compileScript ["core\fnc\patrol\playersInAreaCityGroup.sqf"];
    FUNC(patrol,usefulCity) = compileScript ["core\fnc\patrol\usefulCity.sqf"];
    FUNC(patrol,WPCheck) = compileScript ["core\fnc\patrol\WPCheck.sqf"];
    FUNC(patrol,WPFOBCheck) = compileScript ["core\fnc\patrol\WPFOBCheck.sqf"];
    FUNC(patrol,init) = compileScript ["core\fnc\patrol\init.sqf"];
    FUNC(patrol,addWP) = compileScript ["core\fnc\patrol\addWP.sqf"];
    FUNC(patrol,eh) = compileScript ["core\fnc\patrol\eh.sqf"];
    FUNC(patrol,addEH) = compileScript ["core\fnc\patrol\addEH.sqf"];

    //REP
    FUNC(rep,call_militia) = compileScript ["core\fnc\rep\call_militia.sqf"];
    FUNC(rep,change) = compileScript ["core\fnc\rep\change.sqf"];
    FUNC(rep,eh_effects) = compileScript ["core\fnc\rep\eh_effects.sqf"];
    FUNC(rep,hh) = compileScript ["core\fnc\rep\hh.sqf"];
    FUNC(rep,buildingchanged) = compileScript ["core\fnc\rep\buildingchanged.sqf"];
    FUNC(rep,explosives_defuse) = compileScript ["core\fnc\rep\explosives_defuse.sqf"];
    FUNC(rep,killed) = compileScript ["core\fnc\rep\killed.sqf"];
    FUNC(rep,wheelChange) = compileScript ["core\fnc\rep\wheelChange.sqf"];
    FUNC(rep,addToScoreboard) = compileScript ["core\fnc\rep\addToScoreboard.sqf"];

    //RESPAWN
    FUNC(respawn,addTicket) = compileScript ["core\fnc\respawn\addTicket.sqf"];
    FUNC(respawn,playerConnected) = compileScript ["core\fnc\respawn\playerConnected.sqf"];
    FUNC(respawn,player) = compileScript ["core\fnc\respawn\player.sqf"];

    //SLOT
    FUNC(slot,getData) = compileScript ["core\fnc\slot\getData.sqf"];
    FUNC(slot,saveData) = compileScript ["core\fnc\slot\saveData.sqf"];
    FUNC(slot,getPlayableSlots) = compileScript ["core\fnc\slot\getPlayableSlots.sqf"];

    //SIDE
    FUNC(side,create) = compileScript ["core\fnc\side\create.sqf"];
    FUNC(side,get_city) = compileScript ["core\fnc\side\get_city.sqf"];
    FUNC(side,mines) = compileScript ["core\fnc\side\mines.sqf"];
    FUNC(side,supply) = compileScript ["core\fnc\side\supply.sqf"];
    FUNC(side,vehicle) = compileScript ["core\fnc\side\vehicle.sqf"];
    FUNC(side,civtreatment) = compileScript ["core\fnc\side\civtreatment.sqf"];
    FUNC(side,tower) = compileScript ["core\fnc\side\tower.sqf"];
    FUNC(side,checkpoint) = compileScript ["core\fnc\side\checkpoint.sqf"];
    FUNC(side,civtreatment_boat) = compileScript ["core\fnc\side\civtreatment_boat.sqf"];
    FUNC(side,underwater_generator)= compileScript ["core\fnc\side\underwater_generator.sqf"];
    FUNC(side,convoy) = compileScript ["core\fnc\side\convoy.sqf"];
    FUNC(side,rescue) = compileScript ["core\fnc\side\rescue.sqf"];
    FUNC(side,capture_officer) = compileScript ["core\fnc\side\capture_officer.sqf"];
    FUNC(side,hostage) = compileScript ["core\fnc\side\hostage.sqf"];
    FUNC(side,hack) = compileScript ["core\fnc\side\hack.sqf"];
    FUNC(side,kill) = compileScript ["core\fnc\side\kill.sqf"];
    FUNC(side,chemicalLeak) = compileScript ["core\fnc\side\chemicalLeak.sqf"];
    FUNC(side,EMP) = compileScript ["core\fnc\side\EMP.sqf"];
    FUNC(side,removeRubbish) = compileScript ["core\fnc\side\removeRubbish.sqf"];
    FUNC(side,pandemic) = compileScript ["core\fnc\side\pandemic.sqf"];

    //SPECT
    FUNC(spect,checkLoop) = compileScript ["core\fnc\spect\checkLoop.sqf"];
    FUNC(spect,electronicFailure) = compileScript ["core\fnc\spect\electronicFailure.sqf"];

    //TAG
    FUNC(tag,initArea) = compileScript ["core\fnc\tag\initArea.sqf"];
    FUNC(tag,eh) = compileScript ["core\fnc\tag\eh.sqf"];
    FUNC(tag,create) = compileScript ["core\fnc\tag\create.sqf"];
	FUNC(tag,vehicle) = compileScript ["core\fnc\tag\vehicle.sqf"];

    //TASK
    FUNC(task,create) = compileScript ["core\fnc\task\create.sqf"];
    FUNC(task,setState) = compileScript ["core\fnc\task\setState.sqf"];
    FUNC(task,showNotification_s) = compileScript ["core\fnc\task\showNotification_s.sqf"];

    //TOW
    FUNC(tow,ropeBreak) = compileScript ["core\fnc\tow\ropeBreak.sqf"];
    FUNC(tow,ViV) = compileScript ["core\fnc\tow\ViV.sqf"];

    //VEH
    FUNC(veh,addRespawn) = compileScript ["core\fnc\veh\addRespawn.sqf"];
    FUNC(veh,killed) = compileScript ["core\fnc\veh\killed.sqf"];
    FUNC(veh,respawn) = compileScript ["core\fnc\veh\respawn.sqf"];
    FUNC(veh,propertiesGet) = compileScript ["core\fnc\veh\propertiesGet.sqf"];
    FUNC(veh,propertiesSet) = compileScript ["core\fnc\veh\propertiesSet.sqf"];
    FUNC(veh,add) = compileScript ["core\fnc\veh\add.sqf"];
    FUNC(veh,inventoryRestore) = compileScript ["core\fnc\veh\inventoryRestore.sqf"];
    FUNC(veh,getCargo) = compileScript ["core\fnc\veh\getCargo.sqf"];
    FUNC(veh,getData) = compileScript ["core\fnc\veh\getData.sqf"];
    FUNC(veh,loadCargo) = compileScript ["core\fnc\veh\loadCargo.sqf"];
    FUNC(veh,loadData) = compileScript ["core\fnc\veh\loadData.sqf"];
};

/////////////////////EVERYONE\\\\\\\\\\\\\\\\\\\\\
//ARSENAL
FUNC(arsenal,ammoUsage) = compileScript ["core\fnc\arsenal\ammoUsage.sqf"];

//CACHE
FUNC(cache,hd) = compileScript ["core\fnc\cache\hd.sqf"];

//COMMON
FUNC(common,get_class) = compileScript ["core\fnc\common\get_class.sqf"];
FUNC(common,randomize_pos) = compileScript ["core\fnc\common\randomize_pos.sqf"];
FUNC(common,getHouses) = compileScript ["core\fnc\common\getHouses.sqf"];
FUNC(common,house_addWP_loop) = compileScript ["core\fnc\common\house_addWP_loop.sqf"];

//CIV
FUNC(civ,class) = compileScript ["core\fnc\civ\class.sqf"];
FUNC(civ,addWP) = compileScript ["core\fnc\civ\addWP.sqf"];
FUNC(civ,add_weapons) = compileScript ["core\fnc\civ\add_weapons.sqf"];

//CHEM
FUNC(chem,damage) = compileScript ["core\fnc\chem\damage.sqf"];
FUNC(chem,deconShowerAnimLarge) = {(_this select 0) setVariable ["BIN_Shower_Stop",false, "."]; _this call BIN_fnc_deconShowerAnimLarge;};
FUNC(chem,damageLoop) = compileScript ["core\fnc\chem\damageLoop.sqf"];

//DOOR
FUNC(door,broke) = compileScript ["core\fnc\door\broke.sqf"];

//DEBUG
FUNC(debug,message) = compileScript ["core\fnc\debug\message.sqf"];
CBA_hem_fnc_debug2 = compileScript ["core\fnc\debug\cba_fnc_debug2.sqf"];

//EH
FUNC(eh,trackItem) = compileScript ["core\fnc\eh\trackItem.sqf"];

//FLAG
FUNC(flag,int) = compileScript ["core\fnc\flag\int.sqf"];

//IED
FUNC(ied,belt) = compileScript ["core\fnc\ied\belt.sqf"];

//INT
FUNC(int,orders_give) = compileScript ["core\fnc\int\orders_give.sqf"];
FUNC(int,orders_behaviour) = compileScript ["core\fnc\int\orders_behaviour.sqf"];
FUNC(int,ask_var) = compileScript ["core\fnc\int\ask_var.sqf"];

//LOG
FUNC(log,place_destroy_camera) = compileScript ["core\fnc\log\services\place_destroy_camera.sqf"];
FUNC(log,inventoryGet) = compileScript ["core\fnc\log\inventory\inventoryGet.sqf"];
FUNC(log,inventorySet) = compileScript ["core\fnc\log\inventory\inventorySet.sqf"];

//MIL
FUNC(mil,getPlayersClasses) = compileScript ["core\fnc\mil\getPlayersClasses.sqf"];
FUNC(mil,class) = compileScript ["core\fnc\mil\class.sqf"];
FUNC(mil,ammoUsage) = compileScript ["core\fnc\mil\ammoUsage.sqf"];

//PATROL
FUNC(patrol,disabled) = compileScript ["core\fnc\patrol\disabled.sqf"];

//REP
FUNC(rep,hd) = compileScript ["core\fnc\rep\hd.sqf"];
FUNC(rep,suppressed) = compileScript ["core\fnc\rep\suppressed.sqf"];
FUNC(rep,foodRemoved) = compileScript ["core\fnc\rep\foodRemoved.sqf"];

//TOW
FUNC(tow,int) = compileScript ["core\fnc\tow\int.sqf"];

//VEH
FUNC(veh,init) = compileScript ["core\fnc\veh\init.sqf"];

/////////////////////CLIENT\\\\\\\\\\\\\\\\\\\\\
if (!isDedicated) then {
    //ARSENAL
    FUNC(arsenal,data) = compileScript ["core\fnc\arsenal\data.sqf"];
    FUNC(arsenal,garage) = compileScript ["core\fnc\arsenal\garage.sqf"];
    FUNC(arsenal,loadout) = compileScript ["core\fnc\arsenal\loadout.sqf"];
    FUNC(arsenal,trait) = compileScript ["core\fnc\arsenal\trait.sqf"];
    FUNC(arsenal,ammoUsage) = compileScript ["core\fnc\arsenal\ammoUsage.sqf"];
    FUNC(arsenal,weaponsFilter) = compileScript ["core\fnc\arsenal\weaponsfilter.sqf"];

    //BODY
    FUNC(body,bagRecover) = compileScript ["core\fnc\body\bagRecover.sqf"];

    //COMMON
    FUNC(common,end_mission) = compileScript ["core\fnc\common\end_mission.sqf"];
    FUNC(common,get_cardinal) = compileScript ["core\fnc\common\get_cardinal.sqf"];
    FUNC(common,show_hint) = compileScript ["core\fnc\common\show_hint.sqf"];
    FUNC(common,set_markerTextLocal) = compileScript ["core\fnc\common\set_markerTextLocal.sqf"];
    FUNC(common,showSubtitle) = compileScript ["core\fnc\common\showSubtitle.sqf"];
    FUNC(common,get_composition) = compileScript ["core\fnc\common\get_composition.sqf"];
    FUNC(common,isAreaOccupied) = compileScript ["core\fnc\common\isAreaOccupied.sqf"];
    FUNC(common,typeOfPreview) = compileScript ["core\fnc\common\typeOfPreview.sqf"];
    FUNC(common,get_corner_points) = compileScript ["core\fnc\common\get_corner_points.sqf"];
    FUNC(common,typeText) = compileScript ["core\fnc\common\typeText.sqf"]; 

    //CHEM
    FUNC(chem,biopsy) = compileScript ["core\fnc\chem\biopsy.sqf"];
    FUNC(chem,ehDetector) = compileScript ["core\fnc\chem\ehDetector.sqf"];
    FUNC(chem,updateDetector) = compileScript ["core\fnc\chem\updateDetector.sqf"];

    //CIV
    FUNC(civ,add_leaflets) = compileScript ["core\fnc\civ\add_leaflets.sqf"];
    FUNC(civ,leaflets) = compileScript ["core\fnc\civ\leaflets.sqf"];

    //DEBUG
    FUNC(debug,marker) = compileScript ["core\fnc\debug\marker.sqf"];
    FUNC(debug,units) = compileScript ["core\fnc\debug\units.sqf"];
    FUNC(debug,fps) = compileScript ["core\fnc\debug\fps.sqf"];
    FUNC(debug,graph) = compileScript ["core\fnc\debug\graph.sqf"];
    FUNC(debug,cities) = compileScript ["core\fnc\debug\server_to_client\cities.sqf"];
    FUNC(debug,hideouts) = compileScript ["core\fnc\debug\server_to_client\hideouts.sqf"];
    FUNC(debug,cache) = compileScript ["core\fnc\debug\server_to_client\cache.sqf"];
    FUNC(debug,supplies) = compileScript ["core\fnc\debug\server_to_client\supplies.sqf"];
    FUNC(debug,debug_mode) = compileScript ["core\fnc\debug\debug_mode.sqf"]; 

    //DOOR
    FUNC(door,break) = compileScript ["core\fnc\door\break.sqf"];

    //EH
    FUNC(eh,CuratorObjectPlaced) = compileScript ["core\fnc\eh\CuratorObjectPlaced.sqf"];
    FUNC(eh,player) = compileScript ["core\fnc\eh\player.sqf"];

    //FLAG
    FUNC(flag,deploy) = compileScript ["core\fnc\flag\deploy.sqf"];

    //FOB
    FUNC(fob,create) = compileScript ["core\fnc\fob\create.sqf"];
    FUNC(fob,rallypointAssemble) = compileScript ["core\fnc\fob\rallypointAssemble.sqf"];
    FUNC(fob,redeploy) = compileScript ["core\fnc\fob\redeploy.sqf"];
    FUNC(fob,redeployCheck) = compileScript ["core\fnc\fob\redeployCheck.sqf"];
    FUNC(fob,reactivationActions) = compileScript ["core\fnc\fob\ruins\reactivationActions.sqf"];

    //IED
    FUNC(ied,effects) = compileScript ["core\fnc\ied\effects.sqf"];
    FUNC(ied,effect_smoke) = compileScript ["core\fnc\ied\effect_smoke.sqf"];
    FUNC(ied,effect_color_smoke) = compileScript ["core\fnc\ied\effect_color_smoke.sqf"];
    FUNC(ied,effect_rocks) = compileScript ["core\fnc\ied\effect_rocks.sqf"];
    FUNC(ied,effect_blurEffect) = compileScript ["core\fnc\ied\effect_blurEffect.sqf"];
    FUNC(ied,effect_shock_wave) = compileScript ["core\fnc\ied\effect_shock_wave.sqf"];
    FUNC(ied,deleteLoop) = compileScript ["core\fnc\ied\deleteLoop.sqf"];

    //INT
    FUNC(int,add_actions) = compileScript ["core\fnc\int\add_actions.sqf"];
    FUNC(int,orders) = compileScript ["core\fnc\int\orders.sqf"];
    FUNC(int,shortcuts) = compileScript ["core\fnc\int\shortcuts.sqf"];
    FUNC(int,terminal) = compileScript ["core\fnc\int\terminal.sqf"];
    FUNC(int,foodGive) = compileScript ["core\fnc\int\foodGive.sqf"];
    FUNC(int,ordersLoop) = compileScript ["core\fnc\int\ordersLoop.sqf"];
    FUNC(int,checkSirenBeacons) = compileScript ["core\fnc\int\checkSirenBeacons.sqf"];
    FUNC(int,horn) = compileScript ["core\fnc\int\horn.sqf"];

    //INFO
    FUNC(info,ask) = compileScript ["core\fnc\info\ask.sqf"];
    FUNC(info,hideout_asked) = compileScript ["core\fnc\info\hideout_asked.sqf"];
    FUNC(info,search_for_intel) = compileScript ["core\fnc\info\search_for_intel.sqf"];
    FUNC(info,troops) = compileScript ["core\fnc\info\troops.sqf"];
    FUNC(info,ask_reputation) = compileScript ["core\fnc\info\ask_reputation.sqf"];
    FUNC(info,cachePicture) = compileScript ["core\fnc\info\cachePicture.sqf"];

    //JAIL
    FUNC(jail,createJail) = compileScript ["core\fnc\jail\createJail.sqf"];

	if(!isClass(configFile >> "CfgPatches" >> "btc_lift")) then {
    //LIFT
		FUNC(lift,check) = compileScript ["core\fnc\lift\check.sqf"];
		FUNC(lift,deployRopes) = compileScript ["core\fnc\lift\deployRopes.sqf"];
		FUNC(lift,destroyRopes) = compileScript ["core\fnc\lift\destroyRopes.sqf"];
		FUNC(lift,hook) = compileScript ["core\fnc\lift\hook.sqf"];
		FUNC(lift,hookFake) = compileScript ["core\fnc\lift\hookFake.sqf"];
		FUNC(lift,hud) = compileScript ["core\fnc\lift\hud.sqf"];
		FUNC(lift,hudLoop) = compileScript ["core\fnc\lift\hudLoop.sqf"];
		FUNC(lift,getLiftable) = compileScript ["core\fnc\lift\getLiftable.sqf"];
		FUNC(lift,addActions) = compileScript ["core\fnc\lift\addActions.sqf"];
	};
	FUNC(lift,shortcuts) = compileScript ["core\fnc\lift\shortcuts.sqf"];

    //LOG
    FUNC(log_dialog,createDialog) = compileScript ["core\fnc\log\dialog\createDialog.sqf"];
    FUNC(log_dialog,apply) = compileScript ["core\fnc\log\dialog\apply.sqf"];
    FUNC(log_dialog,mainClass_LBSelChanged) = compileScript ["core\fnc\log\dialog\mainClass_LBSelChanged.sqf"];
    FUNC(log_dialog,subClass_LBSelChanged) = compileScript ["core\fnc\log\dialog\subClass_LBSelChanged.sqf"]; 

    FUNC(log,place) = compileScript ["core\fnc\log\place.sqf"];
    FUNC(log,place_key_down) = compileScript ["core\fnc\log\place_key_down.sqf"];
    FUNC(log,place_mouse_zchanged) = compileScript ["core\fnc\log\place_mouse_zchanged.sqf"];
    FUNC(log,drawResources3D) = compileScript ["core\fnc\log\drawResources3D.sqf"];

    FUNC(log_fob,create) = compileScript ["core\fnc\log\fob\create.sqf"];
    FUNC(log_fob,actions) = compileScript ["core\fnc\log\fob\actions.sqf"];
    
    FUNC(log,place_create_camera) = compileScript ["core\fnc\log\services\place_create_camera.sqf"];
    FUNC(log,repair_wreck) = compileScript ["core\fnc\log\services\repair_wreck.sqf"];
    FUNC(log,copy) = compileScript ["core\fnc\log\services\copy.sqf"];
    FUNC(log,paste) = compileScript ["core\fnc\log\services\paste.sqf"];
    FUNC(log,refuelSource) = compileScript ["core\fnc\log\services\refuelSource.sqf"];
    FUNC(log,rearmSource) = compileScript ["core\fnc\log\services\rearmSource.sqf"];
    FUNC(log,restoreVehicle) = compileScript ["core\fnc\log\services\restoreVehicle.sqf"];

    FUNC(log,inventoryCopy) = compileScript ["core\fnc\log\inventory\inventoryCopy.sqf"];
    FUNC(log,inventoryPaste) = compileScript ["core\fnc\log\inventory\inventoryPaste.sqf"];
    FUNC(log,inventoryRestore) = compileScript ["core\fnc\log\inventory\inventoryRestore.sqf"];

    //JSON
    FUNC(db,fileviewer) = compileScript ["core\fnc\db\ui\fileviewer.sqf"];
    FUNC(db,fileviewer_r_client) = compileScript ["core\fnc\db\ui\fileviewer_r_client.sqf"];

    //REP
    FUNC(rep,treatment) = compileScript ["core\fnc\rep\treatment.sqf"];

    //RESPAWN
    FUNC(respawn,screen) = compileScript ["core\fnc\respawn\screen.sqf"];
    FUNC(respawn,force) = compileScript ["core\fnc\respawn\force.sqf"];
    FUNC(respawn,intro) = compileScript ["core\fnc\respawn\intro.sqf"];

    //SIDE
    FUNC(side,dialog) = compileScript ["core\fnc\side\dialog.sqf"];
    
    //SPECT
    FUNC(spect,updateDevice) = compileScript ["core\fnc\spect\updateDevice.sqf"];
    FUNC(spect,frequencies) = compileScript ["core\fnc\spect\frequencies.sqf"];
    FUNC(spect,disableDevice) = compileScript ["core\fnc\spect\disableDevice.sqf"];

    //TASK
    FUNC(task,setDescription) = compileScript ["core\fnc\task\setDescription.sqf"];
    FUNC(task,abort) = compileScript ["core\fnc\task\abort.sqf"];
    FUNC(task,showNotification) = compileScript ["core\fnc\task\showNotification.sqf"];

    //TOW
    FUNC(tow,ropeCreate) = compileScript ["core\fnc\tow\ropeCreate.sqf"];
    FUNC(tow,hitch_points) = compileScript ["core\fnc\tow\hitch_points.sqf"];
    FUNC(tow,unhook) = compileScript ["core\fnc\tow\unhook.sqf"];
    FUNC(tow,check) = compileScript ["core\fnc\tow\check.sqf"];

    //SLOT
    FUNC(slot,loadPlayer) = compileScript ["core\fnc\slot\loadPlayer.sqf"];

    //UI
    FUNC(ui,progressBars) = compileScript ["core\fnc\ui\progressBars.sqf"];
};

/////////////////////HEADLESS\\\\\\\\\\\\\\\\\\\\\
if (!hasInterface && !isDedicated) then {
    FUNC(eh,headless) = compileScript ["core\fnc\eh\headless.sqf"];
    FUNC(debug,show_fps) = compileScript["core\fnc\debug\show_fps.sqf"];
};
