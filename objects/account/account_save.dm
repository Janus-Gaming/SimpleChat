


////////////////////////
// LOADING AN ACCOUNT //
////////////////////////

proc/LoadAccount(T)
	if (fexists(T))

		var/account/a 	= new
		a.Auth()
		var/list/L 		= FileToList(T)
		var/n			= 1

		a.id 			= GetElem(L,n++)
		a.username		= GetElem(L,n++)
		a.password		= GetElem(L,n++)

		var/e = text2num( GetElem(L,n++,0) )
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				a.assoc_ckeys += GetElem(L,n++)

		e = text2num( GetElem(L,n++,0) )
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				a.assoc_ips += GetElem(L,n++)

		e = text2num( GetElem(L,n++,0) )
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				a.assoc_cids += GetElem(L,n++)

		a.exp 				= text2num(GetElem(L,n++))
		a.exp				= max(a.exp,0)

		a.level				= text2num(GetElem(L,n++))
		a.level				= max(a.level,1)

		a.total_exp			= text2num(GetElem(L,n++))
		a.total_exp			= min(a.total_exp,10)

		a.gmt_offset		= text2num(GetElem(L,n++))
		a.flag_rpgoutput	= text2num(GetElem(L,n++))
		a.flag_uiflashing	= text2num(GetElem(L,n++))

		e = text2num(GetElem(L,n++))
		a.SetRank(e)

		a.saved_theme		= text2num(GetElem(L,n++))
		a.saved_color_x		= text2num(GetElem(L,n++))
		a.saved_color_y 	= text2num(GetElem(L,n++))
		a.saved_fontstyle	= text2num(GetElem(L,n++))
		a.custom_skin		= GetElem(L,n++)
		a.custom_bg			= GetElem(L,n++)
		a.who_orientation	= text2num(GetElem(L,n++))

		e = text2num(GetElem(L,n++))
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				a.achievements += GetElem(L,n++)

		a.custom_namecolor	= GetElem(L,n++)
		a.custom_fontstyle	= GetElem(L,n++)

		e = text2num(GetElem(L,n++,0))
		if (e > 0)
			for (var/i = 1; i <= e; i++)
				var/penalty/p = new
				p.penalty_type 	= text2num(GetElem(L,n++))
				p.time			= text2num(GetElem(L,n++))
				p.reason		= GetElem(L,n++)
				if (p.penalty_type && p.time)
					a.penalties 	+= p

		a.exp_max = CalcEXP(a.level)
		a.flag_byondauthed	= TRUE

		return a

///////////////////////
// SAVING AN ACCOUNT //
///////////////////////

proc/SaveAccount(account/a)
	spawn()
		world.SetScores("[a.username]",list2params(list("Level"="[a.level]","EXP"="[a.exp]")))

	if (fexists("files/accounts/[a.id].account"))
		fdel("files/accounts/[a.id].account")

	var/f = file("files/accounts/[a.id].account")

	f << "{ID            }[a.id]"
	f << "{Username      }[a.username]"
	f << "{Password      }[a.password]"

	f << "{AssocCkeys    }[length(a.assoc_ckeys)]"
	var/b = 0
	for (var/i in a.assoc_ckeys)
		f << "{[++b]}[i]"

	f << "{AssocIPs      }[length(a.assoc_ips)]"
	b = 0
	for (var/i in a.assoc_ips)
		f << "{[++b]}[i]"

	f << "{AssocCIDs     }[length(a.assoc_cids)]"
	b = 0
	for (var/i in a.assoc_cids)
		f << "{[++b]}[i]"

	f << "{EXP           }[a.exp]"
	f << "{Level         }[a.level]"
	f << "{TotalEXP      }[a.total_exp]"
	f << "{GMTOffset     }[a.gmt_offset]"
	f << "{FlagRPGOutput }[a.flag_rpgoutput]"
	f << "{FlagUIFlashing}[a.flag_uiflashing]"
	f << "{Rank          }[a.rank.value]"
	f << "{SavedTheme    }[a.saved_theme]"
	f << "{SavedColorX   }[a.saved_color_x]"
	f << "{SavedColorY   }[a.saved_color_y]"
	f << "{SavedFontStyle}[a.saved_fontstyle]"
	f << "{CustomSkin    }[a.custom_skin]"
	f << "{CustomBG      }[a.custom_bg]"
	f << "{WhoOrientation}[a.who_orientation]"

	f << "{Achievements  }[length(a.achievements)]"
	b = 0
	for (var/i in a.achievements)
		f << "{[++b]}[i]"

	f << "{CustomName    }[a.custom_namecolor]"
	f << "{CustomFont    }[a.custom_fontstyle]"

	f << "{Penalties     }[length(a.penalties)]"
	b = 0
	for (var/penalty/p in a.penalties)
		if (p.penalty_type > 0)
			if (p.penalty_type && p.time)
				var/t 	=  "{[++b]}"
				t 		+= "[Fill(p.penalty_type,"0")];"
				t		+= "[Fill(p.time,"0")];"
				t		+= "[Fill(p.reason,"None")]"
				f << t
