class btc_fob_create {
    idd = -1;
    movingEnable = 1;
    onLoad = "uiNamespace setVariable [""btc_fob_create"", _this select 0];";
    objects[] = {};
    class controlsBackground {

    };
    class controls {
        class btc_fob_dlg_background : btc_dlg_RscText {
            idc = -1;
            x = 0.35 * safezoneW + safezoneX;
            y = 0.4 * safezoneH + safezoneY;
            w = 0.3 * safezoneW;
            h = 0.125 * safezoneH;
            colorBackground[] = {0, 0, 0, 0.65};
            text = "";
        };
        class btc_fob_dlg_text : btc_dlg_RscText {
            idc = -1;
            colorBackground[] = {"(profilenamespace getvariable ['GUI_BCG_RGB_R', 0.3843])", "(profilenamespace getvariable ['GUI_BCG_RGB_G', 0.7019])", "(profilenamespace getvariable ['GUI_BCG_RGB_B', 0.8862])", "(profilenamespace getvariable ['GUI_BCG_RGB_A', 0.7])"};
            x = 0.35 * safezoneW + safezoneX;
            y = 0.4 * safezoneH + safezoneY;
            w = 0.3 * safezoneW;
            h = 0.025 * safezoneH;
            colorText[] = {1, 1, 1, 1};
            text = $STR_BTC_HAM_O_FOB_DLG_T_NAMEFOB; //Name the FOB:
        };
        class btc_fob_dlg_name : btc_dlg_RscEdit {
            idc = 777;
            text = "";
            x = 0.35025 * safezoneW + safezoneX;
            y = 0.45 * safezoneH + safezoneY;
            w = 0.3 * safezoneW;
            h = 0.025 * safezoneH;
        };
        class btc_fob_dlg_apply : btc_dlg_button {
            text = $STR_ui_debug_but_apply; //Apply
            action = "btc_fob_dlg = true;";
            x = 0.45 * safezoneW + safezoneX;
            y = 0.5 * safezoneH + safezoneY;
            w = 0.1 * safezoneW;
            default = true;
        };
    };
};

import RscPicture;
class btc_UI_RscProgress: RscProgress
{
    x = 0.903625 * safezoneW + safezoneX;
    y = 0.236 * safezoneH + safezoneY;
    w = 0.088 * safezoneW;
    h = 0.015 * safezoneH;
    colorBar[] =
    {
        "(profilenamespace getvariable ['Map_BLUFOR_R',0])",
        "(profilenamespace getvariable ['Map_BLUFOR_G',1])",
        "(profilenamespace getvariable ['Map_BLUFOR_B',1])",
        "(profilenamespace getvariable ['GUI_BCG_RGB_A',0.8])"
    };
};
class btc_UI_RscProgressIcon: RscPicture
{
    text = "a3\ui_f\data\Map\Markers\Flags\nato_ca.paa";
    x = 0.891875 * safezoneW + safezoneX;
    y = 0.236 * safezoneH + safezoneY;
    w = 0.0103125 * safezoneW;
    h = 0.015 * safezoneH;
};
class btc_UI_RscProgressText: RscText
{
    text = "FOB %1"; //--- ToDo: Localize;
    x = 0.903625 * safezoneW + safezoneX;
    y = 0.236 * safezoneH + safezoneY;
    w = 0.088 * safezoneW;
    h = 0.015 * safezoneH;
    sizeEx = 0.015 * safezoneH;
};