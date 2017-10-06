
/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""

//print an error message to world.log
/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"

//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"


/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			C << "DEBUG: [text][log_end]"


/proc/log_game(text)
	if (config.log_game)
		diary << "\[[time_stamp()]]GAME: [text][log_end]"

/proc/log_vote(text)
	if (config.log_vote)
		diary << "\[[time_stamp()]]VOTE: [text][log_end]"

/proc/log_access(text)
	if (config.log_access)
		diary << "\[[time_stamp()]]ACCESS: [text][log_end]"

/proc/log_say(text)
	if (config.log_say)
		diary << "\[[time_stamp()]]SAY: [text][log_end]"

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << "\[[time_stamp()]]OOC: [text][log_end]"

/proc/log_looc(text)
	if (config.log_looc)
		diary << "\[[time_stamp()]]LOOC: [text][log_end]"

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << "\[[time_stamp()]]WHISPER: [text][log_end]"

/proc/log_emote(text)
	if (config.log_emote)
		diary << "\[[time_stamp()]]EMOTE: [text][log_end]"

/proc/log_attack(text)
	if (config.log_attack)
		diary << "\[[time_stamp()]]ATTACK: [text][log_end]" //Seperate attack logs? Why?

/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << "\[[time_stamp()]]ADMINSAY: [text][log_end]"

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << "\[[time_stamp()]]ADMINWARN: [text][log_end]"

/proc/log_pda(text)
	if (config.log_pda)
		diary << "\[[time_stamp()]]PDA: [text][log_end]"

/**
 * Standardized method for tracking startup times.
 */
/proc/log_startup_progress(var/message)
	to_chat(world, "<span class='danger'>[message]</span>")
	world.log << message