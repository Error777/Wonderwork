
/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "Ore Box"
	desc = "A heavy box used for storing ore."
	density = 1

/obj/structure/ore_box/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/ore))
		src.contents += W;
	if (istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		S.hide_from(usr)
		for(var/obj/item/weapon/ore/O in S.contents)
			S.remove_from_storage(O, src) //This will move the item to this item's contents
		user << "\blue You empty the satchel into the box."
	return

/obj/structure/ore_box/attack_hand(obj, mob/user as mob)
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_glass = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_phazon = 0
	var/amt_aluminum = 0
	var/amt_adamantine = 0
	var/amt_triberium = 0
	var/amt_mauxite = 0
	var/amt_molitz = 0
	var/amt_pharosium = 0
	var/amt_cobryl = 0
	var/amt_char = 0
	var/amt_claretine = 0
	var/amt_bohrum = 0
	var/amt_syreline = 0
	var/amt_erebite = 0
	var/amt_cerenkite = 0
	var/amt_cytine = 0
	var/amt_coal = 0
	var/amt_ruvium = 0
	var/amt_lovite = 0
	var/amt_telecrystal = 0
	var/amt_martian = 0
	var/amt_eldritch = 0
	var/amt_ice = 0
	var/amt_uqill = 0
	var/amt_strange = 0


	for (var/obj/item/weapon/ore/C in contents)
		if (istype(C,/obj/item/weapon/ore/diamond))
			amt_diamond++;
		if (istype(C,/obj/item/weapon/ore/glass))
			amt_glass++;
		if (istype(C,/obj/item/weapon/ore/plasma))
			amt_plasma++;
		if (istype(C,/obj/item/weapon/ore/iron))
			amt_iron++;
		if (istype(C,/obj/item/weapon/ore/silver))
			amt_silver++;
		if (istype(C,/obj/item/weapon/ore/gold))
			amt_gold++;
		if (istype(C,/obj/item/weapon/ore/uranium))
			amt_uranium++;
		if (istype(C,/obj/item/weapon/ore/clown))
			amt_clown++;
		if (istype(C,/obj/item/weapon/ore/phazon))
			amt_phazon++;
		if (istype(C,/obj/item/weapon/ore/aluminum))
			amt_aluminum++;
		if (istype(C,/obj/item/weapon/ore/adamantine))
			amt_adamantine++;
		if (istype(C,/obj/item/weapon/ore/triberium))
			amt_triberium++;
		if (istype(C,/obj/item/weapon/ore/mauxite))
			amt_mauxite++;
		if (istype(C,/obj/item/weapon/ore/molitz))
			amt_molitz++;
		if (istype(C,/obj/item/weapon/ore/pharosium))
			amt_pharosium++;
		if (istype(C,/obj/item/weapon/ore/cobryl))
			amt_cobryl++;
		if (istype(C,/obj/item/weapon/ore/char))
			amt_char++;
		if (istype(C,/obj/item/weapon/ore/claretine))
			amt_claretine++;
		if (istype(C,/obj/item/weapon/ore/bohrum))
			amt_bohrum++;
		if (istype(C,/obj/item/weapon/ore/syreline))
			amt_syreline++;
		if (istype(C,/obj/item/weapon/ore/erebite))
			amt_erebite++;
		if (istype(C,/obj/item/weapon/ore/cerenkite))
			amt_cerenkite++;
		if (istype(C,/obj/item/weapon/ore/cytine))
			amt_cytine++;
		if (istype(C,/obj/item/weapon/ore/coal))
			amt_coal++;
		if (istype(C,/obj/item/weapon/ore/ruvium))
			amt_ruvium++;
		if (istype(C,/obj/item/weapon/ore/lovite))
			amt_lovite++;
		if (istype(C,/obj/item/weapon/ore/telecrystal))
			amt_telecrystal++;
		if (istype(C,/obj/item/weapon/ore/martian))
			amt_martian++;
		if (istype(C,/obj/item/weapon/ore/eldritch))
			amt_eldritch++;
		if (istype(C,/obj/item/weapon/ore/ice))
			amt_ice++;
		if (istype(C,/obj/item/weapon/ore/uqill))
			amt_uqill++;
		if (istype(C,/obj/item/weapon/ore/strangerock))
			amt_strange++;

	var/dat = text("<b>The contents of the ore box reveal...</b><br>")
	if (amt_gold)
		dat += text("Gold ore: [amt_gold]<br>")
	if (amt_silver)
		dat += text("Silver ore: [amt_silver]<br>")
	if (amt_iron)
		dat += text("Metal ore: [amt_iron]<br>")
	if (amt_glass)
		dat += text("Sand: [amt_glass]<br>")
	if (amt_diamond)
		dat += text("Diamond ore: [amt_diamond]<br>")
	if (amt_plasma)
		dat += text("Plasma ore: [amt_plasma]<br>")
	if (amt_uranium)
		dat += text("Uranium ore: [amt_uranium]<br>")
	if (amt_clown)
		dat += text("Bananium ore: [amt_clown]<br>")
	if (amt_phazon)
		dat += text("Phazite ore: [amt_phazon]<br>")
	if (amt_aluminum)
		dat += text("Aluminum ore: [amt_aluminum]<br>")
	if (amt_adamantine)
		dat += text("Adamantine ore: [amt_adamantine]<br>")
	if (amt_triberium)
		dat += text("Triberium ore: [amt_triberium]<br>")
	if (amt_mauxite)
		dat += text("Mauxite ore: [amt_mauxite]<br>")
	if (amt_molitz)
		dat += text("Molitz crystal: [amt_molitz]<br>")
	if (amt_pharosium)
		dat += text("Pharosium ore: [amt_pharosium]<br>")
	if (amt_cobryl)
		dat += text("Cobryl ore: [amt_cobryl]<br>")
	if (amt_char)
		dat += text("Char: [amt_char]<br>")
	if (amt_claretine)
		dat += text("Claretine ore: [amt_claretine]<br>")
	if (amt_bohrum)
		dat += text("Bohrum ore: [amt_bohrum]<br>")
	if (amt_syreline)
		dat += text("Syreline ore: [amt_syreline]<br>")
	if (amt_erebite)
		dat += text("Erebite ore: [amt_erebite]<br>")
	if (amt_cerenkite)
		dat += text("Cerenkite ore: [amt_cerenkite]<br>")
	if (amt_cytine)
		dat += text("Cytine: [amt_cytine]<br>")
	if (amt_coal)
		dat += text("Coal: [amt_coal]<br>")
	if (amt_ruvium)
		dat += text("Ruvium ore: [amt_ruvium]<br>")
	if (amt_lovite)
		dat += text("Lovite crystal: [amt_lovite]<br>")
	if (amt_telecrystal)
		dat += text("Raw Telecrystal: [amt_telecrystal]<br>")
	if (amt_martian)
		dat += text("Martian ore: [amt_martian]<br>")
	if (amt_eldritch)
		dat += text("Eldritch ore: [amt_eldritch]<br>")
	if (amt_ice)
		dat += text("Rotten Ice: [amt_ice]<br>")
	if (amt_uqill)
		dat += text("Uqill Nugget: [amt_uqill]<br>")
	if (amt_strange)
		dat += text("Strange rocks: [amt_strange]<br>")

	dat += text("<br><br><A href='?src=\ref[src];removeall=1'>Empty box</A>")
	user << browse("[dat]", "window=orebox")
	return

/obj/structure/ore_box/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["removeall"])
		for (var/obj/item/weapon/ore/O in contents)
			contents -= O
			O.loc = src.loc
		usr << "\blue You empty the box"
	src.updateUsrDialog()
	return

