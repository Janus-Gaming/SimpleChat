
//////////
// VERB //
//////////

client/verb

	Input(T="" as text)
		if (account.IsJailed())
			return
		else
			var/l = length(T)
			if (l > 0)
				var/s = -1

				for (var/i = 1; i <= l; i++)
					var/a = copytext(T,i,i+1)
					var/b = null
					if (l > 1)
						b = copytext(T,i+1,i+2)

					if (a != " ")
						if (a == "/")
							if (b == "/")
								s = i+1
							else
								s = -1
						else
							s = i
						break

				if (s == -1)
					CMD(src,T)
				else if (s > 0)
					if (account.IsMuted())
						return
					else
						Action()
						Output(copytext(T,s,l+1))


	/////////////
	// GENERAL //
	/////////////

	Refresh()
		RefreshUserlist()
		Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used Refresh().")


	//////////////
	// PASTEBIN //
	//////////////

	Code_Show()
		if (account.IsJailed())
			return
		else
			winshow(src,"win_code",TRUE)
			Code_NewSnippet()

	Code_NewSnippet()
		if (account.IsJailed())
			return
		else
			Code_Clear()

	Code_Clear()
		if (account.IsJailed())
			return
		else
			winset(src,"win_code.input","text=\"\"")

	Code_Publish()
		if (account.IsJailed() || account.IsMuted())
			return
		else
			var/code/n = new
			var/d = winget(src,"win_code.input","text")
			if (d)
				n.SetRawText(d)
				n.SetCreator("[src.account.username]")
				Server_Announce("[src.account.username] has created a new <a href=?action=code;id=[n.id]>Code Snippet</a>")
				winshow(src,"win_code",FALSE)

	DestroyCodewindow(D as text)
		if (account.IsJailed())
			return
		else
			if (winexists(src,"win_code_[D]"))
				windel(src,"win_code_[D]")


	//////////
	// MENU //
	//////////

	Menu_Donate()
		src << link("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=VFNTUNMKEH6K6")
		Server_Debug("[_time.ExportTimeStamp(-5)]: [src] clicked the Donate menu selection.")

	Menu_Forums()
		src << link("http://www.byond.com/forum/makeii/simplechat")
		Server_Debug("[_time.ExportTimeStamp(-5)]: [src] clicked the Forum menu selection.")

	Menu_ShowReference()
		if (account.IsJailed())
			return
		else
			GenerateDocumentation()
			winshow(src,"win_reference",TRUE)
		Server_Debug("[_time.ExportTimeStamp(-5)]: [src] clicked the Reference menu selection.")

	Menu_AboutSC()
		winshow(src,"win_about",TRUE)


	//////////////
	// SETTINGS //
	//////////////

	Settings_SetPassword(T as text|null)
		if (T)
			T = html_encode(CropText(T,32))
		else
			T = GeneratePassword(8)
		account.password = T
		winset(src,"win_settings.input_password","text=\"[account.password]\"")

		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetPassword verb.")


	Settings_SetGMTOffset(N=0 as num)
		if (account.IsJailed())
			return
		else
			N = round(Clamp(N,-12,12))
			account.gmt_offset = N
			winset(src,"menu_settings.gmt_[N]","is-checked=true")
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the GMTOffset verb.")


	Settings_CustomizeTheme()
		if (account.IsJailed())
			return
		else
			var/d1 = input(src,null,"Select Skin Color") as color|null
			if (d1)
				account.custom_skin = d1
			else
				account.custom_skin	= "#770077"

			var/d2 = input(src,null,"Select BG Color") as color|null
			if (d2)
				account.custom_bg = d2
			else
				account.custom_bg = "#220022"

			UpdateCustomTheme()
			Settings_SetTheme(6)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the CustomizeTheme verb.")


	Settings_CustomizeNameColor()
		if (account.IsJailed())
			return
		else
			var/d1 = input(src,null,"Select Name Color") as color|null
			account.custom_namecolor = d1
			winset(src,"win_settings.button_name_-1_-1","background-color=[d1]")
			Settings_SetNameColor(-1,-1)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the CustomizeNameColor verb.")

	Settings_CustomizeFontStyle(T as text|null)
		if (account.IsJailed())
			return
		else
			if (!T)
				T = "Verdana"
			account.custom_fontstyle	= T
			UpdateCustomFont()
			Settings_SetFontStyle(8)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the CustomizeFontStyle verb.")




	Settings_Show(N=1 as num)
		if (account.IsJailed())
			return
		else
			winshow(src,"win_settings",N)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the ShowSettings verb.")

	Settings_SetNameColor(X as num,Y as num)
		if (account.IsJailed())
			return
		else
			var/d = winget(src,"win_settings.button_name_[X]_[Y]","background-color")
			name_color 	= d
			Server_RefreshUserlists()
			account.saved_color_x = X
			account.saved_color_y = Y
			winset(src,"win_settings.button_name_[X]_[Y]","is-checked=true")
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetNameColor verb.")


	Settings_SetTheme(N as num)
		if (account.IsJailed())
			return
		else
			var/d1 = winget(src,"win_settings.radio_theme_[N]","background-color")
			var/d2 = winget(src,"win_settings.radio_theme_[N]b","background-color")
			winset(src,"win_settings.radio_theme_[N]","is-checked=true")
			skin_color 	= d1
			bg_color	= d2
			UpdateSkinColor(skin_color)
			UpdateBGColor(bg_color)
			RefreshUserlist()
			UpdateTells()
			account.saved_theme = N
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetTheme verb.")

	Settings_SetFontStyle(N as num)
		if (account.IsJailed())
			return
		else
			var/d = winget(src,"win_settings.radio_font_[N]","font-family")
			winset(src,"win_settings.radio_font_[N]","is-checked=true")
			font_style = d
			UpdateFontStyle(font_style)
			UpdateTells()
			account.saved_fontstyle = N
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetFontStyle verb.")

	Settings_SetPaneOrientation(N=1 as num)
		if (account.IsJailed())
			return
		else
			if (N == 1)
				winset(src,"win_main.child","left=pane_who")
				winset(src,"win_main.child","right=pane_chat")
				winset(src,"win_main.child","splitter=28")
				winset(src,"win_settings.radio_userlist_left","is-checked=true")
				account.who_orientation = USERLIST_LEFT
			else if (N == 2)
				winset(src,"win_main.child","left=pane_chat")
				winset(src,"win_main.child","right=pane_who")
				winset(src,"win_main.child","splitter=72")
				winset(src,"win_settings.radio_userlist_right","is-checked=true")
				account.who_orientation = USERLIST_RIGHT
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetPaneOrientation verb.")

	Settings_FlagRPGOutput(N as num|null)
		if (account.IsJailed())
			return
		else
			if (N != null)
				if (N == 1)
					account.flag_rpgoutput = TRUE
					winset(src,"win_settings.check_rpgoutput","is-checked=true")
				else if (N == 0)
					account.flag_rpgoutput = FALSE
					winset(src,"win_settings.check_rpgoutput","is-checked=false")
			else
				var/d = winget(src,"win_settings.check_rpgoutput","is-checked")
				if (d == "true")
					account.flag_rpgoutput = TRUE
				else
					account.flag_rpgoutput = FALSE
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetRPGOutput verb.")

	Settings_FlagUIFlashing(N as num|null)
		if (account.IsJailed())
			return
		else
			if (N != null)
				if (N == 1)
					account.flag_uiflashing = TRUE
					winset(src,"win_settings.check_uiflashing","is-checked=true")
				else if (N == 0)
					account.flag_uiflashing = FALSE
					winset(src,"win_settings.check_uiflashing","is-checked=true")
			else
				var/d = winget(src,"win_settings.check_uiflashing","is-checked")
				if (d == "true")
					account.flag_uiflashing = TRUE
				else
					account.flag_uiflashing = FALSE
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the SetUIFlashing verb.")



	///////////////
	// DEBUGGING //
	///////////////

	ShowDebugWindow()
		if (account.IsJailed())
			return
		else
			if (account.rank.value >= RANK_OP)
				winshow(src,"win_debug",TRUE)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the OpenDebugWindow verb.")

	Debug_Note(T as text)
		Server_Debug("<font color=#666666>[src.account.username]: [T]</font>")

	////////////////////
	// PALETTE HELPER //
	////////////////////

	ShowPaletteHelper()
		if (account.IsJailed())
			return
		else
			winshow(src,"win_palettehelper",TRUE)
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the OpenPaletteHelper verb.")

	UpdatePaletteHelper()
		if (account.IsJailed())
			return
		else
			var/r = text2num(winget(src,"win_palettehelper.bar_r","value"))/100 * 255
			var/g = text2num(winget(src,"win_palettehelper.bar_g","value"))/100 * 255
			var/b = text2num(winget(src,"win_palettehelper.bar_b","value"))/100 * 255
			var/x = rgb(r,g,b)
			winset(src,"win_palettehelper.label_result","background-color=\"[x]\"")
			winset(src,"win_palettehelper.input_result","text=\"[x]\"")
		if (flag_settingslogin)
			Server_Debug("[_time.ExportTimeStamp(-5)]: [src] used the UpdatePaletteHelper verb.")




