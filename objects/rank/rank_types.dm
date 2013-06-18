
////////////////
// RANK TYPES //
////////////////

rank

	host
		name		= "Administrator"
		value		= RANK_HOST
		prev_rank	= /rank/operator

	operator
		name		= "Operator"
		value		= RANK_OP
		next_rank	= /rank/host
		prev_rank	= /rank/user

	user
		name		= "User"
		value		= RANK_USER
		next_rank	= /rank/operator
