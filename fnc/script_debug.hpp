//#define BTC_DEBUG_FULL

#ifdef BTC_DEBUG_FULL
    #define BTC_DEBUG_ARSENAL
    #define BTC_DEBUG_CACHE
    #define BTC_DEBUG_CHEM
    #define BTC_DEBUG_CITY
    #define BTC_DEBUG_CIV
    #define BTC_DEBUG_COMMON
    #define BTC_DEBUG_DATA
    #define BTC_DEBUG_DB
    #define BTC_DEBUG_DEBUG
    #define BTC_DEBUG_EH
    #define BTC_DEBUG_EVENT
    #define BTC_DEBUG_EXT_IED
    #define BTC_DEBUG_FOB
    #define BTC_DEBUG_GARRISON
    #define BTC_DEBUG_HIDEOUT
    #define BTC_DEBUG_IED
    #define BTC_DEBUG_INFO
    #define BTC_DEBUG_JAIL
    #define BTC_DEBUG_JSON
    #define BTC_DEBUG_LIFT
    #define BTC_DEBUG_LOG
    #define BTC_DEBUG_MIL
    #define BTC_DEBUG_PATROL
    #define BTC_DEBUG_REP
    #define BTC_DEBUG_RESPAWN
    #define BTC_DEBUG_SIDE
    #define BTC_DEBUG_TASK
    #define BTC_DEBUG_SLOT
    #define BTC_DEBUG_TAG
    #define BTC_DEBUG_UI
    #define BTC_DEBUG_VEH
#endif

#ifndef BTC_DEBUG_FULL
    #ifdef BTC_DEBUG
        #define BTC_DEBUG_CITY
        #define BTC_DEBUG_IED
        #define BTC_DEBUG_JSON
        #define BTC_DEBUG_SIDE
        #define BTC_DEBUG_DEBUG
        #define BTC_DEBUG_FOB
    #endif
#endif