var/mob/dview/dview_mob = new

//Version of view() which ignores darkness, because BYOND doesn't have it.
/proc/dview(var/range = world.view, var/center, var/invis_flags = 0)
	if(!center)
		return

	dview_mob.loc = center

	dview_mob.see_invisible = invis_flags

	. = view(range, dview_mob)
	dview_mob.loc = null

/mob/dview
	invisibility = 101
	density = 0

	anchored = 1

	see_in_dark = 1e6

/atom/proc/get_light_and_color(var/atom/origin)
	if(origin)
		color = origin.color
		set_light(origin.light_range, origin.light_power, origin.light_color)

/mob/dview/New()
	..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	mob_list -= src
	if(stat == DEAD)
		dead_mob_list -= src
	else
		living_mob_list -= src