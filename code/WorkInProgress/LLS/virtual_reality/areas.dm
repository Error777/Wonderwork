/*
* Areas
*/

/area/virtual_reality
	name = "virtual reality"
	icon_state = "red2"

	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

	// This is here so it is available at this scope.

	// Items not allowed to take out of the thunderdome.
	var/list/thunderdome_items = list(/obj/item/weapon/melee/energy/sword, /obj/item/weapon/melee/baton, /obj/item/weapon/gun/energy/laser,	\
									/obj/item/clothing/suit/armor/tdome, /obj/item/clothing/head/helmet/thunderdome, /obj/item/clothing/head/helmet/swat, \
									/obj/item/clothing/suit/armor/vest, /obj/item/weapon/twohanded/dualsaber)

	// Items not allowed to take out of the perseus start area.

	// Forbidden items to take out of the firing range.
	var/list/forbidden_range_items = list(/obj/item/weapon/gun/energy, /obj/item/target)

	Exited(var/atom/movable/A, var/atom/new_loc)
		if(isliving(A))
			var/mob/living/L = A

			if(!istype(get_area(L), /area/virtual_reality))
				message_admins("\red VR: [key_name(L, 1)] left the virtual reality area. (Teleported back)")
				log_game("VR: [key_name(L)] left the virtual reality area. (Teleported back)")

				..(L, new_loc)

				spawn(0)	L.loc = safepick(get_area_turfs(vr_controller.crew_destination))

				return 0

		..(A, new_loc)

	// All the Entered() overrides are to prevent people from throwing items to another area to bypass the Exit restriction.
	Entered(var/atom/movable/M, var/atom/old_loc)
		for(var/x in thunderdome_items)
			if(istype(M, x))
				del(M)

		if(istype(get_area(old_loc), /area/virtual_reality/firing_range))
			for(var/y in forbidden_range_items)
				if(istype(M, y))
					del(M)

		..(M, old_loc)

		return 1


	start_crew/
		name = "virtual reality - crew start"
		icon_state = "blue2"

	start_perseus/
		name = "virtual reality - perseus start"
		icon_state = "blue-red2"

	creative_suite/
		name = "virtual reality - creative suite area"
		icon_state = "blueold"

	thunderdome/
		name = "virtual reality - thunderdome"
		icon_state = "dark128"

		// Removes the thunder-dome items when leaving the area.
		Exited(var/atom/movable/A, var/atom/new_loc)
			..()

			if(isliving(A))
				var/mob/living/L = A
				if(!istype(get_area(new_loc), src))
					L << "\blue Removing thunderdome items..."
					for(var/obj/item/I in L.get_contents())
						for(var/_type in thunderdome_items)
							if(istype(I, _type))
								L.u_equip(I, 1)
								del(I)

		Enter(var/atom/movable/O, var/atom/oldloc)
			// Get (stay) out of here.
			if(istype(O, /obj/structure/stool/bed/chair/janicart))
				return 0

			return 1

	firing_range/
		icon_state = "dark"
		name = "virtualy reality - firing range"