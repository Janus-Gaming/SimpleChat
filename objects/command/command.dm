
////////////////////
// COMMAND OBJECT //
////////////////////

command
	parent_type	= /datum

///////////
// CONST //
///////////

/////////
// VAR //
/////////

command/var

	name		= "Untitled Command"
	desc		= ""
	format		= "/cmd"
	args_amt	= 0
	list/
		ids		= list()
	req			= 0
	req2		= 0

//////////
// PROC //
//////////

command/proc

	Use(client/C)
		Server_Notify(C,"The command \"[name]\" is not implemented yet.")
		return TRUE