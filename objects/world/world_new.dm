
////////////
// REBOOT //
////////////

world/Reboot()
	_flag_rebootissued = TRUE
	Server_SaveAccounts()
	sleep(10)
	..()


/////////
// NEW //
/////////

world/New()
	..()
		// load all commands
	for (var/d in typesof(/command))
		var/command/c = new d
		_commands += c

		// load all modules
	for (var/d in typesof(/module))
		var/module/m = new d
		_modules += m

		// load all settings
	Server_LoadSettings()

		// load all accounts
	Server_LoadAccounts()


	spawn() GameLoop()

///////////////
// GAME LOOP //
///////////////

proc/GameLoop()
	while(_flag_rebootissued == FALSE)
		_time.Update()

		for (var/client/C in _clients)
			C.Update()

		for (var/code/C in _codes)
			C.Update()

		for (var/account/A in _accounts)
			A.Update()

		_update_timer.Update()
		_update_timer.Event_TimeUp()

		_status_timer.Update()
		if (_status_timer.Event_TimeUp())
			Server_SetStatus("[_channelname] - [_clients_amt] clients ([_display_version])")
			Server_UpdateClientAmt()

		sleep(world.tick_lag)


	if (_flag_rebootissued)
		world.Reboot()