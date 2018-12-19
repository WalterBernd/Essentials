
#include <sourcemod>

public Plugin myinfo = 
{
	name = "ShowPluginList",
	author = "Jonas Bernd",
	description = "Displays settings with jb_settings",
	version = SOURCEMOD_VERSION,
	url = "http://www.tributeofgamer.de/"
};

new String:stdName[] = "Plugins: ";
new String:currentmode[30] = "";

bool isFreeze = false;
new bool:sm_retakes = false;

//plugin start
public void OnPluginStart()
{
	PrintToChatAll("%sLoaded", stdName);
	//LoadTranslations("menu_test.phrases");
	RegAdminCmd("jb_settings", mainMenu, ADMFLAG_GENERIC, "Displays all Plugins");
	//RegAdminCmd("sm_showbannedplayers", ShowBannedPlayers, ADMFLAG_GENERIC, "Displays all bannedplayers");
	
	HookEvent("round_start", OnRoundStart, EventHookMode_PostNoCopy);
}

//plugin end
public void OnPluginEnd()
{
	PrintToChatAll("%sUnloaded", stdName);
}

//round start
public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	if(StrEqual(currentmode, "competitive")) {
		//PrintToChatAll("Currentmode: %s", currentmode);
	}
	else if(StrEqual(currentmode, "training")) {
		
		//PrintToChatAll("Currentmode: %s", currentmode);
	}
}

//freeze
public FreezePlayer(client)
{
    SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.0);
    SetEntityRenderColor(client, 255, 0, 170, 174);
}

public UnFreezePlayer(client)
{
    SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
    SetEntityRenderColor(client, 255, 255, 255, 255);
}
//freeze



//actions

public Action mainMenu(int client, int args) {
	initMainMenu(client);
}

public Action Menu_training(int client, int args) {
	initMenuTraining(client);
}

public Action Menu_training_grenades(int client, int args) {
	initMenuTrainingGrenades(client);
}

public Action Menu_training_bots(int client, int args) {
	initMenuTrainingBots(client);
}

/*public Action Menu_training_maps(int client, int args) {
	initMenuTrainingMaps(client);
}*/

public Action Menu_competetive(int client, int args) {
	initMenuCompetetive(client);
}

public Action Menu_deathmatch(int client, int args) {
	initMenuDeathmatch(client);
}

public Action Menu_Armsrace(int client, int args) {
	initMenuArmsrace(client);
}

public Action Menu_Casual(int client, int args) {
	initMenuCasual(client);
}

public Action Menu_Bannedusers(int client, int args) {
	initMenuBannedusers(client);
}

/*public Action Menu Maps (int client, int args) {
	initMenuMaps(client);
}*/

//actions end



//init menus
public void initMainMenu(int client)
{
	new Handle:menu = CreateMenu(MainMenu, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Menu");

	AddMenuItem(menu, "training", "Training"); //submenu
	AddMenuItem(menu, "competitive", "Competitive"); //submenu
	AddMenuItem(menu, "deathmatch", "Deathmatch"); //submenu
	AddMenuItem(menu, "armsrace", "Armsrace"); //submenu
	AddMenuItem(menu, "casual", "Casual"); //submenu
	AddMenuItem(menu, "bannedusers", "Bannedusers"); //submenu

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuTraining(int client)
{
	new Handle:menu = CreateMenu(MenuTraining, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Training");

	/*new String:sm_retakes[] = "sm_retakes_enabled ";
	new String:sm_retakesValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("sm_retakes_enabled")), sm_retakesValue, 100);
	StrCat(sm_retakes, 100, sm_retakesValue);*/
	
	new String:sv_cheats[] = "sv_cheats ";
	new String:sv_cheatsValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("sv_cheats")), sv_cheatsValue, 100);
	StrCat(sv_cheats, 100, sv_cheatsValue);
	
	new String:sv_autobunnyhop[] = "sv_autobunnyhopping ";
	new String:sv_autobunnyhopValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("sv_autobunnyhopping")), sv_autobunnyhopValue, 100);
	StrCat(sv_autobunnyhop, 100, sv_autobunnyhopValue);
	
	new String:mp_buyanywhere[] = "mp_buy_anywhere ";
	new String:mp_buyanywhereValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("mp_buy_anywhere")), mp_buyanywhereValue, 100);
	StrCat(mp_buyanywhere, 100, mp_buyanywhereValue);
	
	new String:sv_infinite_ammo[] = "sv_infinite_ammo ";
	new String:sv_infinite_ammoValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("sv_infinite_ammo")), sv_infinite_ammoValue, 100);
	StrCat(sv_infinite_ammo, 100, sv_infinite_ammoValue);
	
	new String:mp_damage_headshot_only[] = "mp_damage_headshot_only ";
	new String:mp_damage_headshot_onlyValue[] = "";
	
	IntToString(GetConVarInt(FindConVar("mp_damage_headshot_only")), mp_damage_headshot_onlyValue, 100);
	StrCat(mp_damage_headshot_only, 100, mp_damage_headshot_onlyValue);
	
	new String:freezeplayer[] = "Player ";
	
	if(isFreeze)
		StrCat(freezeplayer, 100, "unfreeze");
	else
		StrCat(freezeplayer, 100, "freeze");
		
	AddMenuItem(menu, "config", "Load Config"); //punkt
	AddMenuItem(menu, "retakes", "Retakes"); //menu
	AddMenuItem(menu, "grenades", "Grenades"); //submenu
	AddMenuItem(menu, "bots", "Bots"); //submenu
	AddMenuItem(menu, "cheats", sv_cheats); //punkt
	AddMenuItem(menu, "bunnyhop", sv_autobunnyhop); //punkt
	AddMenuItem(menu, "gods", "Gods"); //punkt
	AddMenuItem(menu, "buyeverywhere", mp_buyanywhere); //punkt
	AddMenuItem(menu, "ammo", sv_infinite_ammo); //punkt
	AddMenuItem(menu, "maps", "Maps"); //submenu
	AddMenuItem(menu, "headonly", mp_damage_headshot_only); //Punkt
	AddMenuItem(menu, "restart", "Restart game");//Punkt
	AddMenuItem(menu, "freeze", freezeplayer);//Punkt
	AddMenuItem(menu, "tacticals", "Tacticals"); //submenu

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuTrainingGrenades(int client)
{
	new Handle:menu = CreateMenu(MenuTrainingGrenades, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Training Grenades");

	AddMenuItem(menu, "numberofnades", "Number of Grenades");
	AddMenuItem(menu, "numberofflash", "Number of Flashbangs");
	AddMenuItem(menu, "g_Enabled ", "Enable Tails");
			

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuTrainingBots(int client)
{
	new Handle:menu = CreateMenu(MenuTrainingBots, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Training Bots");

	AddMenuItem(menu, "botsetct", "Bot set CT"); // submenu
	AddMenuItem(menu, "botsett", "Bot set T"); // submenu
	AddMenuItem(menu, "botdifficulty", "Bot difficulty"); //submenu
	AddMenuItem(menu, "botsstop", "Bots stop");
	AddMenuItem(menu, "botsgo", "Bots go");
	AddMenuItem(menu, "botsdontshoot", "Bots don't shoot");
	AddMenuItem(menu, "botsshoot", "Bots shoot");
	AddMenuItem(menu, "botsplace", "Bot place");
	AddMenuItem(menu, "botonlyknife", "Bots only Knife");
	AddMenuItem(menu, "botallweapon", "Bots have all Weapon");
	
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuCompetetive(int client)
{
	new Handle:menu = CreateMenu(MenuCompetetive, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Competetive");

	AddMenuItem(menu, "", "");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuDeathmatch(int client)
{
	new Handle:menu = CreateMenu(MenuDeathmatch, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Deathmatch");

	AddMenuItem(menu, "", "");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuArmsrace(int client)
{
	new Handle:menu = CreateMenu(MenuArmsrace, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Armsrace");

	AddMenuItem(menu, "", "");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuCasual(int client)
{
	new Handle:menu = CreateMenu(MenuCasual, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Casual");

	AddMenuItem(menu, "", "");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public void initMenuBannedusers(int client)
{
	new Handle:menu = CreateMenu(MenuBannedusers, MenuAction_Start | MenuAction_Display | MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Bannedusers");

	AddMenuItem(menu, "", "");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
//init menus end



//Menu Handler


/*--------------Main Menu--------------*/
public MainMenu(Handle:menu, MenuAction:action, param1, param2) {
	switch (action)
	{
		case MenuAction_Start: MainMenu_action_start(menu, action, param1, param2);
		case MenuAction_Display: MainMenu_action_display(menu, action, param1, param2);
		case MenuAction_Select: MainMenu_action_select(menu, action, param1, param2);
		case MenuAction_Cancel: MainMenu_action_cancel(menu, action, param1, param2);
		case MenuAction_End: MainMenu_action_end(menu, action, param1, param2);
		case MenuAction_DisplayItem: MainMenu_action_displayItem(menu, action, param1, param2);
	}
	return 0;
}

public MainMenu_action_start(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 and param2 unset*/
}

public MainMenu_action_display(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is panel handle*/
	
}

public MainMenu_action_select(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is item*/
	new String:item[64];
	GetMenuItem(menu, param2, item, sizeof(item));

	if (StrEqual(item, "training"))
	{
		currentmode = "training";
		initMenuTraining(param1);
	}
	else if(StrEqual(item, "competitive")) {
		currentmode = "competitive";
		ServerCommand("exec gamemode_competitive.cfg");
		ServerCommand("sm plugins unload NadeTails");
		ServerCommand("mp_showimpacts 0");
		PrintToChatAll("Competetive loaded!");
	}
	else if(StrEqual(item, "deathmatch")) {
		currentmode = "deathmatch";
		ServerCommand("exec gamemode_deathmatch.cfg");
		ServerCommand("sm plugins unload NadeTails");
		ServerCommand("mp_showimpacts 0");
		PrintToChatAll("Deathmatch loaded!");		
	}
	else if(StrEqual(item, "armsrace")) {
		currentmode = "armsrace";
		ServerCommand("exec gamemode_armsrace.cfg");
		ServerCommand("sm plugins unload NadeTails");
		ServerCommand("mp_showimpacts 0");
		PrintToChatAll("Armsrace loaded!");

	} 
	else if(StrEqual(item, "casual")) {
		currentmode = "casual";
		ServerCommand("exec gamemode_casual.cfg");
		ServerCommand("sm plugins unload NadeTails");
		ServerCommand("mp_showimpacts 0");
		PrintToChatAll("Casual loaded!");

	}
	else if(StrEqual(item, "bannedusers")) {
	

	}
}

public MainMenu_action_cancel(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is cancel reason (see MenuCancel types)*/
}

public MainMenu_action_end(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is MenuEnd reason, if canceled param2 is MenuCancel reason*/
	CloseHandle(menu);
}

public MainMenu_action_displayItem(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is item*/
	new String:item[64];
	GetMenuItem(menu, param2, item, sizeof(item));

	if (StrEqual(item, "training"))
	{
		initMenuTraining(param1);
		//new String:translation[128];
		//Format(translation, sizeof(translation), "%T", "training", param1);
		//return RedrawMenuItem(translation);
	}	
}

/*--------------Main Menu end--------------*/





/*--------------Training Menu--------------*/
public MenuTraining(Handle:menu, MenuAction:action, param1, param2) {
	
	switch (action)
	{
		case MenuAction_Start: MenuTraining_action_start(menu, action, param1, param2);
		case MenuAction_Display: MenuTraining_action_display(menu, action, param1, param2);
		case MenuAction_Select: MenuTraining_action_select(menu, action, param1, param2);
		case MenuAction_Cancel: MenuTraining_action_cancel(menu, action, param1, param2);
		case MenuAction_End: MenuTraining_action_end(menu, action, param1, param2);
		case MenuAction_DisplayItem: MenuTraining_action_displayItem(menu, action, param1, param2);
	}
	
	return 0;
}

public MenuTraining_action_start(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 and param2 unset*/
}

public MenuTraining_action_display(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is panel handle*/
	
}

public MenuTraining_action_select(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is item*/
	new String:item[64];
	GetMenuItem(menu, param2, item, sizeof(item));

	if(StrEqual(item, "retakes"))
	{
		if(sm_retakes == false) {
			ServerCommand("sm_retakes_enabled 1");
			PrintToChatAll("Retake loaded!");
			sm_retakes = true;
		}
		else {
			ServerCommand("sm_retakes_enabled 0");
			PrintToChatAll("Retake unloaded!");
			sm_retakes = false;
		}
		
	}
	else if (StrEqual(item, "config"))
	{
		ServerCommand("sm plugins load NadeTails");
		ServerCommand("exec Training.cfg");
		PrintToChatAll("Training loaded!");
	}
	else if (StrEqual(item, "grenades"))
	{
		
	}
	else if (StrEqual(item, "bots"))
	{
	
	}
	//sv_cheats
	else if (StrEqual(item, "cheats"))
	{
		if(GetConVarInt(FindConVar("sv_cheats")) == 1) 
		{
			ConVar con_var = FindConVar("sv_cheats");
			con_var.IntValue = 0;
		}
		else
		{
			ConVar con_var = FindConVar("sv_cheats");
			con_var.IntValue = 1;
		}
		
		initMenuTraining(param1);
	}
	//sv_autobunnyhopping
	else if (StrEqual(item, "bunnyhop"))
	{
		if(GetConVarInt(FindConVar("sv_autobunnyhopping")) == 1) 
		{
			ConVar con_var = FindConVar("sv_autobunnyhopping");
			con_var.IntValue = 0;
		}
		else
		{
			ConVar con_var = FindConVar("sv_autobunnyhopping");
			con_var.IntValue = 1;
		}
		initMenuTraining(param1);
	}
	//gods
	else if (StrEqual(item, "gods"))
	{
		
	}
	else if (StrEqual(item, "buyeverywhere"))
	{
		if(GetConVarInt(FindConVar("mp_buy_anywhere")) == 1) 
		{
			ConVar con_var = FindConVar("mp_buy_anywhere");
			con_var.IntValue = 0;
		}
		else
		{
			ConVar con_var = FindConVar("mp_buy_anywhere");
			con_var.IntValue = 1;
		}
		initMenuTraining(param1);
	}
	else if (StrEqual(item, "ammo"))
	{
		if(GetConVarInt(FindConVar("sv_infinite_ammo")) == 1) 
		{
			ConVar con_var = FindConVar("sv_infinite_ammo");
			con_var.IntValue = 2;
		}
		else if(GetConVarInt(FindConVar("sv_infinite_ammo")) == 2)
		{
			ConVar con_var = FindConVar("sv_infinite_ammo");
			con_var.IntValue = 0;
		}
		else
		{
			ConVar con_var = FindConVar("sv_infinite_ammo");
			con_var.IntValue = 1;
		}
		initMenuTraining(param1);
	}
	else if (StrEqual(item, "maps"))
	{
	
	}
	else if (StrEqual(item, "headonly"))
	{
		if(GetConVarInt(FindConVar("mp_damage_headshot_only")) == 1) 
		{
			ConVar con_var = FindConVar("mp_damage_headshot_only");
			con_var.IntValue = 0;
		}
		else
		{
			ConVar con_var = FindConVar("mp_damage_headshot_only");
			con_var.IntValue = 1;
		}
		initMenuTraining(param1);
	}
	else if (StrEqual(item, "restart"))
	{
		ConVar con_var = FindConVar("mp_restartgame");
		con_var.IntValue = 1;
		initMenuTraining(param1);
	}
	else if (StrEqual(item, "freeze"))
	{
		/*if(isFreeze) 
		{
			for(int i = 1; i < GetClientCount; i++)
			{
				UnFreezePlayer(i);
			}
		}
		else
		{
	
			new String:authstring[] = "";
		
			GetClientAuthString(param1, authstring, 150);
		
			for(int i = 1; i < GetClientCount; i++)
			{
				if(i != param1)
					FreezePlayer(i);
			}
			
		}*/
	}
	else if (StrEqual(item, "tacticals"))
	{
	
	}
}

public MenuTraining_action_cancel(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is cancel reason (see MenuCancel types)*/
}

public MenuTraining_action_end(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is MenuEnd reason, if canceled param2 is MenuCancel reason*/
	CloseHandle(menu);
}

public MenuTraining_action_displayItem(Handle:menu, MenuAction:action, param1, param2) {
	/*param1 is client, param2 is item*/
	new String:item[64];
	GetMenuItem(menu, param2, item, sizeof(item));

	if (StrEqual(item, "training"))
	{
	
	}
	
	
}

/*--------------Training Menu--------------*/




public MenuTrainingGrenades(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "g_Enabled"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}

public MenuCompetetive(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}

public MenuDeathmatch(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}

public MenuArmsrace(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}

public MenuCasual(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}

public MenuBannedusers(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset
		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}

		case MenuAction_DisplayItem:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "training"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "training", param1);
				return RedrawMenuItem(translation);
			}
		}

	}
	return 0;
}
public MenuTrainingBots(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Start:
		{
			//param1 and param2 unset

		}

		case MenuAction_Display:
		{
			//param1 is client, param2 is panel handle

			new String:title[255];
			Format(title, sizeof(title), "%T", "menutitle", param1)
			SetPanelTitle(Handle:param2, title);
		}

		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "botsetct")){

			}
			else if(StrEqual(item, "botsett")) {

			}
			else if(StrEqual(item, "botdifficulty")) {
				
			}
			else if(StrEqual(item, "botsstop")) {
				ServerCommand("bot_stop 1");
			} 
			else if(StrEqual(item, "botsgo")) {
				ServerCommand("bot_stop 0");
			} 
			else if(StrEqual(item, "botsdontshoot")) {
				ServerCommand("bot_dont_shoot 1");
			}
			else if(StrEqual(item, "botsshoot")) {
				ServerCommand("bot_dont_shoot 0");
			}
			else if(StrEqual(item, "botsplace")) {
				ServerCommand("bot_place");
			}
			else if(StrEqual(item, "botonlyknife")) {
				ServerCommand("bot_knives_only");
			}
			else if(StrEqual(item, "botallweapon")) {
				ServerCommand("bot_all_weapons");
			}
		}
		

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)

		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

		case MenuAction_DisplayItem:
		{	
			//param1 is client, param2 is item
			
			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "botsetct"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsetct", param1);
				return RedrawMenuItem(translation);
			} 
			else if (StrEqual(item, "botsett"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsett", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botdifficulty"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botdifficulty", param1);
				return RedrawMenuItem(translation);
			}		
			else if (StrEqual(item, "botsstop"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsstop", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botsgo"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsgo", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botsdontshoot"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsdontshoot", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botsshoot"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsshoot", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botsplace"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botsplace", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botonlyknife"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botonlyknife", param1);
				return RedrawMenuItem(translation);
			}
			else if (StrEqual(item, "botallweapon"))
			{
				new String:translation[128];
				Format(translation, sizeof(translation), "%T", "botallweapon", param1);
				return RedrawMenuItem(translation);
			}
		}

	}

	return 0;
}
//Menu Handler end


public Action OnBanClient(
					int client, 
					int time, 
					int flags, 
					const char[] reason, 
					const char[] kick_message, 
					const char[] command, 
					any source
					) 
{
	new String:auth[25] = "";
	GetClientAuthString(client, auth, 25);
	
	decl String:path[PLATFORM_MAX_PATH],String:line[128];
	BuildPath(Path_SM,path,PLATFORM_MAX_PATH,"bannedplayers.txt");
	
	new Handle:fileHandle=OpenFile(path,"w"); // Opens addons/sourcemod/bannedplayers.txt to read from (and only reading)
	
	WriteFileLine(fileHandle, auth);
	
	CloseHandle(fileHandle);
}

public Action ShowBannedPlayers(int client, int args) {
	
	
	decl String:path[PLATFORM_MAX_PATH],String:line[128];
	BuildPath(Path_SM,path,PLATFORM_MAX_PATH,"bannedplayers.txt");
	
	new String:list[sizeof(path)] = "";
	
	new Handle:fileHandle=OpenFile(path,"r"); // Opens addons/sourcemod/bannedplayers.txt to read from (and only reading)
	
	//FileSeek(fileHandle, 0);
	ReadFileString(fileHandle, list, sizeof(path), -1);
	/*while(!IsEndOfFile(fileHandle)&&ReadFileLine(fileHandle,line,sizeof(line)))
	{
		PrintToChat(client, " %s", line);
	}*/
	PrintToChat(client, "%s", list);
	CloseHandle(fileHandle);
}

