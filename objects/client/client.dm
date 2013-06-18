
///////////
// CONST //
///////////

var/const

	CONN_NONE			= 0
	CONN_SEEKER			= 1
	CONN_TELNET			= 2
	CONN_STANDALONE		= 3

	UPDATE_TIME			= 10
	SAVE_TIME			= 600
	SETTINGS_TIME		= 10

	STATUS_AVAIL		= 2
	STATUS_IDLE			= 1
	STATUS_AFK			= 0

///////////////////
// CLIENT OBJECT //
///////////////////

client

/////////
// VAR //
/////////

client/var

	flag_banned			= FALSE

	account/
		account			= null

	conn_type			= CONN_NONE

	flag_settingslogin	= FALSE

	update_time			= 0
	update_time_max		= UPDATE_TIME

	status				= STATUS_AVAIL

	skin_color			= null
	bg_color			= null
	name_color			= "#FFFFFF"
	font_style			= null

	timer/
		update_timer	= new(10,-1)				// 1- ticks a loop, infinite loops
		status_timer	= new(IDLE_TIME,0)			// 9000 ticks a loop, no loops
		idle_timer		= new(0,0)					// infinite ticks, no loops
		save_timer		= new(SAVE_TIME,-1)
		settings_timer	= new(10,-1)
		exp_timer		= new(600,-1)

	afk_message			= ""

	list/
		tells			= new/list()


////////////
// UPDATE //
////////////

client/proc/Update()

	update_timer.Update()
	status_timer.Update()
	idle_timer.Update()
	save_timer.Update()
	settings_timer.Update()
	exp_timer.Update()

	if (update_timer.Event_TimeUp())
		RefreshClock()
		RefreshClientAmt()

	if (status_timer.Event_TimeUp())
		if (status == STATUS_AVAIL)
			SetStatus(STATUS_IDLE)
			idle_timer.Run()
			idle_timer.ResetTime()

	if (save_timer.Event_TimeUp())
		if (account.flag_byondauthed)
			SaveAccount(account)

	if (exp_timer.Event_TimeUp())
		if (account)
			account.AddEXP(1)


/////////////
// COMMAND //
/////////////

client/Command(T)
	if (conn_type == CONN_TELNET)
		Input(T)

///////////
// TOPIC //
///////////

client/Topic(href,href_list)

	var/d1 = href_list["action"]

	if (d1 == "tell")
		var/d2 = href_list["id"]
		if (d2 && d2 != ckey)
			CMD(src,"/tell [d2]")

	else if (d1 == "code")
		var/d2 = href_list["id"]
		if (d2)
			DisplayCode(d2)


