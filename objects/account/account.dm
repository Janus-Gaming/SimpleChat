
///////////
// CONST //
///////////

var/const

	IDLE_TIME		= 9000

	USERLIST_LEFT	= 1
	USERLIST_RIGHT	= 2

	EXP_COEFF		= 10
	MAX_LEVEL		= 100

////////////////////
// ACCOUNT OBJECT //
////////////////////

account

/////////
// VAR //
/////////

account/var

	username			= "?"
	id					= ""
	password			= ""

	client/
		client			= null

	list/
		assoc_ckeys		= new/list()
		assoc_ips		= new/list()
		assoc_cids		= new/list()

	exp					= 0
	exp_max				= 10
	level				= 1
	total_exp			= 0

	gmt_offset			= 0

	flag_rpgoutput		= TRUE
	flag_uiflashing		= TRUE
	flag_byondauthed	= FALSE
	flag_hasoldexp		= FALSE

	rank/
		rank			= new/rank/user

	saved_theme			= 1
	saved_color_x		= 1
	saved_color_y		= 1
	saved_fontstyle		= 1
	custom_skin			= "#888888"
	custom_bg			= "#222222"
	custom_namecolor	= "#FFFFFF"
	custom_fontstyle	= "Verdana"

	who_orientation		= USERLIST_RIGHT

	idle_time			= IDLE_TIME

	list/
		achievements		= new/list()
		penalties			= new/list()
		ignored_accounts	= new/list()

	timer/
		update_timer	= new(10,-1)

////////////
// UPDATE //
////////////

account/Update()

	update_timer.Update()
	if (update_timer.Event_TimeUp())

		for (var/penalty/p in penalties)
			p.Update()

