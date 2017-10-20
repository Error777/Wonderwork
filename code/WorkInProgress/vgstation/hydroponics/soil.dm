/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	icon = 'icons/obj/hydroponics/hydroponics.dmi'
	icon_state = "soil"
	density = 0
	use_power = 0
	draw_warnings = 0

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/weapon/shovel))
		if(!seed)
			user << "You clear up [src]!"
			new /obj/item/weapon/ore/glass(loc)//we get some of the dirt back
			new /obj/item/weapon/ore/glass(loc)
			del(src)
			return 1
		else
			..()
	else
		return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/New()
	..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/set_label
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/light_toggle
	component_parts = list()

/obj/machinery/portable_atmospherics/hydroponics/soil/grass //Not actually hydroponics at all! Honk!
	name = "dirt"
	icon_state = "dirtwip1"
