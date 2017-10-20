/mob/dead/observer/DblClick(var/atom/A, var/params)
	if(can_reenter_corpse && mind && mind.current)
		if(A == mind.current || (mind.current in A)) // double click your corpse or whatever holds it
			reenter_corpse()						// (cloning scanner, body bag, closet, mech, etc)
			return

	// Things you might plausibly want to follow
	if(istype(A,/atom/movable))
		ManualFollow(A)
	// Otherwise jump
	else
		following = null
		forceMove(get_turf(A))

/mob/dead/observer/Click(var/atom/A, var/params)

	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		ShiftClick(A)
		return
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)