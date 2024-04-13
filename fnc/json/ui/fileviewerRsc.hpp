/* #Harypu
$[
	1.063,
	["Rsc_btcJSON",[["(safeZoneX + (safeZoneW - ((safeZoneW / safeZoneH) min 1.2)) / 2)","(safeZoneY + (safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2)) / 2)","((safeZoneW / safeZoneH) min 1.2)","(((safeZoneW / safeZoneH) min 1.2) / 1.2)"],"(((safeZoneW / safeZoneH) min 1.2) / 40)","((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)","GUI_GRID_CENTER"],0,0,0],
	[1000,"RscText_1000",[2,"JSON File Viewer",["3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","-1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","33.5 * GUI_GRID_CENTER_W","1 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],["(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])","(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])","(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",0.5],[-1,-1,-1,-1],"","-1"],["style = 2;","font = |PuristaMedium|;"]],
	[1001,"RscJSONListbox: RscListBox",[2,"",["3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","0 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","33.5 * GUI_GRID_CENTER_W","24 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.7],[-1,-1,-1,-1],"","0.8 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"],["idc = 1500;","font = |PuristaLight|;"]],
	[1400,"RscEdit_1400",[2,"",["3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","24 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","33.5 * GUI_GRID_CENTER_W","1 * GUI_GRID_CENTER_H"],[1,1,1,1],[0,0,0,1],[1,1,1,1],"","1 * 					(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"],["idc = 1400;"]],
	[1600,"RscButton_1600: RscJSONButton",[2,"Delete",["9.22 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 1600;"]],
	[1601,"RscButton_1601: RscJSONButton",[2,"Copy",["15.44 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 1601;"]],
	[1602,"RscButton_1602: RscJSONButton",[2,"Save",["3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 1602;"]],
	[1603,"RscButton_1603: RscJSONButton",[2,"Rename",["12.32 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 1603;"]],
	[1604,"RscButton_1604: RscJSONButton",[2,"Load",["6.1 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 1604;"]],
	[1605,"RscButton_2: RscJSONButton",[2,"Exit",["33.5 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X","25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y","3 * GUI_GRID_CENTER_W","1.5 * GUI_GRID_CENTER_H"],[-1,-1,-1,-1],[0,0,0,0.8],[-1,-1,-1,-1],"","-1"],["idc = 2;"]]
]
*/

class RscJSONButton : RscButton {
	colorText[] = GUI_TEXT_COLOR;
	colorBackground[] = {GUI_BCG_MENU_RGB, 0.8};
	font = "PuristaLight";
	sizeEx = 0.8 * GUI_GRID_CENTER_H;
};

class Rsc_btcJSON
{
	idd = 7001;
	class ControlsBackground
	{
		class RscText_1000: RscText
		{
			idc = -1;
			style = ST_CENTER;
			font = "PuristaMedium";
			text = "JSON File Viewer"; 
			x = 3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = -1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 33.5 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
			colorBackground[] = GUI_BCG_COLOR_SELECTED;
			colorText[] = GUI_TEXT_COLOR;
		};
	};

	class Controls
	{
		class RscJSONListbox : RscListbox
		{
			idc = 1500;
			x = 3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 0 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 33.5 * GUI_GRID_CENTER_W;
			h = 24 * GUI_GRID_CENTER_H;
			colorText[] = GUI_TEXT_COLOR;
			colorBackground[] = GUI_BCG_MENU;
			sizeEx = 0.8 * GUI_GRID_CENTER_H;
			font = "PuristaLight";
			style = LB_TEXTURES;
			class ListScrollBar: ScrollBar
			{
				color[] = {1,1,1,1};
				autoScrollEnabled = 1;
			};
		};
		class RscEdit_1400: RscEdit
		{
			idc = 1400;
			x = 3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 24 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 33.5 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
			colorText[] = GUI_TEXT_COLOR;
			colorBackground[] = {0,0,0,1};
			sizeEx = 0.8 * GUI_GRID_CENTER_H;
		};
		class RscButton_1600: RscJSONButton
		{
			idc = 1600;
			text = "Delete"; 
			x = 9.22 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};
		class RscButton_1601: RscJSONButton
		{
			idc = 1601;
			text = "Copy"; 
			x = 15.44 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};
		class RscButton_1602: RscJSONButton
		{
			idc = 1602;
			text = "Save"; 
			x = 3 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};		
		class RscButton_1603: RscJSONButton
		{
			idc = 1603;
			text = "Rename"; 
			x = 12.32 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};	
		class RscButton_1604: RscJSONButton
		{
			idc = 1604;
			text = "Load"; 
			x = 6.1 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};	
		class RscButton_2: RscJSONButton
		{
			idc = IDC_CANCEL;
			text = "Exit"; 
			x = 33.5 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X;
			y = 25.1 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y;
			w = 3 * GUI_GRID_CENTER_W;
			h = 1.5 * GUI_GRID_CENTER_H;
		};
	};
};