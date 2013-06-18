///////////
// CONST //
///////////

var/const

	PENALTY_NONE	= 0
	PENALTY_BAN		= 1
	PENALTY_MUTE	= 2
	PENALTY_JAIL	= 3


////////////////////
// PENALTY OBJECT //
////////////////////

penalty

/////////
// VAR //
/////////

penalty/var

	account/
		account		= null

	penalty_type	= PENALTY_NONE
	time			= 0							// time in seconds
	reason			= "No reason given."		// Reason should be a good one when making it.
	rank			= RANK_USER

	timer/
		update_timer= new(10,-1)

/////////////
// METHODS //
/////////////

penalty/proc

	SetType(N)
		penalty_type	= N

	SetTime(N)
		time			= N

	SetReason(T)
		reason			= T

	SetRank(N)
		rank			= N

	SetAccount(account/A)
		account			= A

/////////
// NEW //
/////////

/*
proc/CreatePenalty(T=PENALTY_MUTE, R="No Reason.", L=-1)
	var/penalty/n = new
	n.penalty_type 	= T
	n.reason		= R
	n.time			= L
	return n
*/

/////////
// DEL //
/////////


////////////
// UPDATE //
////////////

penalty/Update()
	if (time < 0)
		return
	else if (time > 0)
		time -= 1
		if (time == 0)
			del src

