/obj/item/device/bombassembly
	name = "bomb assembly"
	desc = "A holder for explosive materials."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "bombassembly00"
	flags = FPRINT | TABLEPASS| CONDUCT
	item_state = "electronic"
	w_class = 2.0
	m_amt = 100
	g_amt = 0
	w_amt = 0
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = "magnets=1"

	var/obj/item/weapon/ore/gem/coronium/coro1
	var/obj/item/weapon/ore/gem/coronium/coro2
	var/timer = 15
	var/ready = 0
	var/timing = 0

	var/atom/target = null

	done
		name = "coronium two-component bomb"
		icon_state = "bombassembly11"

		New()
			coro1 = new(src)
			coro2 = new(src)
			ready = 1
			update_icon()

/obj/item/device/bombassembly/update_icon()
	icon_state = "bombassembly[coro2 != null][coro1 != null]"

/obj/item/device/bombassembly/attackby(obj/item/item, mob/user)
	if(!item || timing)
		return

	if(istype(item, /obj/item/weapon/ore/gem/coronium))
		if(coro1 && coro2)
			user << "<span class='warning'>There are already two pieces of coronium attached.</span>"
			return

		if(!coro1)
			coro1 = item
			user.drop_item()
			item.loc = src
			user << "<span class='notice'>You attach the [item] to the assembly.</span>"
		else if(!coro2)
			coro2 = item
			user.drop_item()
			item.loc = src
			user << "<span class='notice'>You attach the [item] to the assembly.</span>"

		update_icon()

	else if(istype(item, /obj/item/weapon/screwdriver))
		if(coro1 && coro2 && !ready)
			ready = 1
			name = "coronium two-component bomb"
			user << "<span class='notice'>You ready the assembly.</span>"

/obj/item/device/bombassembly/attack_self(mob/user as mob)
	if (!ready)
		return

	if (timing)
		user << "<span class='warning'>You push the two halves together!</span>"
		user.visible_message("\red [user.name] pushes the bomb assembly together! It looks like \he's trying to commit suicide!")
		icon_state = "bombassemblyXX"

		spawn(3)
			var/turf/T = get_turf(src)

			if(T)
				explosion(T, 1, 3, 5, 12)
				if (src)
					del(src)

		return

	user << "You activate the assembly. Timer counting down from [timer]."
	log_admin("[user] ([user.ckey]) has activated a [src].")
	message_admins("[user] ([user.ckey]) activated a [src].")

	timing = 1

	spawn(timer*9.9)
		icon_state = "bombassemblyXX"

		sleep(3)

		var/turf/T = get_turf(src)

		if(T)
			explosion(T, 1, 3, 5, 12)
			if (src)
				del(src)


/obj/item/device/bombassembly/afterattack(atom/target as obj|turf, mob/user as mob, flag)
	if (!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage/) || ismob(target))
		return
	if (!ready || timing)
		return
	user << "Attaching assembly..."
/*	if(ismob(target))
		user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] tried planting [name] on [target:real_name] ([target:ckey])</font>"
		user.visible_message("\red [user.name] is trying to plant some kind of explosive on [target.name]!")	*/
	if(do_after(user, 20) && in_range(user, target))
		user.drop_item()
		target = target
		loc = null
		timing = 1
		var/location
		if (isturf(target)) location = target
		if (isobj(target)) location = target.loc
		target.overlays += image('icons/obj/assemblies.dmi', "bombassembly11")
		log_admin("[user] ([user.ckey]) has planted a [src].")
		message_admins("[user] ([user.ckey]) planted a [src].")
		user << "Assembly has been attached. Timer counting down from [timer]."
		spawn(timer*10)
			if(target)
				explosion(location, 1, 3, 5, 12)
				if (src)
					del(src)