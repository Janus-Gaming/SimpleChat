
/////////////////
// TELL OBJECT //
/////////////////

tell

/////////
// VAR //
/////////

tell/var

	id					= "000000"
	list/
		clients			= new/list


//////////
// PROC //
//////////

tell/proc
	Output(client/C, T)
		if (!T)
			if (!winexists(C,"win_tell_[id]"))
				winclone(C,"win_tell_none","win_tell_[id]")
				for (var/client/c2 in clients)
					if (C != c2)
						winshow(C,"win_tell_[id]",TRUE)
						winset(C,"win_tell_[id].input","command=\"Input \\\"/tell [ckey(c2.account.username)] \"")
						winset(C,"win_tell_[id]","title=\"Tell with [c2.account.username]\"")
						break
				winset(C,"win_tell_[id].input","font-family=\"[C.font_style]\"")
				winset(C,"win_tell_[id].input","background-color=[C.bg_color]")
				winset(C,"win_tell_[id].output","background-color=[C.bg_color]")
				winset(C,"win_tell_[id].output","font-style=\"[C.font_style]\"")
				winset(C,"win_tell_[id]","background-color=[C.skin_color]")
			winshow(C,"win_tell_[id]",TRUE)

		else
			for (var/client/c in clients)
				var/d 	= "[CropText(html_encode(T),500)]"
				d		= SafeText(d)
				var/e 	= "<font color=[C.name_color]>[C.account.username]</font>"
				var/f 	= "<font face=Consolas>\[[_time.ExportTimeStamp(c.account.gmt_offset)]\]</font>"
				if (!winexists(c,"win_tell_[id]"))
					winclone(c,"win_tell_none","win_tell_[id]")
					for (var/client/c2 in clients)
						if (c != c2)
							winshow(c,"win_tell_[id]",TRUE)
							winshow(c2,"win_tell_[id]",TRUE)
							winset(c,"win_tell_[id].input","command=\"Input \\\"/tell [ckey(c2.account.username)] \"")
							winset(c,"win_tell_[id]","title=\"Tell with [c2.account.username]\"")
							break

					winset(c,"win_tell_[id].input","font-family=\"[c.font_style]\"")
					winset(c,"win_tell_[id].input","background-color=[c.bg_color]")
					winset(c,"win_tell_[id].output","background-color=[c.bg_color]")
					winset(c,"win_tell_[id].output","font-style=\"[c.font_style]\"")
					winset(c,"win_tell_[id]","background-color=[c.skin_color]")

				for (var/client/c1 in clients)
					winshow(c1,"win_tell_[id]",TRUE)
				c << output("[f] <u>[e]</u>: [d]","win_tell_[id].output")
				c.FlashClient()



/////////
// NEW //
/////////

proc/CreateTell(client/c1, client/c2)
	var/tell/t 	= new
	t.id 		= PadString("[rand(0,999999)]",6,"0")
	t.clients	= list(c1,c2)
	_tells		+= t
	c1.tells 	+= t
	c2.tells	+= t
	return t