#define CURTAIN_OPEN_LAYER OBJ_LAYER + 0.4
#define CURTAIN_CLOSED_LAYER MOB_LAYER + 0.2

/obj/structure/curtain
	name = "curtain"
	icon = 'icons/obj/curtain.dmi'
	icon_state = "curtain_closed"
	layer = CURTAIN_OPEN_LAYER
	opacity = 1
	density = 0

/obj/structure/curtain/open
	icon_state = "curtain_open"
	layer = CURTAIN_CLOSED_LAYER
	opacity = 0

/obj/structure/curtain/bullet_act(var/obj/item/projectile/Proj)
	del(src)

/obj/structure/curtain/ex_act(severity)
	del(src)

/obj/structure/curtain/blob_act()
	del(src)

/obj/structure/curtain/meteorhit()
	del(src)

/obj/structure/curtain/attack_paw(mob/user as mob)
	attack_hand(user)

/obj/structure/curtain/attack_hand(mob/user as mob)
	opacity = !opacity
	if(opacity)
		flick("curtain_closing", src)
		icon_state = "curtain_closed"
		layer = CURTAIN_CLOSED_LAYER
		sleep(10)
	else
		flick("curtain_opening", src)
		icon_state = "curtain_open"
		layer = CURTAIN_OPEN_LAYER
		sleep(10)
	return

/obj/structure/curtain/black
	name = "black curtain"
	color = "#282828"

/obj/structure/curtain/yellow
	name = "yellow curtain"
	color = "#E8CC3A"

/obj/structure/curtain/red
	name = "red curtain"
	color = "#930200"

/obj/structure/curtain/blue
	name = "blue curtain"
	color = "#282E70"

/obj/structure/curtain/indigo
	name = "indigo curtain"
	color = "#BF118D"

/obj/structure/curtain/green
	name = "green curtain"
	color = "#397C3A"

/obj/structure/curtain/cyan
	name = "cyan curtain"
	color = "#189692"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 1500)
		del(src)

#undef CURTAIN_OPEN_LAYER
#undef CURTAIN_CLOSED_LAYER