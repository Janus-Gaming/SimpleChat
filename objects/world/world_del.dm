
/////////
// DEL //
/////////

world/Del()
	_flag_shutdown = TRUE
	Server_Announce("Server is shutting down...")

		// Save world settings
	Server_SaveSettings()
	..()

