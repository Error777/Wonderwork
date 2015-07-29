var/list/cargo_pads = list()

/obj/machinery/cargopad
	name = "Cargo Pad"
	desc = "Used to recieve objects transported by a Cargo Transporter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "tpad"
	var/id = null
	var/active = 1
	anchored = 1

	New()
		..()
		cargo_pads ^= src

	attack_hand(var/mob/user as mob)
		if (src.active == 1)
			user << "You switch the reciever off."
			icon_state = "cpad"
			src.active = 0
		else
			user << "You switch the reciever on."
			icon_state = "tpad"
			src.active = 1

/obj/item/weapon/cargotele
	name = "Cargo Transporter"
	desc = "A device for teleporting crated goods."
	icon = 'icons/obj/items.dmi'
	icon_state = "cargotele"
	item_state = "gun"
	var/charges = 10
	var/maximum_charges = 10
	var/robocharge = 250
	var/target = null
	force = 5
	w_class = 3
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	origin_tech = "magnets=5;bluespace=4;materials=2"

	attack_self() // Fixed --melon
		if (src.charges < 1)
			usr << "\red The transporter is out of charge."
			return
		var/list/pads = list()
		for(var/obj/machinery/cargopad/A in cargo_pads)
			if (!A.active) continue
			// I suspect it's not consulting the user because it's a list of locations, I cant be sure though --- You're right, so I made this a list of pads.
			pads += A
		if (!pads.len) usr << "\red No recievers available."
		else
		//here i set up an empty var that can take any object, and tell it to look for absolutely anything in the list
			var/selection = input("Select Cargo Pad Location:", "Cargo Pads", null, null) as null|anything in pads
			if(!selection)
				return
			var/turf/T = get_turf(selection)
			//get the turf of the pad itself
			if (!T)
				usr << "\red Target not set!"
				return
			usr << "Target set to [T.loc]."
			//blammo! works!
			src.target = T

	/*proc/cargoteleport(var/obj/T, var/mob/user)
		if (!src.target)
			user << "\red You need to set a target first!"
			return
		if (src.charges < 1)
			user << "\red The transporter is out of charge."
			return
		if (istype(user,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			if (R.cell.charge < src.robocharge)
				user << "\red There is not enough charge left in your cell to use this."
				return
		user << "Teleporting [T]..."
		playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 50))
			do_teleport(T, target, 1)
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src)
			spark_system.start()
			if (istype(user,/mob/living/silicon/robot))
				var/mob/living/silicon/robot/R = user
				R.cell.charge -= src.robocharge
			else
				src.charges -= 1
				src.desc = "A device for teleporting crated goods. [src.charges] charges remain."
				user << "[src.charges] charges remain."
		return*/

	afterattack(var/obj/T as obj, mob/user as mob)
		if (!src.target)
			user << "\red You need to set a target first!"
			return
		if (src.charges < 1)
			user << "\red The transporter is out of charge."
			return

		if(!istype(T))	//this really shouldn't be necessary (but it is).	-Pete
			return
		if(istype(T, /obj/structure/table) || istype(T, /obj/structure/rack) \
		|| istype(T, /obj/item/smallDelivery) || istype(T,/obj/structure/bigDelivery) \
		|| istype(T, /obj/item/weapon/gift) || istype(T, /obj/item/weapon/evidencebag))
			return
		if(T.anchored)
			return
		if(T in user)
			return
		if (istype(user,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			if (R.cell.charge < src.robocharge)
				user << "\red There is not enough charge left in your cell to use this."
				return
		if (istype(T, /obj/structure/closet/crate))
			user << "Teleporting [T]..."
			playsound(user.loc, 'sound/machines/click.ogg', 50, 1)
			if(do_after(user, 50))
				do_teleport(T, target, 0)
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, src)
				spark_system.start()
				if (istype(user,/mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= src.robocharge
				else
					src.charges -= 1
			return