/* #Taxefy
$[
	1.063,
	["gm",[[0,0,1,1],0.025,0.04,"GUI_GRID"],0,0,0],
	[1200,"RscPicture_1200",[1,"core\img\side_tablet.paa",["0.237031 * safezoneW + safezoneX","0.236 * safezoneH + safezoneY","0.546562 * safezoneW","0.539 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"RscListbox_1500: RscListBox",[1,"",["0.345312 * safezoneW + safezoneX","0.357 * safezoneH + safezoneY","0.134062 * safezoneW","0.33 * safezoneH"],[-1,-1,-1,-1],[0.05,0.29,0.5,1],[-1,-1,-1,-1],"","-1"],["idc = 1500;","soundSelect[] = {||,1,1};"]],
	[1001,"RscText_1000: RscTextMulti",[1,"Side Description",["0.478344 * safezoneW + safezoneX","0.357 * safezoneH + safezoneY","0.170156 * safezoneW","0.253 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[-1,-1,-1,-1],"","-1"],["idc = 1000;"]],
	[1600,"",[1,"Create",["0.489687 * safezoneW + safezoneX","0.621 * safezoneH + safezoneY","0.144375 * safezoneW","0.044 * safezoneH"],[1,1,1,1],[0.023,0.572,0.243,1],[-1,-1,-1,-1],"","1.5"],[]],
	[1002,"",[1,"SIDE MISSIONS MENU",["0.350469 * safezoneW + safezoneX","0.313 * safezoneH + safezoneY","0.299062 * safezoneW","0.044 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[-1,-1,-1,-1],"","-1"],[]],
	[1003,"",[1,"",["0.479375 * safezoneW + safezoneX","0.61 * safezoneH + safezoneY","0.170156 * safezoneW","0.077 * safezoneH"],[-1,-1,-1,-1],[0.76,0.745,0.713,1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

class btc_gm_sidesmenu {
	idd = -1;
	movingEnable = 0;
	onLoad = "uiNamespace setVariable [""btc_gm_sidesmenu"", _this select 0]; playSound ""button_release"";";
	onUnload = "playSound ""button_cancel""";
	objects[] = {};
	class controls {
		class RscListbox_1500: RscListbox {
			idc = 1500;
			x = 0.345312 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.134062 * safezoneW;
			h = 0.33 * safezoneH;
			colorBackground[] = {0.05, 0.29, 0.50, 1}; //rgb(15, 76, 129)
			soundSelect[] = {"", 1, 1};
		};
		class RscText_1000: RscTextMulti {
			idc = 1000;
			text = "";
			x = 0.478344 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.253 * safezoneH;
			colorBackground[] = {0, 0, 0, 1}; //rgb(0, 0, 0)
		};
		class RscButton_1600: RscButton {
			idc = 1600;
			text = "CREATE";
			x = 0.4922655 * safezoneW + safezoneX;
			y = 0.6265 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {1,1,1,1};
			soundClick[] = {"", 1, 1};
			onLoad = "(_this select 0) ctrlEnable false;"
			colorBackground[] = {0.023,0.572,0.243,1};
			sizeEx = 1.5 * GUI_GRID_H;
		};
	};
	class controlsBackground {
		class RscPicture_1200: RscPicture {
			idc = 5000;
			text = "core\img\side_tablet.paa";
			x = 0.237031 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.546562 * safezoneW;
			h = 0.539 * safezoneH;
		};
		class RscText_1002: RscText {
			idc = -1;
			text = "SIDE MISSIONS MENU"; //--- ToDo: Localize;
			x = 0.345312 * safezoneW + safezoneX; //x = 0.345312 * safezoneW + safezoneX;
			y = 0.313 * safezoneH + safezoneY;
			w = 0.304218 * safezoneW;
			h = 0.044 * safezoneH;
			colorBackground[] = {0,0,0,1};
			colorBorder[] = {1,1,1,1};
			style = ST_CENTER; //ST_CENTER
		};
		class RscText_1003: RscText {
			idc = -1;
			x = 0.479375 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.077 * safezoneH;
			colorBackground[] = {0.76,0.745,0.713,1};
		};
	};
};
