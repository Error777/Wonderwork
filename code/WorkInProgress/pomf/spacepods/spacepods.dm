// honk
/obj/spacepod
	name = "\improper space pod"
	desc = "A space pod meant for space travel."
	icon = 'icons/48x48/pods.dmi'
	density = 1 //Dense. To raise the heat.
	opacity = 0
	anchored = 1
	unacidable = 1
	layer = 3.9
	infra_luminosity = 15
	inertia_dir = 0
	var/destroyed = 0
	var/health = 300
	var/empstun = 0
	var/mob/living/carbon/occupant
	var/mob/living/carbon/passenger
	var/datum/spacepod/equipment/equipment_system
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/obj/item/weapon/cell/battery
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/effect/effect/system/ion_trail_follow/space_trail/ion_trail
	var/use_internal_tank = 0
	var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature
	var/datum/global_iterator/pr_give_air //moves air from tank to cabin
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
	var/datum/radio_frequency/radio_connection
	var/frequency = 6666
	var/hatch_open = 0
	var/next_firetime = 0
	var/id_tag
	var/master_tag = "SP_airlock"
	var/command = "cycle"
	var/list/cargo =list()

/obj/spacepod/New()
	bound_width = 64
	bound_height = 64
	battery = new /obj/item/weapon/cell/high
	add_cabin()
	add_airtank()
	src.ion_trail = new /datum/effect/effect/system/ion_trail_follow/space_trail()
	src.ion_trail.set_up(src)
	src.ion_trail.start()
	src.use_internal_tank = 1
	pr_int_temp_processor = new /datum/global_iterator/pod_preserve_temp(list(src))
	pr_give_air = new /datum/global_iterator/pod_tank_give_air(list(src))
	equipment_system = new(src)
	verbs += /obj/spacepod/proc/toggle_lights
	if(frequency == 6666)
		verbs += /obj/spacepod/proc/Open_external
	if(frequency == 5555)
		verbs += /obj/spacepod/proc/Open_Syn_external
	if(frequency == 4444)
		verbs += /obj/spacepod/proc/Open_ninja_external
	if(radio_controller)
		set_frequency(frequency)
	processing_objects |= src

/obj/spacepod/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)
/obj/spacepod/HasProximity(atom/movable/AM as mob|obj)
	return
/obj/spacepod/attackby(obj/item/W as obj, mob/user as mob)
	if(destroyed)
		return
	if(iscrowbar(W))
		hatch_open = !hatch_open
		user << "<span class='notice'>You [hatch_open ? "open" : "close"] the maintenance hatch.</span>"
	if(istype(W, /obj/item/weapon/cell))
		if(!hatch_open)
			return ..()
		if(battery)
			user << "<span class='notice'>The pod already has a battery.</span>"
			return
		user.drop_item(W)
		battery = W
		W.loc = src
		return
	if(istype(W, /obj/item/weapon/weldingtool) && user.a_intent != "hurt")
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.welding)
			return
		if(src.health<initial(src.health))
			WT.remove_fuel(2,user)
			user << "\blue You repair some damage to [src.name]."
			src.health += min(10, initial(src.health)-src.health)
		else
			user << "The [src.name] is at full integrity"
		return
	if(istype(W, /obj/item/device/spacepod_equipment))
		if(!hatch_open)
			return ..()
		if(!equipment_system)
			user << "<span class='warning'>The pod has no equipment datum, yell at pomf</span>"
			return
		if(istype(W, /obj/item/device/spacepod_equipment/weaponry))
			if(equipment_system.weapon_system)
				user << "<span class='notice'>The pod already has a weapon system, remove it first.</span>"
				return
			else
				user << "<span class='notice'>You insert \the [W] into the equipment system.</span>"
				user.drop_item(W)
				W.loc = equipment_system
				equipment_system.weapon_system = W
				verbs += /obj/spacepod/proc/fire_weapons
				return

/obj/spacepod/attack_hand(mob/user as mob)
	if(destroyed)
		return
	if(!hatch_open)
		return ..()
	if(!equipment_system || !istype(equipment_system))
		user << "<span class='warning'>The pod has no equpment datum, or is the wrong type, yell at pomf.</span>"
		return
	var/list/possible = list()
	if(battery)
		possible.Add("Energy Cell")
	if(equipment_system.weapon_system)
		possible.Add("Weapon System")
	/* Not yet implemented
	if(equipment_system.engine_system)
		possible.Add("Engine System")
	if(equipment_system.shield_system)
		possible.Add("Shield System")
	*/
	var/obj/item/device/spacepod_equipment/SPE
	switch(input(user, "Remove which equipment?", null, null) as null|anything in possible)
		if("Energy Cell")
			if(user.put_in_any_hand_if_possible(battery))
				user << "<span class='notice'>You remove \the [battery] from the space pod</span>"
				battery = null
		if("Weapon System")
			SPE = equipment_system.weapon_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				equipment_system.weapon_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
		/*
		if("engine system")
			SPE = equipment_system.engine_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				equipment_system.engine_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
		if("shield system")
			SPE = equipment_system.shield_system
			if(user.put_in_any_hand_if_possible(SPE))
				user << "<span class='notice'>You remove \the [SPE] from the equipment system.</span>"
				equipment_system.shield_system = null
			else
				user << "<span class='warning'>You need an open hand to do that.</span>"
		*/

	return

/obj/spacepod/civilian
	icon_state = "pod_civ"
	desc = "A sleek civilian space pod."
/obj/spacepod/black
	icon_state = "pod_black"
	desc = "An all black space pod with no insignias."
	frequency = 4444
/obj/spacepod/nanomil
	icon_state = "pod_mil"
	desc = "A dark grey space pod brandishing the Nanotrasen Military insignia"
/obj/spacepod/syndicate
	icon_state = "pod_synd"
	desc = "A menacing military space pod with Fuck NT stenciled onto the side"
	frequency = 5555
/obj/spacepod/gold
	icon_state = "pod_gold"
	desc = "A civilian space pod with a gold body, must have cost somebody a pretty penny"

/obj/spacepod/clown
	icon_state = "pod_clown"
	desc = "A civilian space pod with a purple and blue body with a bannana hanging in its window."
/obj/spacepod/clown/New()
	..()
	var/obj/item/device/spacepod_equipment/weaponry/clown/W = new /obj/item/device/spacepod_equipment/weaponry/clown
	W.loc = equipment_system
	equipment_system.weapon_system = W
	verbs += /obj/spacepod/proc/fire_weapons
/obj/spacepod/indy
	icon_state = "pod_industrial"
	desc = "A rough looking space pod meant for industrial work"
/obj/spacepod/fighter
	icon_state = "pod_skin3"
	desc = "A civilian space pod modeled to look like a fighter frigate."

/obj/spacepod/fighter/New()
	..()
	var/obj/item/device/spacepod_equipment/weaponry/laser/W = new /obj/item/device/spacepod_equipment/weaponry/laser
	W.loc = equipment_system
	equipment_system.weapon_system = W
	verbs += /obj/spacepod/proc/fire_weapons
/obj/spacepod/random
	icon_state = "pod_civ"
// placeholder
/obj/spacepod/random/New()
	..()
	icon_state = pick("pod_civ", "pod_black", "pod_mil", "pod_synd", "pod_gold", "pod_industrial")
	switch(icon_state)
		if("pod_civ")
			desc = "A sleek civilian space pod."
		if("pod_black")
			desc = "An all black space pod with no insignias."
		if("pod_mil")
			desc = "A dark grey space pod brandishing the Nanotrasen Military insignia"
		if("pod_synd")
			desc = "A menacing military space pod with Fuck NT stenciled onto the side"
		if("pod_gold")
			desc = "A civilian space pod with a gold body, must have cost somebody a pretty penny"
		if("pod_industrial")
			desc = "A rough looking space pod meant for industrial work"

/obj/spacepod/verb/toggle_internal_tank()
	set name = "Toggle internal airtank usage"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	use_internal_tank = !use_internal_tank
	src.occupant << "<span class='notice'>Now taking air from [use_internal_tank?"internal airtank":"environment"].</span>"
	return

/obj/spacepod/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.oxygen = O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	cabin_air.nitrogen = N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	return cabin_air

/obj/spacepod/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/spacepod/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/spacepod/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = get_turf(src)
		if(T)
			return T.remove_air(amount)
	return

/obj/spacepod/return_air()
	if(use_internal_tank)
		return cabin_air
	return get_turf_air()

/obj/spacepod/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return

/obj/spacepod/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.return_temperature()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_temperature()
	return

/obj/spacepod/proc/moved_inside(var/mob/living/carbon/human/H as mob,var/passenger = 0)
	if(destroyed)
		return
	if(H && H.client && H in range(1))
		H.reset_view(src)
		H.stop_pulling()
		H.forceMove(src)
		if(passenger)
			src.passenger = H
		else
			src.occupant = H
		src.add_fingerprint(H)
		src.forceMove(src.loc)
		//dir = dir_in
		playsound(src, 'sound/machines/windowdoor.ogg', 50, 1)
		return 1
	else
		return 0

/obj/spacepod/MouseDrop_T(mob/M as mob, mob/user as mob)
	//if(!M.client)
	//	return
	move_inside(M, user)


/obj/spacepod/proc/toggle_lights()
	set category = "Spacepod"
	set name = "Toggle Lights"
	set desc = "Toggle the lights of the space pod"
	set src = usr.loc
	if(destroyed)
		return
	if(usr!=src.occupant)
		return

	if(!luminosity)
		src.set_light(6)
		usr << "\blue You turn the lights of the space pod on."
	else
		src.set_light(0)
		usr << "\blue You turn the lights of the space pod off."

/obj/spacepod/proc/fire_weapons()
	set category = "Spacepod"
	set name = "Fire Weapon System"
	set desc = "Fire ze missiles(or lasers)"
	set src = usr.loc
	if(destroyed)
		return
	if(usr!=src.occupant)
		return
	if(next_firetime > world.time)
		usr << "<span class='warning'>Your weapons are recharging.</span>"
		return
	var/turf/firstloc
	var/turf/secondloc
	if(!equipment_system || !equipment_system.weapon_system)
		usr << "<span class='warning'>Missing equipment or weapons.</span>"
		src.verbs -= /obj/spacepod/proc/fire_weapons
		return
	battery.use(equipment_system.weapon_system.shot_cost)
	var/olddir
	for(var/i = 0; i < equipment_system.weapon_system.shots_per; i++)
		if(olddir != dir)
			switch(dir)
				if(NORTH)
					firstloc = get_step(src, NORTH)
					secondloc = get_step(firstloc,EAST)
				if(SOUTH)
					firstloc = get_turf(src)
					secondloc = get_step(firstloc,EAST)
				if(EAST)
					firstloc = get_turf(src)
					firstloc = get_step(firstloc, EAST)
					secondloc = get_step(firstloc,NORTH)
				if(WEST)
					firstloc = get_turf(src)
					secondloc = get_step(firstloc,NORTH)
		olddir = dir
		if(istype(equipment_system.weapon_system, /obj/item/device/spacepod_equipment/weaponry/clown))
			spawn()
				playsound(src, equipment_system.weapon_system.fire_sound, 50, 1)
			sleep(1)
			next_firetime = world.time + equipment_system.weapon_system.fire_delay
			return
		var/obj/item/projectile/projone = new equipment_system.weapon_system.projectile_type(firstloc)
		var/obj/item/projectile/projtwo = new equipment_system.weapon_system.projectile_type(secondloc)
		projone.starting = get_turf(src)
		projone.shot_from = src
		projone.firer = usr
		projone.def_zone = "chest"
		projtwo.starting = get_turf(src)
		projtwo.shot_from = src
		projtwo.firer = usr
		projtwo.def_zone = "chest"
		spawn()
			playsound(src, equipment_system.weapon_system.fire_sound, 50, 1)
			projone.dumbfire(dir)
			projtwo.dumbfire(dir)
		sleep(1)
	next_firetime = world.time + equipment_system.weapon_system.fire_delay


/obj/spacepod/verb/move_inside()
	set category = "Object"
	set name = "Enter Pod"
	set src in oview(1)
	if(destroyed)
		return

	if(usr.restrained() || usr.stat || usr.weakened || usr.stunned || usr.paralysis || usr.resting) //are you cuffed, dying, lying, stunned or other
		return
	if (usr.stat || !ishuman(usr))
		return
	if(usr == src.occupant)
		return
	if(usr == src.passenger)
		return
	if (src.occupant && src.passenger)
		usr << "\blue <B>The [src.name] is already occupied!</B>"
		return

	for(var/mob/living/carbon/metroid/M in range(1,usr))
		if(M.Victim == usr)
			usr << "You're too busy getting your life sucked out of you."
			return

//	usr << "You start climbing into [src.name]"

	visible_message("\blue [usr] starts to climb into [src.name]")

	if(enter_after(40,usr))
		if(!src.occupant)
			moved_inside(usr)
		else if(src.occupant!=usr)
			moved_inside(usr,1)
			usr << "[src.occupant] Is Flying this thing your only the passenger."
	else
		usr << "You stop entering the space pod."
	return


/obj/spacepod/verb/exit_pod()
	set name = "Exit pod"
	set category = "Spacepod"
	set src = usr.loc

	if(usr != src.occupant)
		return
	inertia_dir = 0 // engage reverse thruster and power down pod
	src.occupant.loc = src.loc
	src.occupant = null
	usr << "<span class='notice'>You climb out of the pod</span>"
	return

/obj/spacepod/verb/passenger_exit_pod()
	set name = "Passenger Exit pod"
	set category = "Spacepod"
	set src = usr.loc

	if(usr != src.passenger)
		return
	inertia_dir = 0 // engage reverse thruster and power down pod
	src.passenger.loc = src.loc
	src.passenger = null
	usr << "<span class='notice'>You climb out of the pod</span>"
	return

/obj/spacepod/proc/enter_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = user.loc
	if(destroyed)
		return

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(user.loc == T))
			return 0

	return 1


/obj/spacepod/proc/exit_after(delay as num, var/mob/user as mob, var/numticks = 5)
	var/delayfraction = delay/numticks

	var/turf/T = src.loc
	if(destroyed)
		return

	for(var/i = 0, i<numticks, i++)
		sleep(delayfraction)
		if(!src || !user || !user.canmove || !(src.loc == T))
			return 0

	return 1

/datum/global_iterator/pod_preserve_temp  //normalizing cabin air temperature to 20 degrees celsium
	delay = 20

	process(var/obj/spacepod/spacepod)
		if(spacepod.cabin_air && spacepod.cabin_air.return_volume() > 0)
			var/delta = spacepod.cabin_air.temperature - T20C
			spacepod.cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))
		return

/datum/global_iterator/pod_tank_give_air
	delay = 15

	process(var/obj/spacepod/spacepod)
		if(spacepod.internal_tank)
			var/datum/gas_mixture/tank_air = spacepod.internal_tank.return_air()
			var/datum/gas_mixture/cabin_air = spacepod.cabin_air

			var/release_pressure = ONE_ATMOSPHERE
			var/cabin_pressure = cabin_air.return_pressure()
			var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
			var/transfer_moles = 0
			if(pressure_delta > 0) //cabin pressure lower than release pressure
				if(tank_air.return_temperature() > 0)
					transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
					cabin_air.merge(removed)
			else if(pressure_delta < 0) //cabin pressure higher than release pressure
				var/datum/gas_mixture/t_air = spacepod.get_turf_air()
				pressure_delta = cabin_pressure - release_pressure
				if(t_air)
					pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
				if(pressure_delta > 0) //if location pressure is lower than cabin pressure
					transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
					if(t_air)
						t_air.merge(removed)
					else //just delete the cabin gas, we're in space or some shit
						qdel(removed)
		else
			return stop()
		return

/obj/spacepod/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0)
	..()
	if(dir == 1 || dir == 4)
		src.loc.Entered(src)
/obj/spacepod/proc/Process_Spacemove(var/check_drift = 0, mob/user)
	var/dense_object = 0
	if(user == passenger)
		return
	if(!user)
		for(var/direction in list(NORTH, NORTHEAST, EAST))
			var/turf/cardinal = get_step(src, direction)
			if(istype(cardinal, /turf/space))
				continue
			dense_object++
			break
	if(!dense_object)
		return 0
	inertia_dir = 0
	return 1

/obj/spacepod/relaymove(mob/user, direction)
	if(destroyed)
		return
	if(empstun > 0)
		if(user)
			user << "\red \the [src] is unresponsive."
		return
	if(battery && battery.charge)
		if(user == passenger)
			return
		src.dir = direction
		switch(direction)
			if(1)
				if(inertia_dir == 2)
					inertia_dir = 0
					return 0
			if(2)
				if(inertia_dir == 1)
					inertia_dir = 0
					return 0
			if(4)
				if(inertia_dir == 8)
					inertia_dir = 0
					return 0
			if(8)
				if(inertia_dir == 4)
					inertia_dir = 0
					return 0
		step(src, direction)
		if(istype(src.loc, /turf/space))
			inertia_dir = direction
	else
		user << "<span class='warning'>She's dead, Jim</span>"
		return 0
	battery.use(3)

/obj/spacepod/proc/give_power(amount)
	if(destroyed)
		return 0
	if(!isnull(get_charge()))
		battery.give(amount)
		return 1
	return 0

/obj/spacepod/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/spacepod/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/spacepod/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(!src.battery) return
	return max(0, src.battery.charge)

/obj/spacepod/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/spacepod/proc/dynusepower(amount)
	if(get_charge())
		battery.use(amount)
		return 1
	return 0


/obj/spacepod/emp_act(severity)
	switch(severity)
		if(1)
			src.empstun = (rand(5,10))
		if(2)
			src.empstun = (rand(1,5))
	src.visible_message("\red The [src.name]'s engine short circuits!")
	spark_system.attach(src)
	spark_system.set_up(5, 0, src)
	spark_system.start()

/obj/spacepod/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/ion))
		Proj.on_hit(src, 2)
		return
	if(istype(Proj, /obj/item/projectile/energy/electrode))
		if(prob(25))
			visible_message("<span class='warning'>The [src.name] absorbs the [Proj]")
		visible_message("<span class='warning'>[Proj] hits the [name]!</span>")
		if(!Proj.nodamage && Proj.damage_type == BRUTE || Proj.damage_type == BURN)
			health -= Proj.damage
		HealthCheck()
	else if(!Proj.nodamage && Proj.damage_type == BRUTE || Proj.damage_type == BURN)
		visible_message("<span class='warning'>[Proj] hits the [name]!</span>")
		health -= Proj.damage
		HealthCheck()

/obj/spacepod/process()
	if(empstun > 0)
		empstun--
	if(empstun < 0)
		empstun = 0

/obj/spacepod/proc/HealthCheck()
	if(health > 300) health = 300
	if(health <= 0 && !destroyed)
		destroyed = 1
		density = 0
		if(occupant)
			src.occupant << "<span class='notice'>You get ejected from the pod!</span>"
			src.occupant.loc = src.loc
			src.occupant = null
		if(passenger)
			src.passenger << "<span class='notice'>You get ejected from the pod!</span>"
			src.passenger.loc = src.loc
			src.passenger = null
		for(var/mob/V in src.contents)
			if(istype(V,/mob))
				V.loc = src.loc
		for(var/obj/O in src.contents)
			qdel(O)
		visible_message("<span class='warning'>The [name] explodes!</span>")
		explosion(src.loc,-1,0,2,7,10)
		icon_state = icon_state+"_destroy"
		anchored = 0

/obj/spacepod/ex_act(severity)
	switch (severity)
		if(1.0)
			health -= 100
		if(2.0)
			health -= 75
		if(3.0)
			health -= 45
	HealthCheck()

/obj/spacepod/verb/pickup_objects()
	set name = "Pickup Objects"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	var/turf/S
	var/turf/D
	if(src.dir==8)
		S = get_step(get_turf(src), src.dir)
		D = get_step(S,NORTH)
	if(src.dir==4)
		var/turf/T = get_step(get_turf(src), src.dir)
		S = get_step(T,src.dir)
		D = get_step(S,NORTH)
	if(src.dir==1)
		var/turf/T = get_step(get_turf(src), src.dir)
		S = get_step(T,src.dir)
		D = get_step(S,EAST)
	if(src.dir==2)
		S = get_step(get_turf(src), src.dir)
		D = get_step(S,EAST)
	var/objpickedup = 0
	for(var/obj/Mach in S.contents)
		if(istype(Mach,/obj/machinery))
			return
	for(var/obj/AM in S.contents)
		if(!AM.anchored)
			src.cargo += AM
			AM.loc = src
			objpickedup =1
	for(var/obj/Mach in D.contents)
		if(istype(Mach,/obj/machinery))
			return
	for(var/obj/AM in D.contents)
		if(!AM.anchored)
			src.cargo += AM
			AM.loc = src
			objpickedup =1
	if(objpickedup)
		src.occupant << "<span class='notice'>Picking up objects in front of the craft.</span>"
	var/mobpickedup = 0
	for(var/mob/M in S.contents)
		if(M.stat)
			src.cargo += M
			M.loc = src
			mobpickedup = 1
	for(var/mob/M in D.contents)
		if(M.stat)
			src.cargo += M
			M.loc = src
			mobpickedup = 1
	if(mobpickedup)
		src.occupant << "<span class='notice'>Picking up lifeform in front of the craft.</span>"
	return


/obj/spacepod/verb/empty_objects()
	set name = "Empty Space Pod"
	set category = "Spacepod"
	set src in oview(1)
	set popup_menu = 1

	if(src.destroyed)
		return
	if(usr.stat)
		return
	for(var/atom/movable/AM in src.cargo)
		AM.loc = src.loc
		src.cargo -= AM

	usr << "<span class='notice'>Emptying Contents.</span>"
	return

/obj/spacepod/verb/Eject_Occupants()
	set name = "Eject Occupants"
	set category = "Object"
	set src in oview(1)
	set popup_menu = 1
	if(src.destroyed)
		return
	if(!src.occupant && !src.passenger)
		usr <<"\red theres no one flying this craft!"
		return
	if(usr == src.occupant||usr == src.passenger)
		usr <<"\red can't do this from inside!"
		return
	if(usr.loc == src.loc)
		return
	if(exit_after(40,usr))

		if(occupant)
			src.occupant << "<span class='notice'>You get ejected from the pod!</span>"
			src.occupant.loc = src.loc
			src.occupant = null
		if(passenger)
			src.passenger << "<span class='notice'>You get ejected from the pod!</span>"
			src.passenger.loc = src.loc
			src.passenger = null
	else
		usr << "<Span class='notice'>Unable to do while craft is moving!</span>"
	return

/obj/spacepod/proc/Open_external()
	set name = "Open Docking Blast Doors"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id == "station_dock")
			if (M.density)
				spawn( 0 )
					M.open()
					return
			else
				spawn( 0 )
					M.close()
					return

/obj/spacepod/proc/Open_Syn_external()
	set name = "Open Docking Blast Doors"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id == "Syn_dock")
			if (M.density)
				spawn( 0 )
					M.open()
					return
			else
				spawn( 0 )
					M.close()
					return

/obj/spacepod/proc/Open_ninja_external()
	set name = "Open Docking Blast Doors"
	set category = "Spacepod"
	set src = usr.loc
	set popup_menu = 0
	for(var/obj/machinery/door/poddoor/M in world)
		if (M.id == "ninja_dock")
			if (M.density)
				spawn( 0 )
					M.open()
					return
			else
				spawn( 0 )
					M.close()
					return