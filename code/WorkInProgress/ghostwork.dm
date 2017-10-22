/mob/proc/ClickOn(var/atom/A, var/params)
	Click(A,params)
	return

/mob/proc/DblClickOn(var/atom/A, var/params)
	ClickOn(A,params)
	return


/mob/dead/observer/DblClickOn(var/atom/A, var/params)
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return

	// Things you might plausibly want to follow
	if(istype(A,/atom/movable))
		ManualFollow(A)
	// Otherwise jump
	else
		forceMove(get_turf(A))
		following = null

/mob/dead/observer/ClickOn(var/atom/A, var/params)
	A.attack_ghost(src)
	return
