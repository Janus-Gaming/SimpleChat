
//////////
// PROC //
//////////

account/proc

	SetLevel(N=1)
		N = Clamp(N,1,MAX_LEVEL)
		level 	= N
		exp		= 0
		exp_max	= CalcEXP(N)

	AddEXP(N)
		exp += N
		if (level < MAX_LEVEL)
			CheckLevelUp()

	CheckLevelUp()
		var/d = FALSE
		while(exp >= exp_max)
			if (level < MAX_LEVEL)
				d 		= TRUE
				level 	+= 1
				exp 	-= exp_max
				exp_max = CalcEXP(level)
			else
				break
		if (d)
			Server_RefreshUserlists()
			if (client)
				Server_Announce("[username] is now level [level]!")
				Server_Notify(client,"[exp_max] EXP is needed for level [level+1].")


	IsBanned()
		for (var/penalty/p in penalties)
			if (p.penalty_type == PENALTY_BAN)
				return p
		return FALSE

	IsMuted()
		for (var/penalty/p in penalties)
			if (p.penalty_type == PENALTY_MUTE)
				return p
		return FALSE

	IsJailed()
		for (var/penalty/p in penalties)
			if (p.penalty_type == PENALTY_JAIL)
				return p
		return FALSE


	Auth()
		flag_byondauthed = TRUE

	IsAuthed()
		return flag_byondauthed

	SetID(T)
		id			= ckey(T)

	SetClient(client/C)
		client		= C

	SetUsername(T)
		username	= "[T]"

	SetPassword(T)
		password	= "[T]"

	AddCkey(T)
		var/d = ckey(T)
		if (!(T in assoc_ckeys))
			assoc_ckeys += d

	AddIP(T)
		if (length(T) > 0)
			if (!(T in assoc_ips))
				assoc_ips 	+= T

	AddCID(T)
		if (!(T in assoc_cids))
			assoc_cids 	+= T

	SetRank(N)
		switch(N)
			if (RANK_USER)
				rank = new/rank/user
			if (RANK_OP)
				rank = new/rank/operator
			if (RANK_HOST)
				rank = new/rank/host
			else
				rank = new/rank/user
		Server_RefreshUserlists()

	PromoteRank()
		if (rank.next_rank != null)
			rank = new rank.next_rank

	DemoteRank()
		if (rank.prev_rank != null)
			rank = new rank.prev_rank

	AddPenalty(T=PENALTY_MUTE,L=-1,R="Reason not given.",P=2)
		// T = type of penalty
		// L = length in minutes
		// P = Rank of the panelty
		// R = Reason
		var/penalty/p = new()
		p.SetType(T)
		p.SetTime(L)
		p.SetReason(R)
		p.SetRank(P)
		p.SetAccount(src)

		if (length(penalties) > 0)
			for (var/penalty/p2 in penalties)
				if (p.penalty_type == p2.penalty_type)
					if (p.rank >= p2.rank)
						penalties -= p2
						penalties += p
						return p
					else
						return FALSE
			penalties += p
			return p
		else
			penalties += p
			return p

	RemovePenalty(T=PENALTY_MUTE, P=2)
		for (var/penalty/p in penalties)
			if (p.rank <= P)
				if (p.penalty_type == T)
					del p
					return



///////////////
// FUNCTIONS //
///////////////

proc

	SearchAccount(T)
		if (length(T) > 0)
			for (var/account/a in _accounts)
				if (findtext(a.id,T))
					return a

	FindAccount(client/C)
		for (var/account/a in _accounts)
			if (a.id == C.ckey)
				return a



	CreateAccount(client/C)
		var/account/a = new()

		if (C.conn_type == CONN_SEEKER)
			if (C.IsBYOND())
				a.SetPassword(GeneratePassword(8))
				a.AddCkey(C.ckey)
				a.AddIP(C.address)
				a.AddCID(C.computer_id)
				a.flag_byondauthed = TRUE
			a.SetUsername(C.key)
			a.SetID(C.ckey)
			a.SetRank(RANK_USER)
			a.saved_color_x = rand(1,12)
			a.saved_color_y = rand(1,2)

		else if (C.conn_type == CONN_TELNET)
			a.SetUsername("[C.address]")
			a.SetID("t[C.address]")
			a.SetRank(RANK_USER)

		Server_AddAccount(a)
		C.SetAccount(a)
		return a

