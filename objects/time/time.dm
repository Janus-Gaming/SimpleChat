
////////////
// OBJECT //
////////////

time
	parent_type	= /datum

///////////
// CONST //
///////////

var/const

	TIME_HOUR		= 3600
	TIME_MINUTE		= 60
	TIME_SECOND		= 1

	TICKS_HOUR		= 36000
	TICKS_MINUTE	= 600
	TICKS_SECOND	= 10

/////////
// VAR //
/////////

time/var

	time				= 0
	time_max			= 10

	current_second		= 0
	current_minute		= 0
	current_hour		= 0

/////////
// NEW //
/////////

time/New()
	..()
	Update()

/////////////
// METHODS //
/////////////

time/proc

	ExportTimeStamp(N=0)
		var/d = current_hour + N

		if (d >= 24)
			d -= 24
		else if (d < 0)
			d += 24

		return "[PadString(d,2,"0",FALSE)]:[PadString(current_minute,2,"0",FALSE)]:[PadString(current_second,2,"0",FALSE)]"

////////////
// UPDATE //
////////////

time/Update()

	time += 1
	if (time >= time_max)
		time = 0

		var/d	= round(world.timeofday / 10)
			// grab the seconds in the day

		current_hour 	=  round( d / TIME_HOUR )
		d				-= round( current_hour * TIME_HOUR )

		current_minute	=  round( d / TIME_MINUTE )
		d				-= round( current_minute * TIME_MINUTE )

		current_second	=  round( d / TIME_SECOND )

