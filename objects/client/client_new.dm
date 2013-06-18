
/////////
// NEW //
/////////

client/New()
	..()
		// Set the connection type accordingly
	if (connection == "seeker")
		conn_type				= CONN_SEEKER
		CacheImages()
	else if (connection == "telnet")
		conn_type				= CONN_TELNET


	if (IsBYOND())
		var/account/a = FindAccount(src)
		if (a)
			if (a.IsBanned())
				flag_banned = TRUE
				del src
			else
				SetAccount(a)
				a.AddCkey(src.ckey)
				a.AddIP(src.address)
				a.AddCID(src.computer_id)

		else
			CreateAccount(src)

	else
		if ((ckey in _bannedmisc) || (address in _bannedmisc))
			flag_banned = TRUE
			del src
		else
			CreateAccount(src)


	if (conn_type == CONN_SEEKER)
		UpdateCustomTheme()
		UpdateCustomName()
		UpdateCustomFont()

		if (IsGuest(src))
			Settings_SetNameColor(rand(1,12),rand(1,2))
		else
			Settings_SetNameColor(account.saved_color_x, account.saved_color_y)

		Settings_SetGMTOffset(account.gmt_offset)
		Settings_SetTheme(account.saved_theme)

		Settings_SetFontStyle(account.saved_fontstyle)
		Settings_SetPaneOrientation(account.who_orientation)
		Settings_SetPassword(account.password)


		// set the status icon for the user.
	//SetStatusImage	(status, account.rank.value)

		// Refresh the UI
	if (!IsTelnet(src))
		UpdateMOTD()
		UpdateChannelName()


		// Add the client to the serverlist
	Server_AddClient(src)

	Server_UpdateClientAmt()
	Server_RefreshUserlists()
	Server_Announce("[account.username] has joined.")
	account.CheckLevelUp()
	flag_settingslogin = TRUE

	///////////
	// DEBUG //
	///////////


