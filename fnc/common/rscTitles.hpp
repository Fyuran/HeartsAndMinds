class btc_RscDynamicText : RscDynamicText {
    onload = "uiNamespace setVariable ['btc_dynamicText',_this select 0];";
    class controls : controls {
        class Text : Text {
            x = safezoneX;
            y = safezoneY;
            size = "(0.05 / 1.17647) * safezoneH";
            sizeEx = "(0.05 / 1.17647) * safezoneH";
        };
    };
};