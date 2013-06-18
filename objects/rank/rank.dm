
///////////
// CONST //
///////////

var/const

	RANK_HOST		= 2
	RANK_OP			= 1
	RANK_USER		= 0


/////////////////
// RANK OBJECT //
/////////////////

rank

//////////
// 	VAR //
//////////

rank/var

	name			= "Unnamed"
	value			= 0
	offset			= 0
	max_offset		= 24
	next_rank		= null
	prev_rank		= null

	list/
		commands	= list()