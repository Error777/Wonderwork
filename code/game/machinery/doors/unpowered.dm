/obj/machinery/door/unpowered
	autoclose = 0
	var/locked = 0


	Bumped(atom/AM)
		if(src.locked)
			return
		..()
		return


	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/weapon/card/emag)||istype(I, /obj/item/weapon/melee/energy/blade))	return
		//if(src.locked)	return // Hahaha no!
		..()
		return



/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "shuttle door"
	icon_state = "door1"
	opacity = 1
	density = 1

/obj/machinery/door/unpowered/shuttle/black
	icon = 'icons/turf/shuttle.dmi'
	name = "shuttle door(BUG)"
	icon_state = "gdoor1"