/*#define GLOW_GREEN "#00FF00"
#define GLOW_RED "#FF0000"
#define GLOW_BLUE "#0000FF"

/obj/item/weapon/glowstick
	name = "glowstick"
	desc = "A plastic stick filled with luminescent liquid, this one is green."
	color = GLOW_GREEN
	icon = 'icons/obj/weapons.dmi'
	icon_state = "glowstick"
	var/on = 0
	light_color = GLOW_GREEN
	w_class = 2

	suicide_act(mob/user)
		viewers(user) << "<span class='danger'>[user] is breaking open the [src.name] and eating the liquid inside! It looks like \he's  trying to commit suicide!</span>"
		return (TOXLOSS)


/obj/item/weapon/glowstick/New()
	. = ..()
	set_light(2, l_color = light_color)user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)

/obj/item/weapon/glowstick/initialize()
	..()
	if (on)
		icon_state = "[initial(icon_state)]-on"
		src.ul_SetLuminosity(brightness_on, brightness_on, 0)
	else
		icon_state = initial(icon_state)
		src.ul_SetLuminosity(0)

/obj/item/weapon/glowstick/proc/update_brightness(var/mob/user)
	if (on)
		icon_state = "[initial(icon_state)]-on"
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed + brightness_on, user.LuminosityGreen + brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(brightness_on, brightness_on, 0)

	else
		icon_state = initial(icon_state)
		if(src.loc == user)
			user.ul_SetLuminosity(user.LuminosityRed - brightness_on, user.LuminosityGreen - brightness_on, user.LuminosityBlue)
		else if (isturf(src.loc))
			ul_SetLuminosity(0)


/obj/item/weapon/glowstick/attack_self(mob/user)
	if(!isturf(user.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	update_brightness(user)
	return 1







#undef GLOW_GREEN
#undef GLOW_RED
#undef GLOW_BLUE*/