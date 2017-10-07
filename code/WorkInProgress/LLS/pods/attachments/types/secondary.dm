/obj/item/weapon/pod_attachment/secondary
	icon_state = "attachment_secondary"
	hardpoint_slot = P_HARDPOINT_SECONDARY_ATTACHMENT
	keybind = P_ATTACHMENT_KEYBIND_MIDDLE

	GetAvailableKeybinds()
		return list(P_ATTACHMENT_KEYBIND_SHIFT, P_ATTACHMENT_KEYBIND_CTRL, P_ATTACHMENT_KEYBIND_ALT,
					P_ATTACHMENT_KEYBIND_MIDDLE, P_ATTACHMENT_KEYBIND_CTRLSHIFT)

	gimbal/
		name = "gimbal mount"
		overlay_icon_state = "gimbal"
		construction_cost = list("metal" = 4000, "uranium" = 2500, "silver" = 2500)
		origin_tech = "engineering=4;materials=4;combat=3"
		minimum_pod_size = list(2, 2)

	autoloader/
		name = "autoloader"
		power_usage = 20
		cooldown = 5
		construction_cost = list("metal" = 1500)
		origin_tech = "engineering=2"

		Use(var/atom/target, var/mob/user)
			if(!(..(target, user)))
				return 0

			if(!(target in bounds(attached_to, 1)))
				return 0

			var/obj/item/weapon/pod_attachment/cargo/cargo_hold = attached_to.GetAttachmentOnHardpoint(P_HARDPOINT_CARGO_HOLD)
			if(!cargo_hold)
				return 0

			if(istype(target, /obj/item))
				var/obj/item/I = target
				var/result = cargo_hold.PlaceInto(I)
				if(result != P_CARGOERROR_CLEAR)
					attached_to.PrintSystemAlert("\The [src] couldn't load \the [I], because [cargo_hold.TranslateError(result)]")

	bluespace_ripple/
		name = "outward bluespace ripple generator"
		overlay_icon_state = "ripple_generator"
		use_sound = 'sound/effects/phasein.ogg'
		power_usage = 3000
		cooldown = 300
		construction_cost = list("metal" = 4000, "uranium" = 2500, "silver" = 2500, "diamond" = 2500)
		origin_tech = "bluespace=4;magnets=4;programming=4;combat=4"
		minimum_pod_size = list(2, 2)
		var/range = 3
		var/inward = 0

		Use(var/atom/target, var/mob/user)
			if(!(..(target, user)))
				return 0

			var/turf/pod_turf = get_turf(attached_to)

			var/list/ranges = list()
			if(inward)
				for(var/i = range; i > 0; i--)
					ranges += i
			else
				for(var/i = 1; i <= range, i++)
					ranges += i

			for(var/i = 1; i <= range; i++)
				var/list/turfs = list()
				for(var/turf/T in attached_to.GetTurfsUnderPod())
					turfs += (turfs ^ circlerange(T, ranges[i]))

				for(var/turf/T in turfs)
					for(var/atom/movable/M in T)
						if(M.anchored)
							continue
						if(inward)
							step(M, get_dir(M, pod_turf))
						else
							step(M, get_dir(pod_turf, M))

				sleep(1)

		inward/
			name = "inward bluespace ripple generator"
			inward = 1

	smoke_screen/
		name = "smoke synthesizer"
		use_sound = 'sound/weapons/grenadelaunch.ogg'
		power_usage = 1000
		cooldown = 1200
		origin_tech = "engineering=2;materials=2"
		construction_cost = list("metal" = 4000, "silver" = 2500, "plasma" = 2500)

		Use(var/atom/target, var/mob/user)
			if(!(..(target, user)))
				return 0

			var/_x = attached_to.x, _y = attached_to.y, _z = attached_to.z, size = attached_to.size[1]
			var/list/corner_turfs = list(locate(_x - 1, _y + size, _z),
										locate(_x + size, _y + size, _z),
										locate(_x - 1, _y - 1, _z),
										locate(_x + size, _y - 1, _z))

			for(var/turf/T in corner_turfs)
				var/datum/effect/effect/system/harmless_smoke_spread/spread = new()
				spread.set_up(5, 0, T, 0)
				spread.start()

	wormhole_generator/
		name = "wormhole generator"
		overlay_icon_state = "wormhole_generator"
		power_usage = 500
		cooldown = 50
		construction_cost = list("metal" = 4000, "uranium" = 2500, "diamond" = 1500, "plasma" = 2500)
		origin_tech = "engineering=4;materials=4;bluespace=3"

		Use(var/atom/target, var/mob/user, var/flags = P_ATTACHMENT_PLAYSOUND | P_ATTACHMENT_IGNORE_POWER | P_ATTACHMENT_IGNORE_COOLDOWN)
			if(!(..(target, user, flags)))
				return 0

			if(attached_to.z == 2)
				return 0

			if(istype(target, /obj/effect/portal))
				var/obj/effect/portal/P = target
				P.teleport(attached_to)
				return 0

			if(last_use && ((last_use + cooldown) > world.time))
				return 0

			// Pretty much a copy of the hand-tele code, just made more readable.
			var/list/L = list(  )
			for(var/obj/machinery/teleport/hub/R in world)
				var/obj/machinery/computer/teleporter/com = locate(/obj/machinery/computer/teleporter, locate(R.x - 2, R.y, R.z))
				if (istype(com, /obj/machinery/computer/teleporter) && com.locked && !com.one_time_use)
					if(R.icon_state == "tele1")
						L["[com.id] (Active)"] = com.locked
					else
						L["[com.id] (Inactive)"] = com.locked
			var/list/turfs = list(	)
			for(var/turf/T in orange(10))
				if(T.x>world.maxx-8 || T.x<8)	continue	//putting them at the edge is dumb
				if(T.y>world.maxy-8 || T.y<8)	continue
				turfs += T
			if(turfs.len)
				L["None (Dangerous)"] = pick(turfs)
			var/t1 = input(user, "Please select a teleporter to lock in on.", "Hand Teleporter") in L
			if ((user.get_active_hand() != src || user.stat || user.restrained()))
				return
			var/count = 0	//num of portals from this teleport in world
			for(var/obj/effect/portal/PO in world)
				if(PO.creator == src)	count++
			if(count >= 3)
				user.show_message("<span class='notice'>\The [src] is recharging!</span>")
				return
			var/T = L[t1]
			for(var/mob/O in hearers(user, null))
				O.show_message("<span class='notice'>Locked In.</span>", 2)
			var/obj/effect/portal/P = new /obj/effect/portal( get_turf(src) )
			P.target = T
			P.creator = src

			return

	ore_collector/
		name = "ore collector"
		power_usage = 1
		power_usage_condition = P_ATTACHMENT_USAGE_ONTICK
		construction_cost = list("metal" = 2500)
		origin_tech = "engineering=1"

		GetAvailableKeybinds()
			return list()

		PodProcess(var/obj/pod/pod)
			if(!..())
				return 0

			var/obj/item/weapon/pod_attachment/cargo/cargo = pod.GetAttachmentOnHardpoint(P_HARDPOINT_CARGO_HOLD)
			if(!cargo)
				return 0

			var/list/turfs_below_pod = pod.GetTurfsUnderPod()
			for(var/turf/T in turfs_below_pod)
				for(var/obj/item/weapon/ore/ore in T)
					if(cargo.HasRoom())
						var/result = cargo.PlaceInto(ore)
						if(result != P_CARGOERROR_CLEAR)
							pod.PrintSystemAlert("\The [src] reports: [cargo.TranslateError(result)]. Shutting off.")
							active = P_ATTACHMENT_INACTIVE
							return 0

	seating_module/
		name = "seating module"
		active = P_ATTACHMENT_PASSIVE
		power_usage = 0
		power_usage_condition = P_ATTACHMENT_USAGE_ONUSE
		construction_cost = list("metal" = 3000)
		origin_tech = "engineering=1"
		var/seat_amount = 2 // Well this surely can't go wrong

		examine()
			..()
			usr << "<span class='info'>The tag says it adds [seat_amount] new seat(s).</span>"

		GetAvailableKeybinds()
			return list()

		OnAttach(var/obj/pod/pod, var/mob/user)
			..()
			pod.seats += seat_amount

		OnDetach(var/obj/pod/pod, var/mob/user)
			..()
			pod.seats -= seat_amount

		// Pshhhh
		bluespace/
			name = "bluespace seating module"
			seat_amount = 6

	ejection_seats/
		name = "ejection seats"
		active = P_ATTACHMENT_PASSIVE
		power_usage = 0
		power_usage_condition = P_ATTACHMENT_USAGE_ONUSE
		construction_cost = list("metal" = 5000, "plasma" = 2000)
		origin_tech = "engineering=2;materials=2"
		var/exclude_pilot = 0

		GetAdditionalMenuData()
			var/dat = "Exclude Pilot: <a href='?src=\ref[src];action=toggle_exclude_pilot'>[exclude_pilot ? "Yes" : "No"]</a>"
			return dat

		Topic(href, href_list)
			..()

			if(href_list["action"] == "toggle_exclude_pilot")
				exclude_pilot = !exclude_pilot
				usr << "<span class='info'>The pilot is now [exclude_pilot ? "excluded" : "included"].</span>"

		Use(var/atom/target, var/mob/user, var/flags = P_ATTACHMENT_PLAYSOUND | P_ATTACHMENT_IGNORE_POWER | P_ATTACHMENT_IGNORE_COOLDOWN)
			if(!(..(target, user, flags)))
				return 0

			var/datum/effect/effect/system/harmless_smoke_spread/system = new()
			system.set_up(5, 0, get_turf(attached_to))
			system.start()

			for(var/mob/living/L in attached_to.GetOccupants())
				if(L == attached_to.pilot)
					if(exclude_pilot)
						continue
					attached_to.pilot = 0
				L.loc = pick(attached_to.GetDirectionalTurfs(attached_to.dir))
				spawn()
					for(var/i in 1 to 5)
						step(L, attached_to.dir)
						sleep(1)
				sleep(3)

			attached_to.attachments -= src
			attached_to.update_icon()

			qdel(src)

	mech_storage/
		name = "mech storage"
		active = P_ATTACHMENT_PASSIVE
		power_usage = 0
		power_usage_condition = P_ATTACHMENT_USAGE_ONUSE
		construction_cost = list("metal" = 6000)
		origin_tech = "engineering=1;materials=1"

		var/obj/mecha/stored_mech = 0

		GetAvailableKeybinds()
			return list()

		PodHandleDropAction(var/atom/movable/dropping, var/mob/living/user)
			if(!stored_mech && istype(dropping, /obj/mecha))
				var/obj/mecha/mech = dropping
				if(mech.occupant)
					user << "<span class='warning'>The mech has to be unoccupied.</span>"
					return 0

				user << "<span class='info'>You start loading the mech into the pod, this may take a while.</span>"
				var/turf/mech_turf = get_turf(mech)
				if(do_after(user, 100))
					if(!mech)
						return 0
					if(get_turf(mech) != mech_turf)
						return 0
					if(mech.occupant)
						return 0

					user << "<span class='info'>You load the mech into the pod.</span>"

					mech.loc = src
					stored_mech = mech

					return 1

		GetAdditionalMenuData()
			var/dat = "Stored Mech: [stored_mech ? "<a href='?src=\ref[src];action=release_mech'>Release</a>" : "None."]"
			return dat

		Topic(href, href_list)
			..()

			if(href_list["action"] == "release_mech")
				if(!stored_mech)
					return 0

				usr << "<span class='info'>You release the mech.</span>"
				stored_mech.loc = get_turf(attached_to)