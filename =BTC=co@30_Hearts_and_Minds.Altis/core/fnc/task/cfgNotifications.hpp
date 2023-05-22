class CfgNotifications {
    class Default {
        color[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
        colorIconPicture[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
        colorIconText[] = {"(profilenamespace getvariable ['IGUI_TEXT_RGB_R',0])","(profilenamespace getvariable ['IGUI_TEXT_RGB_G',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_B',1])","(profilenamespace getvariable ['IGUI_TEXT_RGB_A',0.8])"};
        description = "";
        difficulty[] = {};
        duration = 3;
        iconPicture = "";
        iconText = "";
        priority = 0;
        sound = "defaultNotification";
        soundClose = "defaultNotificationClose";
        soundRadio = "";
        title = "";
    };
    class WarningDescription {
        color[] = {"(profilenamespace getvariable ['IGUI_WARNING_RGB_R',0.8])","(profilenamespace getvariable ['IGUI_WARNING_RGB_G',0.5])","(profilenamespace getvariable ['IGUI_WARNING_RGB_B',0.0])",1};
        iconPicture = "\a3\Ui_f\data\Map\Markers\Military\warning_ca.paa";
        sound = "Alarm";
        description = "%2";
        title = "Warning";
    };
    class Warning2Description {
        color[] = {"(profilenamespace getvariable ['IGUI_WARNING_RGB_R',0.8])","(profilenamespace getvariable ['IGUI_WARNING_RGB_G',0.5])","(profilenamespace getvariable ['IGUI_WARNING_RGB_B',0.0])",1};
        iconPicture = "\a3\Ui_f\data\Map\Markers\Military\warning_ca.paa";
        description = "%2";
        title = "Warning";
    };
};