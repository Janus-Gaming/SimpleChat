
/////////
// DEL //
/////////

client/Del()
	if (!flag_banned)

		Server_RemoveClient(src)
		Server_UpdateClientAmt()
		Server_RefreshUserlists()

		if (account)
			Server_Announce("[account.username] has left.")
			if (account.IsAuthed() && _flag_rebootissued == FALSE && _flag_shutdown == FALSE)
				SaveAccount(account)
				Server_Debug("Account '[account.id]' saved via client/Del()")
			else
				del account
		else
			Server_Announce("[key] has left.")

		DestroyTells()
		RemoveAccount()

	..()