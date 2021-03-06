/var/global/achivements_unlocked = 0

/mob/proc/unlock_achievement(title, announce = 1)
	if(!title)
		return
	if(!src.client || !src.key)
		return
	if(IsGuestKey(src.key))
		return
	if(!config)
		return
	if(!config.achievement_hub || !config.achievement_password)
		return

	spawn ()
		var/result = world.SetMedal(title, src.key, config.achievement_hub, config.achievement_password)

		if(result == 1)
			if(announce)
				world << "<span class=notice>[key] earned the [title] achievement.</span>"
				achivements_unlocked += 1
			else if(ismob(src) && src.client)
				src << "<span class=notice>You earned the [title] achievement.</span>"
		else if(isnull(result) && ismob(src) && src.client)
			src << "\red You would have earned the \[[title]] achievement, but there was an error communicating with the BYOND hub."
	return

/mob/proc/startofsomething(title, announce = 1)
	if(!title)
		return
	if(!src.client || !src.key)
		return
	if(IsGuestKey(src.key))
		return
	if(!config)
		return
	if(!config.achievement_hub || !config.achievement_password)
		return

	spawn ()
		var/result = world.SetMedal(title, src.key, config.achievement_hub, config.achievement_password)

		if(result == 1)
			if(announce)
				world << "<span class=notice>[key] earned the [title] achievement.</span>"
				achivements_unlocked += 1
				src << "<span class=notice>Welcome to FPStation. As this is your first time here, please look to the upper top right of the screen. Hit the MAP button to get a detailed map of the station, and hit the RULES button to read our rules.</span>"
		else if(isnull(result) && ismob(src) && src.client)
			src << "\red You would have earned the \[[title]] achievement, but there was an error communicating with the BYOND hub."
	return


/mob/proc/addscore()
	if(!src.client || !src.key)
		return
	if(IsGuestKey(src.key))
		return
	if(!config)
		return
	if(!config.achievement_hub || !config.achievement_password)
		return

	spawn ()
		var/result = world.SetScores(src.key, "Completed Rounds" = 1 , config.achievement_hub, config.achievement_password)

		if(result == 1)
			world << "<span class=notice>Test.</span>"





//This is a verb for players, currenty hidden.
/mob/verb/list_achievements()
	set name = "Achievements"
	set category = "OOC"
	//set hidden = 1

	if(IsGuestKey(src.key))
		src << "\red Guests are unable to save achievements."
		return
	else if(!config)
		src << "\red Error, achievement config failure A."
		return
	else if(!config.achievement_hub || !config.achievement_password)
		src << "\red Error, achievement settings failure B."
		return

	src << "Retrieving your achievements."

	spawn()
		var/achievements = world.GetMedal("", src.key, config.achievement_hub, config.achievement_password)

		if(isnull(achievements))
			src << "\red Unable to contact the BYOND hub."
			return

		if(!achievements)
			src << "<b>No achievements detected.</b>"
			return

		achievements = params2list(achievements)
		achievements = sortList(achievements)

		src << "<b>Achievements:</b>"
		for (var/achievement in achievements)
			src << "\t[achievement]"
		src << "<b>You have [length(achievements)] achievement\s.</b>"



//Can be used to check if a mob has a certain achievement
//Will return 0 or null if failed, 1 if they have it
//This does NOT use spawn and might take a bit to process
/mob/proc/check_achievement(title, key)
	if(!title || !key)
		return 0
	if(!src.client || !src.key)
		return 0
	if(IsGuestKey(src.key))
		return 0
	if(!config)
		return 0
	if(!config.achievement_hub || !config.achievement_password)
		return 0
	return world.GetMedal(title, key, config.achievement_hub, config.achievement_password)


/proc/give_achievement(title, announce = 1)
	if(!config)
		return
	if(!config.achievement_hub || !config.achievement_password)
		return
	var/client/target
	var/list/keys = list()
	for(var/client/C)
		keys += C
	target = input("Please, select a player!", "Selection", null, null) as null|anything in keys
	if(target)
		title = input("What is the name of the achievement","Selection", null, null)

	spawn ()
		var/result = world.SetMedal(title, target, config.achievement_hub, config.achievement_password)
		if(result == 1)
			if(announce)
				world << "<span class=notice>[target] earned the [title] achievement.</span>"
				achivements_unlocked += 1
				//target.givepoint()
			else if(ismob(target.mob) && target)
				src << "<span class=notice>You earned the [title] achievement.</span>"
		else if(isnull(result) && ismob(target.mob) && target)
			src << "\red You would have earned the \[[title]] achievement, but there was an error communicating with the BYOND hub."
	return
