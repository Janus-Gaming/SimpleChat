
///////////////////
// COMMAND TYPES //
///////////////////

command

	///////////////////
	// USER COMMANDS //
	///////////////////

	google
		name	= "GoogleSearch"
		desc	= "Provides a handy google search query for users to click."
		format	= "/cmd (T:word1) (T:word2)..."
		args_amt= 0
		ids		= list("/google")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = CropText(SafeText(html_encode(ListToText(L,"+"))),200)
				C.OutputLink("http://www.google.com/search?q=[d]","Google: \"[d]\"")

	bing
		name	= "BingSearch"
		desc	= "Provides a handy Bing search query for users to click."
		format	= "/cmd (T:word1) (T:word2)..."
		args_amt= 0
		ids		= list("/bing")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = CropText(SafeText(html_encode(ListToText(L,"+"))),200)
				C.OutputLink("http://www.bing.com/search?q=[d]","Bing: \"[d]\"")

	wiki
		name	= "WikipediaSearch"
		desc	= "Provides a handy Wikipedia search query for users to click."
		format	= "/cmd (T:word1) (T:word2)..."
		args_amt= 0
		ids		= list("/wikipedia","/wiki")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = CropText(SafeText(html_encode(ListToText(L,"_"))),200)
				C.OutputLink("http://www.wikipedia.org/wiki/[d]","Wikipedia: \"[d]\"")

	youtube
		name	= "YoutubeSearch"
		desc	= "Provides a handy Youtube search query for users to click."
		format	= "/cmd (T:word1) (T:word2)..."
		args_amt= 0
		ids		= list("/youtube","/yt")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = CropText(SafeText(html_encode(ListToText(L,"+"))),200)
				C.OutputLink("http://www.youtube.com/results?search_query=[d]","Youtube: \"[d]\"")

	forums
		name	= "ForumsSearch"
		desc	= "Provides a handy BYOND Forums search query for users to click."
		format	= "/cmd (T:word1) (T:word2)..."
		args_amt= 0
		ids		= list("/forums")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = CropText(SafeText(html_encode(ListToText(L,"+"))),200)
				C.OutputLink("http://www.byond.com/forum/?command=search&text=[d]","Forum: \"[d]\"")

	people
		name	= "PeopleSearch"
		desc	= "Provides a handy BYOND Forums search query for users to click."
		format	= "/cmd (T:ckey)"
		args_amt= 1
		ids		= list("/people")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d1 = CropText(SafeText(html_encode(GetElem(L,1))),200)
				var/d2 = ckey(d1)
				C.OutputLink("http://www.byond.com/people/[d2]","People: \"[d1]\"")

	dictionary
		name	= "Dictionary"
		desc	= "Provides a handy Dictionary link for users to click."
		format	= "/cmd (T:word)"
		args_amt= 1
		ids		= list("/dictionary","/dic","/define")
		req		= RANK_USER
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d1 = CropText(SafeText(html_encode(GetElem(L,1))),200)
				var/d2 = ckey(d1)
				C.OutputLink("http://www.dictionary.com/browse/[d2]","Dictionary: \"[d1]\"")


	help
		name	= "Help"
		desc	= "Displays all of the available commands the user can use."
		format	= "/cmd"
		args_amt= 1
		ids		= list("/help","/?")
		req		= RANK_USER
		Use(client/C,list/L)
			if (length(L) > 0)
				return
			else
				C.Menu_ShowReference()

/*
	link
		name 	= "Link"
		desc	= "Generate a convenient, clickable link to others."
		format	= "/cmd (text) (text)"
		args_amt= 2
		ids		= list("/link","/l")
		req		= RANK_USER
*/

	speak
		name 	= "Speak"
		desc	= "Speak to the general output."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/speak","/s")
		req		= RANK_USER
		Use(client/C, list/L)
			C.Action()
			if (C.account.IsMuted())
				return
			else
				if (L)
					C.Output(L[1])

	me
		name	= "Me"
		desc	= "Emote an action to the general output."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/me","/m")
		req		= RANK_USER
		Use(client/C, list/L)
			C.Action()
			if (C.account.IsMuted())
				return
			else
				if (length(L) > 0)
					C.Output(L[1],2)


	roll
		name	= "Roll"
		desc	= "Roll dice, x times for y faces."
		format	= "/cmd (num) (num)"
		args_amt= 2
		ids		= list("/roll","/r")
		req		= RANK_USER
		Use(client/C, list/L)
			C.Action()
			if (C.account.IsMuted())
				return
			else
				var/t = text2num(GetElem(L,1))
				if (!t)
					t = 1
				else
					t = round(Clamp(t,1,1000))

				var/s = text2num(GetElem(L,2))
				if (!s)
					s = 6
				else
					s = round(Clamp(s,2,1000))

				C.OutputRoll(t,s)


/*
	profile
		name	= "Profile"
		desc	= "Displays profile information on a ckey in the room."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/profile","/p")
		req		= RANK_USER
*/

	tell
		name	= "Tell"
		desc	= "Send a user X a message Y."
		format	= "/cmd (text) (text)"
		args_amt= 2
		ids		= list("/tell","/t","/pm","/wsp","/pst")
		req		= RANK_USER
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 		= ckey(GetElem(L,1))
				var/d2 		= GetElem(L,2)
				var/list/l 	= MatchClients(d1)
				if (length(l) >= 1)
					for (var/client/c in l)
						if (length(c.ckey) == length(d1))
							C.SendTell(c,d2)
							return
					C.SendTell(l[1],d2)




/*
	ignore
		name	= "Ignore"
		desc	= "Ignore a ckey or user currently in the channel."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/ignore","/i")
		req		= RANK_USER

	unignore
		name	= "Unignore"
		desc	= "Remove a ckey from your ignore list."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/unignore","/i")
		req		= RANK_USER

	clearchat
		name	= "ClearChat"
		desc	= "Flushes the chat output."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/clearchat","/cc")
		req		= RANK_USER
*/

	motd
		name	= "MOTD"
		desc	= "Displays the MOTD. Adding text will change the MOTD."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/motd")
		req		= RANK_USER
		req2	= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				if (length(L) == 0)
					Server_Notify(C,"<u>MOTD</u>: [_motd]")
				else if (length(L) > 0)
					if (C.account.rank.value >= req2)
						_motd = GetElem(L,1)
						Server_Announce("The MOTD has been changed to \"[_motd]\"")
						Server_RefreshMOTD()

	channelname
		name	= "ChannelName"
		desc	= "Displays the channel Name in text. Adding text will change the Channel Name."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/channelname","/chan","/chn")
		req		= RANK_USER
		req2	= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				if (length(L) == 0)
					Server_Notify(C,"<u>Channel Name</u>: [_channelname]")
				else if (length(L) > 0)
					if (C.account.rank.value >= req2)
						_channelname = GetElem(L,1)
						Server_Announce("The channel's name has been changed to \"[_channelname]\"")
						Server_RefreshChannelNames()




	afk
		name	= "AFK"
		desc	= "Go Away-From-Keyboard with reason X."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/afk")
		req		= RANK_USER
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				if (length(L) > 0)
					C.SetStatus(STATUS_AFK,null,L[1])
				else
					C.SetStatus(STATUS_AFK,C.idle_timer.time)




	ping
		name	= "Ping"
		desc	= "Relays a message to the server, which sends a message back."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/ping")
		req		= RANK_USER
		Use(client/C, list/L)
			winset(C,null,"command=.ping")

	account
		name	= "Account"
		desc	= "Log into an account using the account's password."
		format	= "/cmd (text) (text)"
		args_amt= 2
		ids		= list("/account","/acc","/login","/auth")
		req		= RANK_USER
		Use(client/C, list/L)
			C.Action()
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1)
				var/d2 = GetElem(L,2)
				var/c  = C.account.username
				for (var/account/a in _accounts)
					if ((findtext(a.id,d1)) && (a.password == d2))
						C.SwitchAccount(a)
						Server_Announce("[c] has authed to [a.username]'s account.")
						Server_RefreshUserlists()
						return


	password
		name	= "Password"
		desc	= "displays your password."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/password","/pass")
		req		= RANK_USER
		Use(client/C, list/L)
			Server_Notify(C,"Your password is \"[C.account.password]\"")

	who
		name	= "Who"
		desc	= "(Telnet) Displays online users."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/who","/users","/w")
		req		= RANK_USER
		Use(client/C)
			if (IsTelnet(C))
				var/d1 = PadString(length(_sortedclients),2," ")
				C << "Users Online: ([d1])"
				for (var/client/c in _sortedclients)
					var/d = "~"
					switch(c.account.rank.value)
						if (RANK_USER)
							d = "~"
						if (RANK_OP)
							d = "+"
						if (RANK_HOST)
							d = "@"

					var/e = "green"
					switch(c.status)
						if (STATUS_AVAIL)
							e = "green"
						if (STATUS_IDLE)
							e = "yellow"
						if (STATUS_AFK)
							e = "red"

					var/u = PadString("[c.account.level]",2," ")
					C << " <font color=[e]>[d]</font> lv.[u] <font color=[c.name_color]>[c.account.username]</font>"
				C << "-------------"


	/*
	google
		name	= "Google"
		desc	= "creates a clickable Google link in-chat with your search query."
		format	= "/cmd (T:query)"
		args_amt= 1
		ids		= list("/google")
		Use(client/C, list/L)

	bing
	wiki
	*/


	///////////////////////////
	// SETTINGS TAB COMMANDS //
	///////////////////////////

	color
		name	= "Color"
		desc	= "Sets your name color to X"
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/namecolor","/color","/c")
		req		= RANK_USER
		Use(client/C, list/L)
			var/d = GetElem(L,1)
			d = FilterToColor(d)
			C.name_color = d
			Server_Notify(C,"Your color is set to [C.name_color]")
			Server_RefreshUserlists()

/*
	timeoffset
		name	= "TimeOffset"
		desc	= "Sets the GMT offset of your client."
		format	= "/cmd (num)"
		args_amt= 1
		ids		= list("/settimeoffset","/time")
		req		= RANK_USER
*/

	////////////////////////
	// MODERATOR COMMANDS //
	////////////////////////

/*
	setcmdrank
		name	= "SetCMDRank"
		desc	= "Changes the rank permission of a command. Use /help to check a command."
		format	= "/cmd (text) (num)"
		args_amt= 2
		ids		= list("/setcmdrank","/crank")
		req		= RANK_HOST

	uploaddmb
		name	= "UploadDMB"
		desc	= "Uploads a SimpleChat DMB from the user's computer."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/uploaddmb","/dmb")
		req		= RANK_HOST

	hosts
		name	= "Hosts"
		desc	= "displays a list of hosts to the user."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/hosts")
		req		= RANK_HOST

	announce
		name	= "Announce"
		desc	= "Announce a message to the channel."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/announce","/ann")
		req		= RANK_HOST
*/

	shutdown
		name	= "ShutDown"
		desc	= "Shuts the channel server down."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/shutdown","/down")
		req		= RANK_HOST
		Use(client/C)
			del world

	saveall
		name	= "SaveAll"
		desc	= "Saves all accounts."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/saveall","/sa")
		req		= RANK_HOST
		Use(client/C,list/L)
			Server_SaveAccounts()
			Server_Notify(C,"All clients' accounts have been saved.")


/*
	playsound
		name	= "PlaySound"
		desc	= "Plays a sound to the channel. Must be in the /sounds directory of the hosted channel."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/playsound","/sound")
		req		= RANK_OP
*/


	promote
		name	= "Promote"
		desc	= "Promotes a user to a higher rank."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/promote","/pro")
		req		= RANK_HOST
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/u = ckey(GetElem(L,1))
				if (u)
					for (var/client/c in _clients)
						if (findtext(u,c.account.username))
							c.account.SetRank(RANK_OP)
							Server_Announce("[C.account.username] has promoted [c.account.username] to Operator.")
							Server_RefreshUserlists()


	demote
		name	= "Demote"
		desc	= "Demotes a user to a lower rank."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/demote","/dem")
		req		= RANK_HOST
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/u = ckey(GetElem(L,1))
				if (u)
					for (var/client/c in _clients)
						if (findtext(ckey(c.account.username),u))
							if (C.account.rank.value > c.account.rank.value)
								c.account.SetRank(RANK_USER)
								Server_Announce("[C.account.username] has demoted [c.account.username] to User.")
								Server_RefreshUserlists()


	jail
		name	= "Jail"
		desc	= "Jails a user."
		format	= "/cmd (T:name) (N:length) (T:reason)"
		args_amt= 3
		ids		= list("/jail")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1)
				var/d2 = text2num( GetElem(L,2,-1) )
				var/d3 = GetElem(L,3,"No Reason.")
				if (d1)
					var/account/a = SearchAccount(d1)
					if (a)
						if (a.rank.value < C.account.rank.value)
							a.AddPenalty(PENALTY_JAIL,d2,d3,C.account.rank.value)
							Server_Announce("[C.account.username] has jailed account \"[a.id]\"")
							Server_Announce("Length: [d2] \t Reason: [d3]")
							winshow(a.client,"win_palettehelper",FALSE)
							winshow(a.client,"win_settings",FALSE)
							Server_RefreshUserlists()

	unjail
		name	= "Unjail"
		desc	= "Unjails a user."
		format	= "/cmd (T:name)"
		args_amt= 1
		ids		= list("/unjail")
		req		= RANK_OP
		Use(client/C, list/L)
			var/d1 = ckey(GetElem(L,1))
			if (d1)
				var/list/l = MatchAccounts(d1)
				for (var/account/a in l)
					if (length(d1) >= length(a.id))
						var/penalty/p = a.IsJailed()
						if (p && (p.rank <= C.account.rank.value))
							a.RemovePenalty(PENALTY_JAIL, C.account.rank.value)
							Server_Announce("[C.account.username] has unjailed account \"[a.id]\"")
							Server_RefreshUserlists()




	mute
		name	= "Mute"
		desc	= "Mutes a user."
		format	= "/cmd (T:name) (N:length) (T:reason)"
		args_amt= 3
		ids		= list("/mute")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1)
				var/d2 = text2num( GetElem(L,2,-1) )
				var/d3 = GetElem(L,3,"No Reason.")
				if (d1)
					var/account/a = SearchAccount(d1)
					if (a)
						if (a.rank.value < C.account.rank.value)
							a.AddPenalty(PENALTY_MUTE,d2,d3,C.account.rank.value)
							Server_Announce("[C.account.username] has muted account \"[a.id]\"")
							Server_Announce("Length: [d2] \t Reason: [d3]")
							Server_RefreshUserlists()

	unmute
		name	= "Unmute"
		desc	= "Unmutes a user."
		format	= "/cmd (T:name)"
		args_amt= 1
		ids		= list("/unmute")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = ckey(GetElem(L,1))
				if (d1)
					var/list/l = MatchAccounts(d1)
					for (var/account/a in l)
						if (length(d1) >= length(a.id))
							var/penalty/p = a.IsMuted()
							if (p && (p.rank <= C.account.rank.value))
								a.RemovePenalty(PENALTY_MUTE, C.account.rank.value)
								Server_Announce("[C.account.username] has unmuted account \"[a.id]\"")
								Server_RefreshUserlists()


	kick
		name	= "Kick"
		desc	= "Kicks a user from the channel."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/kick")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1)
				if (d1)
					var/account/a = SearchAccount(d1)
					if (a)
						if (a.rank.value < C.account.rank.value)
							Server_Announce("[a.username] has been kicked by [C.account.username].")
							del a.client

	ban
		name	= "Ban"
		desc	= "Bans a user from the channel."
		format	= "/cmd (T:user) (N:length) (T:reason)"
		args_amt= 3
		ids		= list("/ban")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1)
				var/d2 = text2num( GetElem(L,2,-1) )
				var/d3 = GetElem(L,3,"No Reason.")

				if (d1)
					var/account/a = SearchAccount(d1)
					if (a)
						if (a.rank.value < C.account.rank.value)
							a.AddPenalty(PENALTY_BAN,d2,d3,C.account.rank.value)
							Server_Announce("Account \"[a.id]\" has been banned by [C.account.username].")
							Server_Announce("Length: [d2] \t Reason: [d3]")

							if (!a.flag_byondauthed)
								_bannedmisc += a.assoc_ckeys
								_bannedmisc += a.assoc_ips
								_bannedmisc += a.assoc_cids

							del a.client

	unban
		name	= "Unban"
		desc	= "Removes a banned ckey from the global list."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/unban")
		req		= RANK_OP
		Use(client/C, list/L)
			var/d1 = ckey(GetElem(L,1))
			if (d1)
				var/list/l = MatchAccounts(d1)
				for (var/account/a in l)
					if (length(d1) >= length(a.id))
						var/penalty/p = a.IsBanned()
						if (p && (p.rank <= C.account.rank.value))
							a.RemovePenalty(PENALTY_BAN, C.account.rank.value)
							Server_Announce("[C.account.username] has unbanned account \"[a.id]\"")
							Server_RefreshUserlists()

	bannedaccs
		name	= "BannedAccs"
		desc	= "Lists all banned accounts with lengths and reasons."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/bannedaccs","/banned","/ba")
		req		= RANK_OP
		Use(client/C)
			Server_Notify(C,"Banned accounts:")
			for (var/account/a in _accounts)
				var/penalty/p = a.IsBanned()
				if (p)
					Server_Notify(C,"[a.username] || [p.time] || [p.reason] || [p.rank]")


	mutedaccs
		name	= "MutedAccs"
		desc	= "Lists all muted accounts with lengths and reasons."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/mutedaccs","/muted","/ma")
		req		= RANK_OP
		Use(client/C)
			Server_Notify(C,"Muted accounts:")
			for (var/account/a in _accounts)
				var/penalty/p = a.IsMuted()
				if (p)
					Server_Notify(C,"[a.username] || [p.time] || [p.reason] || [p.rank]")

	jailedaccs
		name	= "JailedAccs"
		desc	= "Lists all jailed accounts with lengths and reasons."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/jailedaccs","/jailed","/ja")
		req		= RANK_OP
		Use(client/C)
			Server_Notify(C,"Jailed accounts:")
			for (var/account/a in _accounts)
				var/penalty/p = a.IsJailed()
				if (p)
					Server_Notify(C,"[a.username] || [p.time] || [p.reason] || [p.rank]")

	removemiscban
		name	= "RemoveMiscBan"
		desc	= "Removes a misc. ban ckey or IP address from the Misc. global list."
		format	= "/cmd (T:ckey|ip)"
		args_amt= 1
		ids		= list("/remmisc","/rm")
		req		= RANK_OP
		Use(client/C, list/L)
			if (C.account.IsMuted())
				return
			else
				var/d1 = GetElem(L,1,null)
				if (d1)
					for (var/d in _bannedmisc)
						if (d1 == d)
							_bannedmisc -= d
							Server_Notify(C,"[d] has been removed from the banned-misc list.")

/*
	getip
		name	= "GetIP"
		desc	= "Get the IP address of a user."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/getip","/ip")
		req		= RANK_OP


	getcid
		name	= "GetCID"
		desc	= "Get the Computer ID of an account."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/getcid","/cid")
		req		= RANK_OP
*/

	reboot
		name	= "Reboot"
		desc	= "Reboot the channel."
		format	= "/cmd (text)"
		args_amt= 1
		ids		= list("/reboot")
		req		= RANK_HOST
		Use(client/C, list/L)
			Server_Announce("[C.account.username] has issued a reboot. Please wait...")
			var/d = GetElem(L,1,"None")
			Server_Announce("Reason: [d]")
			_flag_rebootissued = TRUE

	hostadmin
		name	= "HostAdmin"
		desc	= "Gives the user Admin rank if they are a host."
		format	= "/cmd"
		args_amt= 0
		ids		= list("/hostadmin","/host")
		req		= RANK_USER
		Use(client/C)
			if (ckey(world.host) in C.account.assoc_ckeys)
				C.account.SetRank(RANK_HOST)
				Server_Announce("[C.account.username] is now a Host.")
				Server_RefreshUserlists()


	giveexp
		name	= "GiveEXP"
		desc	= "Increases the user's EXP by X."
		format	= "/cmd (T:name) (N:exp)"
		args_amt= 2
		ids		= list("/giveexp","/give")
		req		= RANK_OP
		Use(client/C, list/L)
			var/d1 	= GetElem(L,1)
			var/d2 	= round(text2num(GetElem(L,2)))
			d2		= Clamp(d2,0,9999)
			if (d1 && d2)
				var/account/a = SearchAccount(d1)
				if (a)
					Server_Announce("[C.account.username] has awarded account \"[a.id]\" [d2] EXP.")
					a.AddEXP(d2)

	announce
		name	= "Announce"
		desc	= "Announces a message to the channel."
		format	= "/cmd (T:message)"
		args_amt= 1
		ids		= list("/announce","/ann")
		req		= RANK_OP
		Use(client/C, list/L)
			if (length(L) > 0)
				var/d = GetElem(L,1)
				Server_Announce("[C.account.username] announces:\n\t\"[d]\"")

	setname
		name	= "SetName"
		desc	= "Sets a user's name to something else."
		format	= "/cmd (T:id) (T:name)"
		args_amt= 2
		ids		= list("/setname","/sn")
		req		= RANK_HOST
		Use(client/C, list/L)
			if (length(L) > 1)
				var/d1 = GetElem(L,1)
				var/d2 = GetElem(L,2)
				if (d1 && d2)
					var/list/l = MatchAccounts(d1)
					for (var/account/a in l)
						if (length(a.id) == length(d1))
							var/u = a.username
							a.username = d2
							Server_Announce("[C.account.username] has changed [u]'s username to [a.username].")
							Server_RefreshUserlists()
							return


	setlevel
		name	= "SetLevel"
		desc	= "Sets the level of a user to X."
		format	= "/cmd (T:name) (N:level)"
		args_amt= 2
		ids		= list("/setlevel","/sl")
		req		= RANK_OP
		Use(client/C, list/L)
			var/d1 	= GetElem(L,1)
			var/d2 	= round(text2num(GetElem(L,2)))
			d2		= Clamp(d2,1,MAX_LEVEL)
			if (d1 && d2)
				var/account/a = SearchAccount(d1)
				if (a)
					Server_Announce("[a.username]'s level has been changed to [d2].")
					a.SetLevel(d2)
					Server_RefreshUserlists()

	checkexp
		name	= "CheckEXP"
		desc	= "Shows the EXP of the user given. No arg means self."
		format	= "/cmd (T:user)"
		args_amt= 1
		ids		= list("/checkexp","/exp")
		req		= RANK_USER
		Use(client/C, list/L)
			var/d = GetElem(L,1)
			if (!d)
				Server_Notify(C,"Level: [C.account.level]")
				Server_Notify(C,"EXP: [C.account.exp] / [C.account.exp_max] ([C.account.exp/C.account.exp_max*100]%)")
			else
				var/account/a = SearchAccount(d)
				if (a)
					Server_Notify(C,"EXP details for account \"[a.username]\"")
					Server_Notify(C,"EXP: [a.exp] / [a.exp_max] ([a.exp/a.exp_max*100]%)")
