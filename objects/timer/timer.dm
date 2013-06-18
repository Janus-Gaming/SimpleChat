
///////////
// CONST //
///////////

var/const

	TIMER_NORMTIME	= 10

//////////////////
// TIMER OBJECT //
//////////////////

timer

/////////
// VAR //
/////////

timer/var

	name		= ""
	id			= ""

	time		= 0
	time_max	= TIMER_NORMTIME

	loop_amt		= -1
	flag_running	= FALSE

////////////
// UPDATE //
////////////

timer/Update()

	if (flag_running == TRUE)
		if ((time < time_max) || (time_max <= 0))
			time++

/////////
// NEW //
/////////

timer/New( M=TIMER_NORMTIME, L=-1, R=TRUE)
	SetTimeMax(M)
	SetLoops(L)

	if (R)
		Run()

	..()


//////////
// PROC //
//////////

timer/proc

	Event_TimeUp()
		if (time >= time_max)
			if (loop_amt == -1)
				ResetTime()
				return TRUE
			else if (loop_amt == 0)
				ResetTime()
				Stop()
				return TRUE
			else if (loop_amt > 0)
				loop_amt -= 1
				ResetTime()
				return TRUE
			else
				return FALSE
		else
			return FALSE


	Run()
		flag_running = TRUE
	Stop()
		flag_running = FALSE

	SetLoops(N=-1)
		loop_amt = N
	AddLoops(N=1)
		loop_amt += N
	InfLoops()
		loop_amt = -1

	SetTimeMax(N)
		time_max	= N
	SetTime(N)
		time		= N
	ResetTime()
		time		= 0

	GetTime()
		return time
