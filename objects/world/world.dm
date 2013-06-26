/////////////
// DEFINES //
/////////////

#define or ||
#define and &&

///////////
// CONST //
///////////

var/const

	COLOR_TEXT		 	= "#FFFFFF"
	COLOR_OFFTEXT		= "#777777"


	IMG_AVAIL			= 1
	IMG_IDLE			= 2
	IMG_AFK				= 3
	IMG_OP				= 4
	IMG_HOST			= 5
	IMG_DICE			= 6


//////////////////
// WORLD OBJECT //
//////////////////

world
	name		= "Starbase Janus SimpleChat Server"
	icon_size	= 20
	version 	= 411


/////////
// VAR //
/////////

var
	_display_version		= "v4.11"
	_channelname			= "General Channel"
	_motd					= ""

	icon/
		_images				= list( icon('user_icons.dmi',"avail"),
									icon('user_icons.dmi',"idle"),
									icon('user_icons.dmi',"afk"),
									icon('user_icons.dmi',"op"),
									icon('user_icons.dmi',"host"),
									icon('ui_icons.dmi',"dice"))

	_flag_allowguests		= FALSE
	_flag_allowtelnet		= TRUE
	_flag_rebootissued		= FALSE
	_flag_shutdown			= FALSE

	timer/
		_update_timer		= new(10,-1)
		_status_timer		= new(50,-1)

	_clients_amt			= 0

	time/
		_time				= new

	// LISTS
	// -----

	list/
		_accounts			= new/list()
		_clients			= new/list()
		_sortedclients		= new/list()
		_codes				= new/list()
		_bannedmisc			= new/list()
		_modules			= new/list()
		_commands			= new/list()
		_tells				= new/list()
		_startupdebug		= new/list()


	list/
		_list_passchars		= list(	"a","b","c","d","e","f","g","h","i","j","k","l","m",
									"n","o","p","q","r","s","t","u","v","w","x","y","z",
									"0","1","2","3","4","5","6","7","8","9")

		_list_fontchars		= list(	"a","b","c","d","e","f","g","h","i","j","k","l","m",
									"n","o","p","q","r","s","t","u","v","w","x","y","z",
									"0","1","2","3","4","5","6","7","8","9"," ")
		_list_colorchars	= list(	"a","b","c","d","e","f","g","h","i","j","k","l","m",
									"n","o","p","q","r","s","t","u","v","w","x","y","z",
									"0","1","2","3","4","5","6","7","8","9"," ","#")

		_status_images		= list( '0_0.png', '0_1.png', '0_2.png',
									'1_0.png', '1_1.png', '1_2.png',
									'2_0.png', '2_1.png', '2_2.png')

	_chatchars_min			= 32
	_chatchars_max			= 126
