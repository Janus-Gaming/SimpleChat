#define and &&
#define or ||


///////////
// PROCS //
///////////

client/proc


	CacheImages()
		src << browse_rsc('0_0.png')
		src << browse_rsc('0_1.png')
		src << browse_rsc('0_2.png')
		src << browse_rsc('1_0.png')
		src << browse_rsc('1_1.png')
		src << browse_rsc('1_2.png')
		src << browse_rsc('2_0.png')
		src << browse_rsc('2_1.png')
		src << browse_rsc('2_2.png')
		src << browse_rsc('jailed.png')
		src << browse_rsc('mute.png')
		src << browse_rsc('telnet.png')

	Debug(T)
		if (!IsTelnet(src))
			src << output(T,"win_debug.output")

	DisplayCode(D)
		for (var/code/d in _codes)
			if (d.id == D)
				if (!winexists(src,"win_code_[D]"))
					winclone(src,"win_code_null","win_code_[D]")
					winset(src,"win_code_[D]","title=\"[d.creator]'s Code Snippet\"")
					winset(src,"win_code_[D]","on-close=\"DestroyCodeWindow \\\"[D]\\\"\"")
					src << output(d.html_text, "win_code_[D].browser")
					winshow(src,"win_code_[D]",TRUE)



	SwitchAccount(account/a)
		if (IsTelnet(src) or IsGuest(src))
			var/account/b = account
			SetAccount(a)
			del b

			if (conn_type == CONN_SEEKER)
				UpdateCustomTheme()
				UpdateCustomName()
				UpdateCustomFont()
				Settings_SetGMTOffset(account.gmt_offset)
				Settings_SetTheme(account.saved_theme)
				Settings_SetFontStyle(account.saved_fontstyle)
				Settings_SetPaneOrientation(account.who_orientation)
				Settings_SetPassword(account.password)






	DestroyTells()
		for (var/tell/t in tells)
			for (var/client/c in t.clients)
				winshow(c,"win_tell_[t.id]",FALSE)
				windel(c,"win_tell_[t.id]")
			del t

	SendTell(client/c, T)
		if (c)
			for (var/tell/t in tells)
				if (c in t.clients)
					t.Output(src,T)
					return

			CreateTell(src,c)
			.()



	GenerateDocumentation()
		var/i 		= 0
		var/t		= \
{"<html>
	<head>
		<style type="text/css">
			#d1 {background-color: [skin_color];}
			#d2 {background-color: [bg_color];}
			td  {font-family: [font_style]; color:#FFFFFF;}
			table {border-color: #000000;}
		</style>
	</head>
	<body bgcolor=\"#000000\">
		<table border=\"0\" width=\"100%\" cellspacing=\"6\">"}

		for (var/command/c in _commands)
			if (CanUseCommand(c))
				i = (i+1)%2
				var/d  	= ""
				if (i)
					d = "d1"
				else
					d = "d2"
				t += \
{"			<tr><td id=\"[d]\">
				<font size=\"+1\"><b>[c.name]</b></font><br>
				<b>[ListToText(c.ids)]</b><br>
				<b><u>Format</u>:</b> [c.format]<br>
				<b><u>Use</u>:</b> [c.desc]<br>
			</td></tr>"}
		t += \
{"		</table>
	</body>
</html>"}
		src << browse(t)



	IsMuted()
		for (var/penalty/p in account.penalties)
			if (p.penalty_type == PENALTY_MUTE)
				return TRUE
		return FALSE

	IsBanned()
		for (var/penalty/p in account.penalties)
			if (p.penalty_type == PENALTY_BAN)
				return TRUE
		return FALSE


	IsBYOND()
		if ((conn_type == CONN_SEEKER) && (!findtext(ckey,"guest")))
			return TRUE
		else
			return FALSE


	SetAFKMessage(T)
		afk_message = T


	CanUseCommand(command/c)
		if (account.rank.value >= c.req)
			return TRUE
		else
			return FALSE

	SetAccount(account/A)
		account			= A
		if (A.client != null)
			Server_Notify(A.client,"Another client has logged in under your account. You are being disconnected.")
			del A.client
		A.SetClient(src)

	RemoveAccount()
		if (account)
			account.client = null
		src.account = null


	SetMob()
		mob = new


		// This function serves to indicate that the client has
		// made an action and will knock the client out of AFK
		// or idle.
	Action()
		if (status == STATUS_AVAIL)
			status_timer.ResetTime()
		if (status != STATUS_AVAIL)
			var/d = idle_timer.GetTime()
			SetStatus(STATUS_AVAIL,d)
			idle_timer.Stop()
			idle_timer.ResetTime()
			status_timer.Run()
			status_timer.ResetTime()

	SetStatus(S,N=0,T)
		S	= Clamp(S,0,2)

		if (S == STATUS_AVAIL)
			status = S
			Server_Announce("[account.username] is back after [TicksToTime(N)].")

		else if (S == STATUS_IDLE)
			status = S
			Server_Announce("[account.username] has gone idle.")

		else if (S == STATUS_AFK)
			if (status == STATUS_AFK)
				SetStatus(STATUS_AVAIL,N)
			else
				status = S
				if (T)
					T = html_encode(T)
					Server_Announce("[account.username] has gone AFK. ([T])")
					SetAFKMessage(T)
				else
					Server_Announce("[account.username] has gone AFK.")
				idle_timer.ResetTime()
				idle_timer.Run()

		Server_RefreshUserlists()

	RefreshUserlist()
		if (!IsTelnet(src))
			var/d = \
{"<html>
	<body bgcolor=\"[bg_color]\" style=\"margin:2px; overflow:auto\">"}
			for (var/client/c in _sortedclients)
				var/dd = "[c.account.level]"
				if (c.account.level == MAX_LEVEL)
					dd = "**"
				d += \
{"		<b><img src=\"[c.status]_[c.account.rank.value].png\"></img> <font style="font-weight:bold; font-size:10px; font-family:Courier New; color:#FFFFFF">[PadString(dd,2,"<font color=#777777>0</font>")]</font> [HTMLTelnet(c)] <a href=\"?action=tell;id=[c.ckey];\" style="text-decoration:none; color:[c.name_color]; font-size:12px; font-family:[font_style]">[c.account.username]</a><b> [HTMLMute(c.account)][HTMLJailed(c.account)]<br>"}
			src << output(d,"pane_who.browser")


	FlashClient()
		if (account.flag_uiflashing)
			var/d = winget(src,"win_main","focus")
			if (d == "false")
				winset(src,"win_main","flash=\"-1\"")

	RefreshClock()
		var/d = _time.ExportTimeStamp(account.gmt_offset)
		winset(src,"win_main.label_clock","text=\"[d]\"")

	RefreshClientAmt()
		winset(src,"pane_who.label_users","text=\"[_clients_amt] client\s\"")

	UpdateCustomTheme()
		winset(src,"win_settings.radio_theme_6",		"background-color=[account.custom_skin]")
		winset(src,"win_settings.radio_theme_6a",		"background-color=[account.custom_bg]")
		winset(src,"win_settings.radio_theme_6b",		"background-color=[account.custom_bg]")

	UpdateCustomName()
		winset(src,"win_settings.button_name_-1_-1",	"background-color=[account.custom_namecolor]")

	UpdateCustomFont()
		winset(src,"win_settings.input_customfont",		"text=\"[account.custom_fontstyle]\"")
		winset(src,"win_settings.input_customfont",		"font-family=\"[account.custom_fontstyle]\"")
		winset(src,"win_settings.radio_font_8",			"font-family=\"[account.custom_fontstyle]\"")



	UpdateTells()
		for (var/tell/t in tells)
			winset(src,"win_tell_[t.id].input",		"font-family=\"[font_style]\"")
			winset(src,"win_tell_[t.id].input",		"background-color=[bg_color]")
			winset(src,"win_tell_[t.id].output",	"font-family=\"[font_style]\"")
			winset(src,"win_tell_[t.id].output",	"background-color=[bg_color]")
			winset(src,"win_tell_[t.id]",			"background-color=[skin_color]")



	UpdateFontStyle(d)
			// main wnidow
		winset(src,"win_main.output_motd",				"font-family=\"[d]\"")
		winset(src,"win_main.input",					"font-family=\"[d]\"")
		winset(src,"win_main.label_channelname",		"font-family=\"[d]\"")
			// chat pane
		winset(src,"pane_chat.output",					"font-family=\"[d]\"")
			// who pane
		winset(src,"pane_who.browser",						"font-family=\"[d]\"")
		winset(src,"pane_who.label_users",				"font-family=\"[d]\"")
		UpdateMOTD()
		UpdateChannelName()
		RefreshUserlist()


	UpdateSkinColor(d)
			// main wnidow
		winset(src,"win_main",							"background-color=[d]")
		winset(src,"win_main.child",					"background-color=[d]")
			// who pane
		winset(src,"pane_who.label_users",				"background-color=[d]")
			// settings window
		winset(src,"win_settings",						"background-color=[d]")
		winset(src,"win_settings.label_colortheme",		"background-color=[d]")
		winset(src,"win_settings.label_namecolor",		"background-color=[d]")
		winset(src,"win_settings.label_fontstyle",		"background-color=[d]")
		winset(src,"win_settings.label_orientation",	"background-color=[d]")
		winset(src,"win_settings.label_flags",			"background-color=[d]")
		winset(src,"win_settings.button_customtheme",	"background-color=[d]")
		winset(src,"win_settings.button_customname",	"background-color=[d]")
		winset(src,"win_settings.label_password",		"background-color=[d]")

	UpdateBGColor(d)
			// main window
		winset(src,"win_main.output_motd",				"background-color=[d]")
		winset(src,"win_main.label_clock",				"background-color=[d]")
		winset(src,"win_main.label_channelname",		"background-color=[d]")
		winset(src,"win_main.input",					"background-color=[d]")
		winset(src,"win_main.button_pastebin",			"background-color=[d]")
		winset(src,"win_main.button_settings",			"background-color=[d]")
			// chat pane
		winset(src,"pane_chat.output",					"background-color=[d]")
			// who pane
		winset(src,"pane_who",							"background-color=[d]")
		winset(src,"pane_who.browser",					"background-color=[d]")
			// settings window
		winset(src,"win_settings",						"background-color=[d]")
		winset(src,"win_settings.radio_font_1",			"background-color=[d]")
		winset(src,"win_settings.radio_font_2",			"background-color=[d]")
		winset(src,"win_settings.radio_font_3",			"background-color=[d]")
		winset(src,"win_settings.radio_font_4",			"background-color=[d]")
		winset(src,"win_settings.radio_font_5",			"background-color=[d]")
		winset(src,"win_settings.radio_font_6",			"background-color=[d]")
		winset(src,"win_settings.radio_font_7",			"background-color=[d]")
		winset(src,"win_settings.radio_font_8",			"background-color=[d]")
		winset(src,"win_settings.check_rpgoutput",		"background-color=[d]")
		winset(src,"win_settings.check_uiflashing",		"background-color=[d]")
		winset(src,"win_settings.radio_userlist_left",	"background-color=[d]")
		winset(src,"win_settings.radio_userlist_right",	"background-color=[d]")
			// palette helper
		winset(src,"win_palettehelper",					"background-color=[d]")


	UpdateMOTD()
		src << output(null,"win_main.output_motd")
		src << output("[_motd]","win_main.output_motd")

	UpdateChannelName()
		winset(src,"win_main.label_channelname","text=\"[_channelname]\"")

	Output(T,N=1)
		if (!IsMuted())
			var/d 	= "[CropText(html_encode(T),500)]"
			d		= SafeText(d)
			var/fs 	= "<a href=\"http://www.byond.com/people/[account.id]/\" style=\"color:[name_color]\">[account.username]</a>"
			var/ft	= "<font style=\"color:[name_color]\">[account.username]</font>"
			if (N == 1)
				for (var/client/c in _clients)
					var/e = "<font face=Consolas>\[[_time.ExportTimeStamp(c.account.gmt_offset)]\]</font>"
					var/f = ""
					if (c.conn_type == CONN_TELNET)
						f = ft
					else
						f = fs
					c << output("[e] <u>[f]</u>: [d]","pane_chat.output")
			else if (N == 2)
				for (var/client/c in _clients)
					var/e = "<font face=Consolas>\[[_time.ExportTimeStamp(c.account.gmt_offset)]\]</font>"
					var/f = ""
					if (c.conn_type == CONN_TELNET)
						f = ft
					else
						f = fs
					c << output("[e] <i><u>[f]</u> [d]</i>","pane_chat.output")

			Server_FlashClients()

	OutputRoll(T=2,S=6)
		if (!IsMuted())
			var/r = 0
			for (var/i = 1; i <= T; i++)
				r += rand(1,S)

			var/f  = "<a href=\"http://www.byond.com/people/[ckey]/\" style=\"color:[name_color]\">[account.username]</a>"
			var/ft = "<font style=\"color:[name_color]\">[account.username]</font>"

			for (var/client/c in _clients)
				var/p = "\icon[_images[IMG_DICE]]"

				if (c.conn_type == CONN_TELNET)
					p 	= "\[DICE\]"
					f	= ft

				var/e = "<font face=Consolas>\[[_time.ExportTimeStamp(c.account.gmt_offset)]\]</font>"
				c << output("[e] <u>[f]</u> [p] [S] sides, [T] times = [num2text(r,20)]")
			Server_FlashClients()


	OutputLink(A,T)
		if (!IsMuted())
			var/a 	= "<a href=\"[A]\">[T]</a>"
			var/at	= A
			var/f  	= "<a href=\"http://www.byond.com/people/[ckey]/\" style=\"color:[name_color]\">[account.username]</a>"
			var/ft 	= "<font style=\"color:[name_color]\">[account.username]</font>"

			for (var/client/c in _clients)
				var/u = ""
				var/v = ""
				var/e = "<font face=Consolas>\[[_time.ExportTimeStamp(c.account.gmt_offset)]\]</font>"
				if (c.conn_type == CONN_TELNET)
					u = at
					v = ft
				else
					u = a
					v = f
				c << output("[e] <u>[v]</u>: [u]","pane_chat.output")





