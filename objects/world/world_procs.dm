
/////////////////
// WORLD PROCS //
/////////////////

proc

	////////////////////
	// SEVRER METHODS //
	////////////////////

	Server_Debug(T)
		for (var/client/C in _clients)
			if (C.account.rank.value >= RANK_OP)
				C.Debug(T)

	Server_RefreshChannelNames()
		for (var/client/c in _clients)
			c.UpdateChannelName()


	Server_SortClients()
		var/list/l = new/list()
		for (var/client/c in _clients)
			if (length(l) == 0)
				l += c
			else if (length(l) > 0)
				var/i = 0
				var/u = TRUE
				for (var/client/c2 in l)
					i += 1
					var/d1 = ckey(c.account.username)
					var/d2 = ckey(c2.account.username)
					if (d1 < d2)
						l.Insert(i,c)
						i += 1
						u = FALSE
						break
				if (u == TRUE)
					l += c
		_sortedclients = l


	Server_SetStatus(T)
		world.status = T

	Server_FlashClients()
		for (var/client/C in _clients)
			C.FlashClient()

	Server_RefreshUserlists()
		for (var/client/C in _clients)
			C.RefreshUserlist()

	Server_AddAccount(account/A)
		_accounts += A

	Server_AddClient(client/C)
		if ( !(C in _clients) )
			_clients += C
		Server_SortClients()

	Server_RemoveClient(client/C)
		if (C in _clients)
			_clients -= C
		if (C in _sortedclients)
			_sortedclients -= C
		Server_SortClients()

	Server_Announce(T)
		for (var/client/C in _clients)
			Server_Notify(C,T)

	Server_Notify(client/C,T="")
		var/t1 = "[_time.ExportTimeStamp(C.account.gmt_offset)]"
		var/t2 = "<font color=[COLOR_OFFTEXT]>[T]</font>"
		var/t3 = "<font face=Consolas>\[[t1]\]</font> [t2]"
		C << output(t3,"pane_chat.output")

	Server_UpdateClientAmt()
		_clients_amt = length(_clients)
		for (var/client/C in _clients)
			C.RefreshClientAmt()

	Server_RefreshMOTD()
		for (var/client/C in _clients)
			C.UpdateMOTD()

	Server_UnloadAccounts()
		for (var/account/a in _accounts)
			_accounts -= a

	////////////////
	// CLIENT CMD //
	////////////////

	CMD(client/C, T)
		var/L = CommandToList(T,2)
		if (length(L) > 0)
			L[1] = lowertext(L[1])

			for (var/command/c in _commands)
				if (C.account.rank.value >= c.req)
					if (L[1] in c.ids)
						if (length(L) > 1)
							c.Use(C,CommandToList(L[2],c.args_amt))
						else
							c.Use(C,new/list())
						break



	//////////////////////
	// GLOBAL FUNCTIONS //
	//////////////////////

	HTMLTelnet(client/c)
		if (IsTelnet(c))
			return "<img src=\"telnet.png\"></img>"
		else
			return ""


	HTMLJailed(account/a)
		if (a.IsJailed())
			return "<img src=\"jailed.png\"></img>"
		else
			return ""

	HTMLMute(account/a)
		if (a.IsMuted())
			return "<img src=\"mute.png\"></img>"
		else
			return ""



	ParseTabs(T)
		if (T)
			var/t = ""
			var/c = ""
			var/d = length(T)
			for (var/i = 1; i <= d; i++)
				c = copytext(T,i,i+1)
				if (c == "\t")
					c = "    "
				t += c
			return t

	Fill(N,R="0")
		if (N)
			return N
		else
			return R


	SafeText(T)
		var/t = ""
		if (T)
			var/d = length(T)
			for (var/i = 1; i <= d; i++)
				var/c = copytext(T,i,i+1)
				var/c2 = text2ascii(c)
				if ((c2 >= _chatchars_min) && (c2 <= _chatchars_max))
					t += c
		return t



	CalcEXP(L=1)
		return EXP_COEFF * ( (L*(L+1))/2 )




	MatchClients(T)
		var/list/l = new/list()
		if (T != null)
			T = ckey(T)
			for (var/client/C in _clients)
				if (findtext(C.ckey,T))
					l += C
		return l

	MatchAccounts(T)
		var/list/l = new/list()
		if (T != null)
			T = ckey(T)
			for (var/account/a in _accounts)
				if (findtext(a.id,T))
					l += a
		return l



	FilterToColor(T)
		if (!T)
			return "#FFFFFF"
		else if (length(T) > 0)
			var/t = ""
			var/l = length(T)
			for (var/i = 1; i <= l; i++)
				var/c = copytext(T,i,i+1)
				if (c in _list_colorchars)
					t += c
			return t


	GetElem(list/L,I,N=null)
		if (I <= length(L))
			return L[I]
		else
			return N

	ListToText(list/L,D=", ")
		var/t = null
		if (length(L) > 0)
			t = ""
			for (var/i = 1; i <= length(L); i++)
				if (i == length(L))
					t += "[L[i]]"
				else
					t += "[L[i]][D]"
		return t

	IsTelnet(client/C)
		if (C.conn_type == CONN_TELNET)
			return TRUE
		else
			return FALSE

	IsGuest(client/C)
		if (C.conn_type == CONN_SEEKER)
			if (findtext(C.ckey,"guest"))
				return TRUE

	TicksToTime(N=0)
		var/h = round(N / TICKS_HOUR)
		N -= (h*TICKS_HOUR)
		var/m = round(N / TICKS_MINUTE)
		N -= (m*TICKS_MINUTE)
		var/s = round(N / TICKS_SECOND)
		return "[h]h [m]m [s]s"


	windel(client/C,W)
		winset(C,W,"parent=none")

	Clamp(N=0, L=0, H=100)
		if (L > H)
			var/d 	= L
			L		= H
			H		= d
		return min(max(L,N),H)


		// GeneratePassword will generate a password of length L.
		// set A to TRUE if you want to use letters with numbers.
		// (leave A FALSE to use just numbers).
	GeneratePassword(L=4)
		var/d = null
		if (L > 0)
			for (var/i = 1; i <= L; i++)
				d += _list_passchars[rand(1,length(_list_passchars))]
			return d
		else
			return


	CommandToList(T="",N=0)
		N 				= Clamp(N,1,16)
		var/n			= 1
		var/list/l 		= new/list()
		var/u			= length(T)

		if (!u)
			return list()
		else if (u > 0)
			if (N == 1)
				return list(T)
			else if (N > 1)
				var/c = ""
				var/w = ""
				var/q = FALSE
				for (var/i = 1; i <= u; i++)
					if (n >= N)
						c = copytext(T,i,u+1)
						l += c
						break
					else if (n < N)
						c = copytext(T,i,i+1)
						if (c == " ")
							if (q == TRUE)
								w += c
							else if (length(w) > 0)
								l += w
								w = ""
								n += 1
						else if (c == "\"")
							if (q == FALSE)
								q = TRUE
							else
								q = FALSE
						else
							w += c
				if (length(w) > 0)
					l += w
				return l



	CropText(T="",L=500)
		if (length(T) > L)
			return copytext(T,1,L+1)
		else
			return T


	PadString( T="Test", N=10, C="0", A=FALSE )
		//	T	= text to pad
		//	N	= amount of characters
		//	C	= padding character
		//	A	= align (FALSE = right, TRUE = left)

		T = "[T]"
		var/d = length(T)
		if (d < N)
			var/e = ""
			while(length(e) + d < N)
				e += "[C]"
			if (A == FALSE)
				return e + T
			else if (A == TRUE)
				return T + e
		else if (d == N)
			return T
		else if (d > N)
			if (A == FALSE)
				return copytext(T,1,N+1)
			else if (A == TRUE)
				return copytext(T,d-N+1,d+1)



	FileToList(F="",S="\n",S2=";")
		var/T = ""
		var/v = FALSE
		if (fexists(F))
			T = file2text(F)

		var/list/l = new/list()

		if (length(T) > 0)
			var/c
			var/w
			for (var/i = 1; i <= length(T); i++)
				c = copytext(T,i,i+1)
				if ((c == S) || (c == S2))
					v = FALSE
					if (length(w) > 0)
						l += w
						w = ""
				else if (c == "{")
					v = TRUE
				else if (c == "}")
					v = FALSE
				else if (v == FALSE)
					w += c
			if (length(w) > 0)
				l += w
				w = ""

		return l