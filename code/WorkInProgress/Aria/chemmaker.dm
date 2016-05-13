/obj/item/chemmaker
	var/chemid = "water"
	var/chemammount = 10
	icon = 'icons/obj/adv_stock_parts.dmi'
	icon_state = "cartridge"
	invisibility = 101

/obj/item/chemmaker/New()
	var/atom/A = loc
	if(A && A.reagents)
		A.reagents.add_reagent(chemid,chemammount)

/obj/item/chemmaker/iron
	name = "200 units of Iron"
	chemid = "iron"
	chemammount = 200

/obj/item/chemmaker/copper
	name = "100 units of Copper"
	chemid = "copper"
	chemammount = 100

/obj/item/chemmaker/glass
	name = "200 units of Glass"
	chemid = "glass"
	chemammount = 200

/obj/item/chemmaker/gold
	name = "200 units of Gold"
	chemid = "gold"
	chemammount = 200

/obj/item/chemmaker/silver
	name = "200 units of Silver"
	chemid = "silver"
	chemammount = 200

/obj/item/chemmaker/uranium
	name = "100 units of Uranium"
	chemid = "uranium"
	chemammount = 100

/obj/item/chemmaker/diamond
	name = "100 units of Diamond"
	chemid = "diamond"
	chemammount = 100

/obj/item/chemmaker/adamantine
	name = "100 units of Adamantine"
	chemid = "adamantine"
	chemammount = 100

/obj/item/chemmaker/phazon
	name = "100 units of Phazon"
	chemid = "phazon"
	chemammount = 100

/obj/item/chemmaker/plasma
	name = "200 units of Plasma"
	chemid = "plasma"
	chemammount = 200

/obj/item/chemmaker/coalfiber
	name = "400 units of Carbonfiber"
	chemid = "coalfiber"
	chemammount = 400

/obj/item/chemmaker/fiber
	name = "400 units of Fiber"
	chemid = "fiber"
	chemammount = 400

/obj/item/chemmaker/rubber
	name = "400 units of Rubber"
	chemid = "rubber"
	chemammount = 400

/obj/item/chemmaker/latex
	name = "400 units of Latex"
	chemid = "latex"
	chemammount = 400

/obj/item/chemmaker/coal
	name = "100 units of Coal"
	chemid = "coal"
	chemammount = 100