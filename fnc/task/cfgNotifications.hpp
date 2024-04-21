import Default from CfgNotifications;
class CfgNotifications {
    class WarningDescription : Default {
        colorIconPicture[] = {"(profilenamespace getvariable ['IGUI_WARNING_RGB_R',0.8])","(profilenamespace getvariable ['IGUI_WARNING_RGB_G',0.5])","(profilenamespace getvariable ['IGUI_WARNING_RGB_B',0.0])",1};
        colorIconText[] = {"(profilenamespace getvariable ['IGUI_WARNING_RGB_R',0.8])","(profilenamespace getvariable ['IGUI_WARNING_RGB_G',0.5])","(profilenamespace getvariable ['IGUI_WARNING_RGB_B',0.0])",1};
        color[] = {"(profilenamespace getvariable ['IGUI_WARNING_RGB_R',0.8])","(profilenamespace getvariable ['IGUI_WARNING_RGB_G',0.5])","(profilenamespace getvariable ['IGUI_WARNING_RGB_B',0.0])",1};
        iconPicture = "\a3\Ui_f\data\Map\Markers\Military\warning_ca.paa";
        description = "%2";
        title = "Warning";
    };
    class WarningDescriptionAudio : WarningDescription {
        sound = "Alarm";
    };
    class WarningDescriptionUnderattack : WarningDescription {
        sound = "btc_underattack";
    };
    class WarningDescriptionDefeated : WarningDescription {
        color[] = {1,0,0,1};
        colorIconPicture[] = {1,0,0,1};
        colorIconText[] = {1,0,0,1};
        iconPicture = "core\img\skull.paa";
        duration = 5;
        priority = 5;
        title = "Asset Lost";
        sound = "btc_defeated";
    };
    class WarningDescriptionRepaired : WarningDescription {
        color[] = {0,1,0,1};
        colorIconPicture[] = {0,1,0,1};
        colorIconText[] = {0,1,0,1};
        iconPicture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\repair_ca.paa";
        title = "Asset regained";
        sound = "btc_barracks";
    };
    class FOBlowRepWarningDescriptionAudio : WarningDescription {
        iconPicture = "\a3\Ui_f\data\Map\Markers\Military\unknown_CA.paa";
        sound = "wind5";
        duration = 5;
        priority = 5;
        title = "Bad Weather";
    };
};