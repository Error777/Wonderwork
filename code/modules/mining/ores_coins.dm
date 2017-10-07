/**********************Mineral ores**************************/

/obj/item/weapon/ore
	name = "Rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	var/datum/geosample/geological_data

/obj/item/weapon/ore/uranium
	name = "Uranium ore"
	icon_state = "Uranium ore"
	origin_tech = "materials=5"

/obj/item/weapon/ore/iron
	name = "Iron ore"
	icon_state = "Iron ore"
	origin_tech = "materials=1"

/obj/item/weapon/ore/glass
	name = "Sand"
	icon_state = "Glass ore"
	origin_tech = "materials=1"

	attack_self(mob/living/user as mob) //It's magic I ain't gonna explain how instant conversion with no tool works. -- Urist
		var/location = get_turf(user)
		for(var/obj/item/weapon/ore/glass/sandToConvert in location)
			new /obj/item/stack/sheet/mineral/sandstone(location)
			qdel(sandToConvert)
		new /obj/item/stack/sheet/mineral/sandstone(location)
		qdel(src)

/obj/item/weapon/ore/plasma
	name = "Plasma ore"
	icon_state = "Plasma ore"
	origin_tech = "materials=2"

/obj/item/weapon/ore/silver
	name = "Silver ore"
	icon_state = "Silver ore"
	origin_tech = "materials=3"

/obj/item/weapon/ore/gold
	name = "Gold ore"
	icon_state = "Gold ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/diamond
	name = "Diamond ore"
	icon_state = "Diamond ore"
	origin_tech = "materials=6"

/obj/item/weapon/ore/clown
	name = "Bananium ore"
	icon_state = "Clown ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/aluminum
	name = "Aluminum ore"
	icon_state = "Aluminum ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/adamantine
	name = "Adamantine ore"
	icon_state = "Adamantine ore"
	origin_tech = "materials=4"

/obj/item/weapon/ore/phazon
	name = "Phazon ore"
	icon_state = "Phazon"
	origin_tech = "materials=9"

/obj/item/weapon/ore/triberium
	name = "Triberium crystal"
	icon_state = "triberium ore"
	origin_tech = "materials=5"

/obj/item/weapon/ore/slag
	name = "Slag"
	desc = "Completely useless"
	icon_state = "slag"

/obj/item/weapon/ore/mauxite
	name = "mauxite ore"
	desc = "A chunk of Mauxite, a sturdy common metal."
	icon_state = "mauxite"

/obj/item/weapon/ore/molitz
	name = "molitz crystal"
	desc = "A crystal of Molitz, a common crystalline substance."
	icon_state = "molitz"

/obj/item/weapon/ore/pharosium
	name = "pharosium ore"
	desc = "A chunk of Pharosium, a conductive metal."
	icon_state = "pharosium"
// Common Cluster Ores

/obj/item/weapon/ore/cobryl
	name = "cobryl ore"
	desc = "A chunk of Cobryl, a somewhat valuable metal."
	icon_state = "cobryl"

/obj/item/weapon/ore/ice
	name = "rotten ice"
	desc = "a handful of Ice, a cold and wet ice."
	icon_state = "ice"

/obj/item/weapon/ore/char
	name = "Char"
	desc = "A heap of Char, a fossil energy source similar to coal."
	icon_state = "char"
// Rare Vein Ores

/obj/item/weapon/ore/claretine
	name = "claretine ore"
	desc = "A heap of Claretine, a highly conductive salt."
	icon_state = "claretine"

/obj/item/weapon/ore/bohrum
	name = "bohrum ore"
	desc = "A chunk of Bohrum, a heavy and highly durable metal."
	icon_state = "bohrum"

/obj/item/weapon/ore/syreline
	name = "syreline ore"
	desc = "A chunk of Syreline, an extremely valuable and coveted metal."
	icon_state = "syreline"
// Rare Cluster Ores

/obj/item/weapon/ore/erebite
	name = "erebite ore"
	desc = "A chunk of Erebite, an extremely volatile high-energy mineral."
	icon_state = "erebite"

/obj/item/weapon/ore/erebite/ex_act()
	explosion(src.loc,-1,0,2)
	qdel(src)

/obj/item/weapon/ore/erebite/bullet_act(var/obj/item/projectile/P)
	explosion(src.loc,-1,0,2)
	qdel(src)

/obj/item/weapon/ore/cerenkite
	name = "cerenkite ore"
	desc = "A chunk of Cerenkite, a highly radioactive mineral."
	icon_state = "cerenkite"

/obj/item/weapon/ore/cerenkite/ex_act()
	var/L = get_turf(src)
	for(var/mob/living/carbon/human/M in viewers(L, null))
		M.apply_effect((rand(10, 50)), IRRADIATE, 0)
	qdel(src)
/obj/item/weapon/ore/cerenkite/attack_hand(mob/user as mob)
	var/L = get_turf(user)
	for(var/mob/living/carbon/human/M in viewers(L, null))
		M.apply_effect((rand(10, 50)), IRRADIATE, 0)
	qdel(src)
/obj/item/weapon/ore/cerenkite/bullet_act(var/obj/item/projectile/P)
	var/L = get_turf(src)
	for(var/mob/living/carbon/human/M in viewers(L, null))
		M.apply_effect((rand(10, 50)), IRRADIATE, 0)
	qdel(src)
/obj/item/weapon/ore/cytine
	name = "cytine"
	desc = "A glowing Cytine gemstone, somewhat valuable but not paticularly useful."
	icon_state = "cytine"

/obj/item/weapon/ore/uqill
	name = "uqill nugget"
	desc = "A nugget of Uqill, a rare and very dense stone."
	icon_state = "uqill"

/obj/item/weapon/ore/coal
	name = "bituminous coal"
	desc = "A lump of bituminous coal, a excellent and high-calorie fuel."
	icon_state = "coal"

/obj/item/weapon/ore/ruvium
	name = "ruvium ore"
	desc = "A chunk of Ruvium, a conductive metal."
	icon_state = "ruvium"

/obj/item/weapon/ore/lovite
	name = "lovite crystal"
	desc = "A crystal of Lovite, a rare and very homogaye crystal."
	icon_state = "lovite"

/obj/item/weapon/ore/telecrystal
	name = "telecrystal"
	desc = "A large unprocessed telecrystal, a gemstone with space-warping properties."
	icon_state = "telecrystal"

/obj/item/weapon/ore/eldritch
	name = "eldritch ore"
	icon_state = "eldritch"

/obj/item/weapon/ore/martian
	name = "martian ore"
	icon_state = "martian"

/obj/item/weapon/ore/fibrilith
	name = "fibrilith ore"
	icon_state = "fibrilith"

/obj/item/weapon/ore/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/*****************************Coin********************************/

/obj/item/weapon/coin
	icon = 'icons/obj/items.dmi'
	name = "Coin"
	icon_state = "coin"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 0.0
	throwforce = 0.0
	w_class = 1.0
	var/value = 1
	var/string_attached

/obj/item/weapon/coin/attack_self(mob/user as mob)
	var/result = rand(1, 2)
	var/comment = "Head!"
	if(result == 2)
		comment = "Tail!"
	user.visible_message("<span class='notice'>[user] has flip [src]. Catch it in the air. [comment]</span>")

/obj/item/weapon/coin/New()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/weapon/coin/gold
	name = "Gold coin"
	icon_state = "coin_gold"
	value = 100

/obj/item/weapon/coin/silver
	name = "Silver coin"
	icon_state = "coin_silver"
	value = 30

/obj/item/weapon/coin/diamond
	name = "Diamond coin"
	icon_state = "coin_diamond"
	value = 200

/obj/item/weapon/coin/iron
	name = "Iron coin"
	icon_state = "coin_iron"
	value = 10

/obj/item/weapon/coin/plasma
	name = "Solid plasma coin"
	icon_state = "coin_plasma"
	value = 150

/obj/item/weapon/coin/uranium
	name = "Uranium coin"
	icon_state = "coin_uranium"
	value = 110

/obj/item/weapon/coin/clown
	name = "Bananaium coin"
	icon_state = "coin_clown"
	value = 9999

/obj/item/weapon/coin/adamantine
	name = "Adamantine coin"
	icon_state = "coin_adamantine"
	value = 500

/obj/item/weapon/coin/mythril
	name = "Mythril coin"
	icon_state = "coin_mythril"
	value = 1000

/obj/item/weapon/coin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/CC = W
		if(string_attached)
			user << "\blue There already is a string attached to this coin."
			return

		if(CC.amount <= 0)
			user << "\blue This cable coil appears to be empty."
			qdel(CC)
			return

		overlays += image('icons/obj/items.dmi',"coin_string_overlay")
		string_attached = 1
		user << "\blue You attach a string to the coin."
		CC.use(1)
	else if(istype(W,/obj/item/weapon/wirecutters) )
		if(!string_attached)
			..()
			return

		var/obj/item/weapon/cable_coil/CC = new/obj/item/weapon/cable_coil(user.loc)
		CC.amount = 1
		CC.updateicon()
		overlays = list()
		string_attached = null
		user << "\blue You detach the string from the coin."
	else ..()
