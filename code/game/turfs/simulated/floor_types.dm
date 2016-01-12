/turf/simulated/floor/airless
	icon_state = "floor"
	name = "airless floor"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "floor"

/turf/simulated/floor/light
	name = "Light floor"
	luminosity = 5
	icon_state = "light_on"
	floor_tile = new/obj/item/stack/tile/light

	New()
		floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
		var/n = name //just in case commands rename it in the ..() call
		..()
		spawn(4)
			if(src)
				update_icon()
				name = n



/turf/simulated/floor/wood
	name = "wooden floor"
	icon_state = "wood"
	floor_tile = new/obj/item/stack/tile/wood

/turf/simulated/floor/wood/old
	name = "wooden floor"
	icon_state = "woodold"
	floor_tile = new/obj/item/stack/tile/wood

/turf/simulated/floor/wood/oldest
	name = "wooden floor"
	icon_state = "woodnew"
	floor_tile = new/obj/item/stack/tile/wood

/turf/simulated/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src.loc, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor)
			var/turf/simulated/floor/F = src
			F.make_plating()
			return

/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/simulated/floor/engine/n20
	New()
		..()
		var/datum/gas_mixture/adding = new
		var/datum/gas/sleeping_agent/trace_gas = new

		trace_gas.moles = 2000
		adding.trace_gases += trace_gas
		adding.temperature = T20C

		assume_air(adding)

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/simulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"

/turf/simulated/floor/redgrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "rcircuit"

/turf/simulated/floor/indigogrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "icircuit"

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/beach/sand
	name = "Sand"
	icon_state = "sand"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/beach/coastline/newcoastline
	name = "Coastline"
	icon = 'icons/misc/beach.dmi'
	icon = 'icons/misc/beach2.dmi'
	icon_state = "beach"

/turf/simulated/beach/water
	name = "Water"
	icon_state = "water"

/turf/simulated/beach/sea
	name = "Water"
	icon_state = "seashallow"

/turf/simulated/beach/
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/simulated/beach/desert
	name = "Sand"
	icon_state = "desert"
	luminosity = 10
	temperature = 323.15

/turf/simulated/beach/desert1
	name = "Sand"
	icon_state = "desert8"
	luminosity = 0
	temperature = 323.15

/turf/simulated/beach/dgrass
	name = "Grass"
	icon_state = "dgrass0"

/turf/simulated/beach/grass
	name = "Grass"
	icon_state = "fullgrass0"

/turf/simulated/beach/desertdug
	name = "Sand"
	icon_state = "desert_dug"

/turf/simulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/simulated/beach/sea/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="seashallow","layer"=MOB_LAYER+0.1)

/turf/simulated/floor/grass
	name = "Grass patch"
	icon_state = "grass1"
	floor_tile = new/obj/item/stack/tile/grass

	New()
		floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/carpet
	name = "Carpet"
	icon_state = "carpet"
	floor_tile = new/obj/item/stack/tile/carpet

	New()
		floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
		if(!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/plating/ironsand
	name = "Iron Sand"
	icon_state = "ironsand0"

	New()
		floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
		icon_state = "ironsand[rand(1,15)]"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor/plating))
						var/turf/simulated/floor/plating/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/plating/snow/ex_act(severity)
	return


/turf/simulated/floor/plating/airless/catwalk
	icon = 'icons/turf/catwalks.dmi'
	icon_state = "catwalk0"
	name = "catwalk"
	desc = "Cats really don't like these things."

/turf/simulated/floor/fakespace
	name = "Astral Carpet"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	floor_tile = new/obj/item/stack/tile/fakespace

	New()
		floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
		icon = 'icons/turf/space.dmi'
		icon_state = "[pick("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25")]"
		..()
