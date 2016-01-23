/obj/machinery/power/reactor
	name = "Fancy Scientific Generator"
	desc = "A fancy fusion-based generator designed primarily for use with Elerium, but will accept other ores at risk of reaction instability."
	icon = 'icons/obj/machines/reactor.dmi'
	icon_state = "placeholder"
	anchored = 1
	density = 1
	var/active = 0
	var/fuel = 0
	var/maxfuel = 600
	var/genrate = 5000
	var/effmult = 0.6
	var/enrichment = 0
	var/risk = 0
	var/busy = 0
	var/ores = 0

/obj/machinery/power/reactor/process()
	if(stat & BROKEN) return
	if(src.active)
		if(src.fuel)
			if(prob(risk))
				for(var/mob/O in viewers(src, null)) O.show_message(text("\red [] starts to overload!", src), 1)
				stat = BROKEN
				flick("reactormelt", src)
				spawn(41)
				for(var/mob/O in viewers(src, null)) O.show_message(text("\red [] explodes!", src), 1)
				explosion(src.loc,0,rand(1,3),rand(2,6),rand(4,8),rand(6,10))
				spawn(21)
				icon_state = "dead"
				return
			add_avail(src.genrate * src.enrichment * src.effmult)
			fuel--
		if(!src.fuel)
			for(var/mob/O in viewers(src, null)) O.show_message(text("\red [] runs out of fuel and shuts down!", src), 1)
			src.active = 0
			busy = 1
			if(icon_state != "placeholder1")
				flick("placeholder2", src) // fuck too tired to write this code night night byond.
			spawn(14)
			updateicon()
			busy = 0

/obj/machinery/power/reactor/attack_hand(var/mob/user as mob)
	if(busy) return
	if (!src.fuel) user << "\red There is no fuel in the Reactor!"
	else
		src.active = !src.active
		user << "You switch [src.active ? "on" : "off"] the Reactor."
		if(src.active)// src.overlays += image('power.dmi', "placeholder1")
			busy = 1
			if(icon_state != "placeholder1")
				flick("placeholder2", src) // fuck too tired to write this code night night byond.
			spawn(14)
			updateicon()
			busy = 0
		else if(!src.active)
			busy = 1
			if(icon_state != "placeholder")
				flick("placeholder3", src)
			spawn(14)
			updateicon()
			busy = 0

/obj/machinery/power/reactor/attackby(var/obj/item/weapon/ore/W as obj, mob/user as mob)
	if(!istype(W) || !user)
		..()
		return
	if(istype(W, /obj/item/weapon/ore/char))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel += (src.fuel + 10)
		enrichment = 10
		risk = 0
		del W
	if (istype(W, /obj/item/weapon/ore/lovite))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel += (src.fuel + 30)
		enrichment = 1200
		risk = 0
		del W
	if (istype(W, /obj/item/weapon/ore/cerenkite))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel += (src.fuel + 50)
		enrichment = 75
		risk = 0
		del W
	if(istype(W, /obj/item/weapon/ore/plasma))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel += (src.fuel + 100)
		enrichment = 750
		risk = 1
		del W
	if (istype(W, /obj/item/weapon/ore/uranium))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel = (src.fuel + 200)
		enrichment = 850
		risk = 2
		del W
	if(istype(W, /obj/item/weapon/ore/erebite))
		if(src.fuel > src.maxfuel)
			src.fuel = src.maxfuel
			user << "\blue The reactor is now full!"
			return
		src.fuel = (src.fuel + 300)
		enrichment = 2000
		risk = 7
		del W
/*	if(istype(W, /obj/item/metroid_core))	POWER OUTPUT TESTER, DON'T FUCK WITH THIS
		src.fuel = INFINITY
		enrichment = 300
		risk = 0.01
		del W*/

/obj/machinery/power/reactor/proc/updateicon()
	if(!src.active)
		icon_state = "placeholder"
	if(src.active)
		icon_state = "placeholder1"
