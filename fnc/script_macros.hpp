//#include "..\script_macros.hpp"
#include "\x\cba\addons\main\script_macros_mission.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

//btc_fnc_showSubtitle
#define WAIT         10
#define POS_W        (0.4 * safeZoneW)
#define POS_H        (safeZoneH)
#define POS_X        (0.5 - POS_W / 2)
#define POS_Y        (safeZoneY + (6/8) * safeZoneH)
#define POS_Y_CAM    (safeZoneY + (31/32) * safeZoneH)

//reputation
#define _CIV_KILLED_ 101
#define _CIV_HURT_ 102
#define _CIV_SUPPRESSED_ 103
#define _ANIMAL_HURT_ 104
#define _ANIMAL_KILLED_ 105
#define _DOOR_FORCED_ 106
#define _PLAYER_RESPAWNED_ 107
#define _FOB_LOST_ 108
#define _BUILDING_DAMAGED_ 109
#define _BUILDING_DESTROYED_ 110
#define _FOOD_REMOVED_ 111
#define _VEHICLE_LOST_ 112
#define _FRIENDLY_KILLED_ 113
#define _CAPTIVE_KILLED_ 114
#define _FOB_DISMANTLED_ 115

#define _CACHE_DESTROYED_ 200
#define _HIDEOUT_DESTROYED_ 201
#define _IED_DEFUSED_ 202
#define _EXPLOSIVE_DEFUSED_ 203
#define _CAPTIVE_DETAINED_ 204
#define _FOOD_GIVEN_ 205
#define _CIV_HEALED_ 206
#define _HOSTILE_KILLED_ 207
#define _CIV_WHEEL_CHANGED_ 208
#define _TAG_LETTER_REMOVED_ 209
#define _TAG_REMOVED_ 210
#define _SUPPLIES_CLAIMED_ 211

#define _SIDE_OFFICER_CAPTURED_ 301
#define _SIDE_CHECKPOINT_DESTROYED_ 302
#define _SIDE_DECONTAMINATED_ 303
#define _SIDE_CIV_BOAT_TREATED_ 304
#define _SIDE_CIV_TREATED_ 305
#define _SIDE_CONVOY_AMBUSHED_ 306
#define _SIDE_EMP_DESTROYED_ 307
#define _SIDE_CITY_TAKEN_ 308
#define _SIDE_TERMINAL_HACKED_ 309
#define _SIDE_HOSTAGE_RESCUED_ 310
#define _SIDE_TARGET_KILLED_ 311
#define _SIDE_MINEFIELD_DEFUSED_ 312
#define _SIDE_CIV_DECONTAMINATED_ 313
#define _SIDE_RUBBISH_REMOVED_ 314
#define _SIDE_CIV_RESCUED_ 315
#define _SIDE_SUPPLIES_DELIVERED_ 316
#define _SIDE_TOWER_DESTROYED_ 317
#define _SIDE_UNDERWATER_GENERATOR_DESTROYED_ 318
#define _SIDE_VEHICLE_REPAIRED_ 319


//btc_event
#define _FOB_ATTACK_TASK_TYPE_ 42
#define _EVENT_COOLDOWN_ 600
#define _EVENT_FOB_ATTACK_ 0
#define _FOB_ATTACK_PATROL_TYPE_ 2
#define _FOB_MAX_GROUPS_ 5
#define _FOB_COOLDOWN_ 300
#define _FOB_SIGHT_RANGE_ 500

//btc_shortcuts
#define _BTC_PLAY_FBSOUND_ true    //set false if you do not want a "key-pressed-feedback" (sound)
#define _BTC_FBSOUND_ "ClickSoft"  //really quiet sound