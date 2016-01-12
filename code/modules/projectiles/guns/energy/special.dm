/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = "combat=2;magnets=4"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	charge_cost = 100
	projectile_type = "/obj/item/projectile/ion"

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	if(severity <= 2)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
	else
		return

/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/declone"

obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'icons/obj/gun.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	w_class = 4.0
	charge_cost = 200
	projectile_type = "/obj/item/projectile/change"
	origin_tech = null
	clumsy_check = 0
	var/charge_tick = 0


	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(200)
		return 1

	update_icon()
		return
/obj/item/weapon/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = "/obj/item/projectile/animate"
	charge_cost = 100

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "obj/item/gun.dmi"
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/floramut"
	origin_tech = "materials=2;biotech=3;powerstorage=3"
	modifystate = "floramut"
	var/charge_tick = 0
	var/mode = 0 //0 = mutate, 1 = yield boost

	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()


	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)
		update_icon()
		return 1

	attack_self(mob/living/user as mob)
		switch(mode)
			if(0)
				mode = 1
				charge_cost = 100
				user << "\red The [src.name] is now set to increase yield."
				projectile_type = "/obj/item/projectile/energy/florayield"
				modifystate = "florayield"
			if(1)
				mode = 0
				charge_cost = 100
				user << "\red The [src.name] is now set to induce mutations."
				projectile_type = "/obj/item/projectile/energy/floramut"
				modifystate = "floramut"
		update_icon()
		return

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "meteorgun"
	item_state = "c20r"
	w_class = 4
	projectile_type = "/obj/item/projectile/meteor"
	charge_cost = 100
	cell_type = "/obj/item/weapon/cell/potato"
	clumsy_check = 0 //Admin spawn only, might as well let clowns use it.
	var/charge_tick = 0
	var/recharge_time = 5 //Time it takes for shots to recharge (in ticks)

	New()
		..()
		processing_objects.Add(src)


	Del()
		processing_objects.Remove(src)
		..()

	process()
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0
		if(!power_supply) return 0
		power_supply.give(100)

	update_icon()
		return


/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = 1


/obj/item/weapon/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A prototype weapon recovered from the ruins of Research-Station Epsilon."
	icon_state = "xraycannon"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	projectile_type = "/obj/item/projectile/beam/mindflayer"
	fire_sound = 'sound/weapons/Laser.ogg'

obj/item/weapon/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"
	projectile_type = "/obj/item/projectile/forcebolt"
	/*
	attack_self(mob/living/user as mob)
		if(projectile_type == "/obj/item/projectile/forcebolt")
			charge_cost = 200
			user << "\red The [src.name] will now strike a small area."
			projectile_type = "/obj/item/projectile/forcebolt/strong"
		else
			charge_cost = 100
			user << "\red The [src.name] will now strike only a single person."
			projectile_type = "/obj/item/projectile/forcebolt"
	*/

//Kinetic Accelerator//

/obj/item/weapon/gun/energy/kinetic_accelerator
	name = "proto-kinetic accelerator"
	desc = "According to Nanotrasen accounting, this is mining equipment. It's been modified for extreme power output to crush rocks, but often serves as a miner's first defense against hostile alien life; it's not very powerful unless used in a low pressure environment."
	icon_state = "kineticgun"
	item_state = "kineticgun"
	var/suppressed = 0	//whether or not a message is displayed when fired
	var/overheat = 0
	var/overheat_time = 16
	var/recent_reload = 1
	charge_cost = 100
	origin_tech = "combat=4;powerstorage=3"
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'
	projectile_type = "/obj/item/projectile/energy/kinetic"

/obj/item/weapon/gun/energy/kinetic_accelerator/attack_self(var/mob/living/user/L)
	if(overheat || recent_reload)
		return
	power_supply.give(500)
	playsound(src.loc, 'sound/weapons/Kenetic_reload.ogg', 60, 1)
	recent_reload = 1
	update_icon()
	return

/obj/item/weapon/gun/energy/kinetic_accelerator/update_icon()
	if(power_supply.charge < 100)
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/energy/kinetic_accelerator/super
	name = "super-kinetic accelerator"
	desc = "An upgraded, superior version of the proto-kinetic accelerator."
	icon_state = "kineticgun_u"
	overheat_time = 15
	origin_tech = "combat=3;powerstorage=2"
	projectile_type = "/obj/item/projectile/energy/kinetic/super"

/obj/item/weapon/gun/energy/kinetic_accelerator/hyper
	name = "hyper-kinetic accelerator"
	desc = "An upgraded, even more superior version of the proto-kinetic accelerator."
	icon_state = "kineticgun_h"
	overheat_time = 14
	origin_tech = "combat=2;materials=6;powerstorage=4;engineering=5"
	projectile_type = "/obj/item/projectile/energy/kinetic/hyper"

/obj/item/weapon/gun/energy/kinetic_accelerator/emp_act(severity)
	return

//Plasma Gun//

/obj/item/weapon/gun/energy/plasmagun
	name = "plasma gun MX3"
	desc = "A man portable fusion reactor with integrated Lawson chamber."
	icon_state = "plasmagun"
	fire_sound = 'sound/weapons/plasmagun.ogg'
	origin_tech = "combat=4;magnets=5"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BACK
	charge_cost = 100
	projectile_type = "/obj/item/projectile/energy/plasma"

//*****D2K5 SHIT*****//
//Phaser//
/*
/obj/item/weapon/gun/energy/phaser
	name = "phaser gun"
	icon_state = "laser_h"
	desc = "A weapon that can fire variable-size suppressive waves of energy."
	fire_sound = 'sound/weapons/laser4.ogg'
	charge_cost = 100
	origin_tech = "combat=3;materials=3;magnets=3"
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	cell_type = "/obj/item/weapon/cell/crap"
	projectile_type = "/obj/item/projectile/energy/phaser"
	var/p_lock = 1	// Power lock, emagging lets you use more powerful shots
	var/radius = 0.0
	var/power = 25.0
	var/loaded_effect = "stun"


	New()
		..()
		AdjustPowerUse()

	process_chambered()
		if(in_chamber)
			return 1
		if(power_supply.charge <= charge_cost)
			return 0
		in_chamber = new /obj/item/projectile/phaser(src)
		power_supply.use(charge_cost)
		return 1


	proc/AdjustPowerUse()
		while(src)
			sleep(10)
			if(power)
				charge_cost = ((power * 4) * (radius + 1))

	attack_self(mob/living/user as mob)
		user.machine = src
		var/dat = {"<B>Phaser Gun Configuration: </B><BR>
		Radius: <A href='?src=\ref[src];radius_adj=-1'>-</A> [radius+1] <A href='?src=\ref[src];radius_adj=1'>+</A><BR>
		Power: <A href='?src=\ref[src];power_adj=-5'>-</A> [power] <A href='?src=\ref[src];power_adj=5'>+</A><BR>
		Each shot will use [charge_cost] units of power!<BR>
		<HR>
		<A href='?src=\ref[user];mach_close=phaser'>Close</A><BR>
		"}

		user << browse(dat, "window=phaser;size=450x300")
		onclose(user, "phaser")

	Topic(href, href_list)
		if (..())
			return
		usr.machine = src
		if (href_list["radius_adj"])
			var/rdiff = text2num(href_list["radius_adj"])
			if(rdiff > 0)
				radius += rdiff
			else
				radius -= rdiff
			if(radius < 0)
				radius = 0
			if(radius > 2)
				radius = 2
		if (href_list["power_adj"])
			var/pdiff = text2num(href_list["power_adj"])
			if(pdiff > 0)
				power += pdiff
			else
				power -= pdiff
			if(power < 5)
				power = 5
			if(power > 40 && p_lock)
				power = 40
		if (istype(loc, /mob))
			attack_self(loc)
		AdjustPowerUse()
		return
*/