class btc_log_dlg_create {
    idd = -1;
    movingEnable = 1;
    onUnload = "deleteVehicle(btc_log_dialog_namespace getVariable ['btc_log_curSel_obj', objNull]);";
    objects[] = {};
    class controlsBackground {};
    class controls {
        class btc_log_dlg_Apply : btc_dlg_button {
            idc = -1;
            text = $STR_ui_debug_but_apply; //Apply
            action = "call btc_log_dialog_fnc_apply";
            x = 0 * safezoneW + safezoneX;
            y = 0.25 * safezoneH + safezoneY;
            default = true;
        };
        class btc_log_dlg_Close : btc_dlg_button {
            idc = -1;
            text = $STR_ACE_Arsenal_buttonCloseText; //Close
            action = "closeDialog 0;";
            x = 0.2 * safezoneW + safezoneX;
            y = 0.25 * safezoneH + safezoneY;
            default = true;
        };
        class btc_log_dlg_main_class : btc_dlg_comboBox {
            idc = 71;
            onLBSelChanged = "_this spawn btc_log_dialog_fnc_mainClass_LBSelChanged";
            x = 0 * safezoneW + safezoneX;
            y = 0 * safezoneH + safezoneY;
            w = 0.4 * safezoneW;
            h = 0.055 * safezoneH;
        };
        class btc_log_dlg_sub_class : btc_dlg_comboBox {
            idc = 72;
            onLBSelChanged = "call btc_log_dialog_fnc_subClass_LBSelChanged";
            x = 0 * safezoneW + safezoneX;
            y = 0.1 * safezoneH + safezoneY;
            w = 0.4 * safezoneW;
            h = 0.055 * safezoneH;
        };
    };
};
