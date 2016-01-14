#define METEOR_TEMPERATURE

/var/const/meteor_wave_delay = 625 //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

/var/const/meteors_in_wave = 50
/var/const/meteors_in_small_wave = 10

/proc/meteor_wave(var/number = meteors_in_wave)
	if(!ticker || wavesecret)
		return

	wavesecret = 1
	for(var/i = 0 to number)
		spawn(rand(10,100))
			spawn_meteor()
	spawn(meteor_wave_delay)
		wavesecret = 0

/proc/spawn_meteors(var/number = meteors_in_small_wave)
	for(var/i = 0; i < number; i++)
		spawn(0)
			spawn_meteor()

/proc/spawn_meteor()

	var/startx
	var/starty
	var/endx
	var/endy
	var/turf/pickedstart
	var/turf/pickedgoal
	var/max_i = 10//number of tries to spawn meteor.


	do
		switch(pick(1,2,3,4))
			if(1) //NORTH
				starty = world.maxy-(TRANSITIONEDGE+1)
				startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
				endy = TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
			if(2) //EAST
				starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
				startx = world.maxx-(TRANSITIONEDGE+1)
				endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
				endx = TRANSITIONEDGE
			if(3) //SOUTH
				starty = (TRANSITIONEDGE+1)
				startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
				endy = world.maxy-TRANSITIONEDGE
				endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
			if(4) //WEST
				starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
				startx = (TRANSITIONEDGE+1)
				endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
				endx = world.maxx-TRANSITIONEDGE

		pickedstart = locate(startx, starty, 1)
		pickedgoal = locate(endx, endy, 1)
		max_i--
		if(max_i<=0) return

	while (!istype(pickedstart, /turf/space) || pickedstart.loc.name != "Space" ) //FUUUCK, should never happen.


	var/obj/effect/meteor/M
	switch(rand(1, 100))

		if(1 to 10)
			M = new /obj/effect/meteor/big( pickedstart )
		if(11 to 75)
			M = new /obj/effect/meteor( pickedstart )
		if(76 to 100)
			M = new /obj/effect/meteor/small( pickedstart )

	M.dest = pickedgoal
	spawn(0)
		walk_towards(M, M.dest, 1)

	return

/obj/effect/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "flaming"
	density = 1
	anchored = 1.0
	var/hits = 1
	var/dest
	pass_flags = PASSTABLE

/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASSTABLE | PASSGRILLE

/obj/effect/meteor/small
	name = "small meteor"
	icon_state = "smallf"
	pass_flags = PASSTABLE | PASSGRILLE

/obj/effect/meteor/Move()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(METEOR_TEMPERATURE, 1000)
	..()
	return

/obj/effect/meteor/Bump(atom/A)
	spawn(0)
		for(var/mob/M in range(10, src))
			if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
				shake_camera(M, 3, 1)
		if (A)
			A.meteorhit(src)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
		if (--src.hits <= 0)

			//Prevent meteors from blowing up the singularity's containment.
			//Changing emitter and generator ex_act would result in them being bomb and C4 proof.
			if(!istype(A,/obj/machinery/power/emitter) && \
				!istype(A,/obj/machinery/field_generator) && \
				prob(15))

				explosion(src.loc, 4, 5, 6, 7, 0)
				playsound(src.loc, "explosion", 50, 1)
			del(src)
	return


/obj/effect/meteor/ex_act(severity)

	if (severity < 4)
		del(src)
	return

/obj/effect/meteor/big
	name = "big meteor"
	hits = 5

	ex_act(severity)
		return

	Bump(atom/A)
		spawn(0)
			//Prevent meteors from blowing up the singularity's containment.
			//Changing emitter and generator ex_act would result in them being bomb and C4 proof
			if(!istype(A,/obj/machinery/power/emitter) && \
				!istype(A,/obj/machinery/field_generator))
				if(--src.hits <= 0)
					del(src) //Dont blow up singularity containment if we get stuck there.

			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai)) //bad idea to shake an ai's view
					shake_camera(M, 3, 1)
			if (A)
				explosion(src.loc, 0, 1, 2, 3, 0)
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)
			if (--src.hits <= 0)
				if(prob(15) && !istype(A, /obj/structure/grille))
					explosion(src.loc, 1, 2, 3, 4, 0)
					playsound(src.loc, "explosion", 50, 1)
				del(src)
		return

/obj/effect/meteor/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pickaxe))
		del(src)
		return
	..()

//TG METEORS SYSTEM//
/*
//Dust
/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASSTABLE | PASSGRILLE
	hits = 1
	hitpwr = 3
	meteorsound = 'sound/weapons/throwtap.ogg'
	meteordrop = /obj/item/weapon/ore/glass

//Medium-sized
/obj/effect/meteor/medium
	name = "meteor"
	dropamt = 3

/obj/effect/meteor/medium/meteor_effect()
	..(heavy)
	explosion(src.loc, 0, 1, 2, 3, 0)

//Large-sized
/obj/effect/meteor/big
	name = "big meteor"
	icon_state = "large"
	hits = 6
	heavy = 1
	dropamt = 4

/obj/effect/meteor/big/meteor_effect()
	..(heavy)
	explosion(src.loc, 1, 2, 3, 4, 0)

//Flaming meteor
/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 5
	heavy = 1
	meteorsound = 'sound/effects/bamf.ogg'
	meteordrop = /obj/item/weapon/ore/plasma

/obj/effect/meteor/flaming/meteor_effect()
	..(heavy)
	explosion(src.loc, 1, 2, 3, 4, 0, 0, 5)

//Radiation meteor
/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = /obj/item/weapon/ore/uranium


/obj/effect/meteor/irradiated/meteor_effect()
	..(heavy)
	explosion(src.loc, 0, 0, 4, 3, 0)
	new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	radiation_pulse(get_turf(src), 2, 5, 50, 1)

//Meaty Ore
/obj/effect/meteor/meaty
	name = "meaty ore"
	icon_state = "meateor"
	desc = "Just... don't think too hard about where this thing came from."
	hits = 2
	heavy = 1
	meteorsound = 'sound/effects/blobattack.ogg'
	meteordrop = /obj/item/weapon/reagent_containers/food/snacks/meat
	var/meteorgibs = /obj/effect/gibspawner/generic

/obj/effect/meteor/meaty/make_debris()
	..()
	new meteorgibs(get_turf(src))


/obj/effect/meteor/meaty/ram_turf(turf/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/blood (T)

/obj/effect/meteor/meaty/Bump(atom/A)
	A.ex_act(hitpwr)
	get_hit()

//Meaty Ore Xeno edition
/obj/effect/meteor/meaty/xeno
	color = "#5EFF00"
	meteordrop = /obj/item/weapon/reagent_containers/food/snacks/meat/slab/xeno
	meteorgibs = /obj/effect/gibspawner/xeno

/obj/effect/meteor/meaty/xeno/ram_turf(turf/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/xenoblood (T)

//Station buster Tunguska
/obj/effect/meteor/tunguska
	name = "tunguska meteor"
	icon_state = "flaming"
	desc = "Your life briefly passes before your eyes the moment you lay them on this monstruosity"
	hits = 30
	hitpwr = 1
	heavy = 1
	meteorsound = 'sound/effects/bamf.ogg'
	meteordrop = /obj/item/weapon/ore/plasma

/obj/effect/meteor/tunguska/meteor_effect()
	..(heavy)
	explosion(src.loc, 5, 10, 15, 20, 0)

/obj/effect/meteor/tunguska/Bump()
	..()
	if(prob(20))
		explosion(src.loc,2,4,6,8)
*/