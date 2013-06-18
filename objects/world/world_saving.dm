
//////////////////
// SAVING PROCS //
//////////////////

proc/Server_SaveAccounts()

	var/list/l = new/list()
	for (var/account/a in _accounts)
		if (a.client && a.flag_byondauthed)
			l += a

	Server_Debug("Accounts to save: [length(l)]")

	for (var/account/a in l)
		SaveAccount(a)
		Server_Debug("Account '[a.id]' saved with Server_SaveAccounts()")




proc/Server_SaveSettings()
	var/d = "files/world/world.settings"

	fdel(d)
	var/f = file(d)

	f << "{ChannelName     }[_channelname]"
	f << "{Flag_AllowGuests}[_flag_allowguests]"
	f << "{Flag_AllowTelnet}[_flag_allowtelnet]"
	f << "{MOTD            }[_motd]"
	f << "{BannedMisc      }[length(_bannedmisc)]"
	var/e = 0
	for (var/p in _bannedmisc)
		f << "{[++e]}[p]"



///////////////////
// LOADING PROCS //
///////////////////

proc/Server_LoadAccounts()
	var/list/L = flist("files/accounts/")
	if (length(L) > 0)
		for (var/a in L)
			var/account/b = LoadAccount("files/accounts/[a]")
			Server_AddAccount(b)

proc/Server_LoadSettings()
	var/d = "files/world/world.settings"
	if (fexists(d))
		var/u = 1
		var/list/l = FileToList(d)
		_channelname 		= GetElem(l,u++)
		_flag_allowguests	= text2num(GetElem(l,u++))
		_flag_allowtelnet	= text2num(GetElem(l,u++))
		_motd				= GetElem(l,u++)

		var/e = text2num(GetElem(l,u++,0))
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				var/y = GetElem(l,u++,0)
				if (y != 0)
					_bannedmisc += y






