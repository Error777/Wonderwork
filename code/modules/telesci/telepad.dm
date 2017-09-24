///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	light_color = LIGHT_COLOR_PINK
	anchored = 1
	use_power = 1
	light_power_on = 1
	light_range_on = 3
	idle_power_usage = 200
	active_power_usage = 5000

/obj/machinery/telepad/New()
	sleep(4)
	set_light(light_range_on,light_power_on)

/obj/machinery/telepad/power_change()
	if ( powered() )
		stat &= ~NOPOWER
		src.set_light(light_range_on,light_power_on)
	else
		stat |= ~NOPOWER
		src.set_light(0)