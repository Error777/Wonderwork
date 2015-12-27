/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/processing_unit/machine = null
	var/machinedir = EAST

/obj/machinery/mineral/processing_unit_console/New()
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/mineral/processing_unit, get_step(src, machinedir))
		if (machine)
			machine.CONSOLE = src
		else
			del(src)

/obj/machinery/mineral/processing_unit_console/process()
	updateDialog()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat = "<b>Smelter control console</b><br><br>"
	//iron
	if(machine.ore_iron || machine.ore_glass || machine.ore_plasma || machine.ore_uranium || machine.ore_gold || machine.ore_silver || machine.ore_diamond || machine.ore_clown || machine.ore_phazon || machine.ore_aluminum || machine.ore_adamantine || machine.ore_triberium || machine.ore_mauxite || machine.ore_molitz || machine.ore_pharosium || machine.ore_cobryl || machine.ore_char || machine.ore_claretine || machine.ore_bohrum || machine.ore_syreline || machine.ore_erebite || machine.ore_cerenkite || machine.ore_cytine || machine.ore_coal || machine.ore_ruvium || machine.ore_lovite || machine.ore_telecrystal || machine.ore_martian || machine.ore_eldritch || machine.ore_ice || machine.ore_uqill)
		if(machine.ore_iron)
			if (machine.selected_iron==1)
				dat += text("<A href='?src=\ref[src];sel_iron=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_iron=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Iron: [machine.ore_iron]<br>")
		else
			machine.selected_iron = 0

		//sand - glass
		if(machine.ore_glass)
			if (machine.selected_glass==1)
				dat += text("<A href='?src=\ref[src];sel_glass=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_glass=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Sand: [machine.ore_glass]<br>")
		else
			machine.selected_glass = 0

		//plasma
		if(machine.ore_plasma)
			if (machine.selected_plasma==1)
				dat += text("<A href='?src=\ref[src];sel_plasma=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_plasma=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Plasma: [machine.ore_plasma]<br>")
		else
			machine.selected_plasma = 0

		//uranium
		if(machine.ore_uranium)
			if (machine.selected_uranium==1)
				dat += text("<A href='?src=\ref[src];sel_uranium=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_uranium=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Uranium: [machine.ore_uranium]<br>")
		else
			machine.selected_uranium = 0

		//gold
		if(machine.ore_gold)
			if (machine.selected_gold==1)
				dat += text("<A href='?src=\ref[src];sel_gold=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_gold=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Gold: [machine.ore_gold]<br>")
		else
			machine.selected_gold = 0

		//silver
		if(machine.ore_silver)
			if (machine.selected_silver==1)
				dat += text("<A href='?src=\ref[src];sel_silver=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_silver=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Silver: [machine.ore_silver]<br>")
		else
			machine.selected_silver = 0

		//diamond
		if(machine.ore_diamond)
			if (machine.selected_diamond==1)
				dat += text("<A href='?src=\ref[src];sel_diamond=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_diamond=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Diamond: [machine.ore_diamond]<br>")
		else
			machine.selected_diamond = 0

		//bananium
		if(machine.ore_clown)
			if (machine.selected_clown==1)
				dat += text("<A href='?src=\ref[src];sel_clown=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_clown=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Bananium: [machine.ore_clown]<br>")
		else
			machine.selected_clown = 0

		//phazon
		if(machine.ore_phazon)
			if (machine.selected_phazon==1)
				dat += text("<A href='?src=\ref[src];sel_phazon=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_phazon=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Phazon: [machine.ore_phazon]<br>")
		else
			machine.selected_phazon = 0

		//aluminum
		if(machine.ore_aluminum)
			if (machine.selected_aluminum==1)
				dat += text("<A href='?src=\ref[src];sel_aluminum=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_aluminum=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Aluminum: [machine.ore_aluminum]<br>")
		else
			machine.selected_aluminum = 0

		//adamantine
		if(machine.ore_adamantine)
			if (machine.selected_adamantine==1)
				dat += text("<A href='?src=\ref[src];sel_adamantine=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_adamantine=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Adamantine: [machine.ore_adamantine]<br>")
		else
			machine.selected_adamantine = 0

		//triberium
		if(machine.ore_triberium)
			if (machine.selected_triberium==1)
				dat += text("<A href='?src=\ref[src];sel_triberium=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_triberium=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Triberium: [machine.ore_triberium]<br>")
		else
			machine.selected_triberium = 0

		//mauxite
		if(machine.ore_mauxite)
			if (machine.selected_mauxite==1)
				dat += text("<A href='?src=\ref[src];sel_mauxite=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_mauxite=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Mauxite: [machine.ore_mauxite]<br>")
		else
			machine.selected_mauxite = 0

		//molitz
		if(machine.ore_molitz)
			if (machine.selected_molitz==1)
				dat += text("<A href='?src=\ref[src];sel_molitz=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_molitz=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Molitz: [machine.ore_molitz]<br>")
		else
			machine.selected_molitz = 0

		//pharosium
		if(machine.ore_pharosium)
			if (machine.selected_pharosium==1)
				dat += text("<A href='?src=\ref[src];sel_pharosium=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_pharosium=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Pharosium: [machine.ore_pharosium]<br>")
		else
			machine.selected_pharosium = 0

		//cobryl
		if(machine.ore_cobryl)
			if (machine.selected_cobryl==1)
				dat += text("<A href='?src=\ref[src];sel_cobryl=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_cobryl=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Cobryl: [machine.ore_cobryl]<br>")
		else
			machine.selected_cobryl = 0

		//char
		if(machine.ore_char)
			if (machine.selected_char==1)
				dat += text("<A href='?src=\ref[src];sel_char=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_char=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Char: [machine.ore_char]<br>")
		else
			machine.selected_char = 0

		//claretine
		if(machine.ore_claretine)
			if (machine.selected_claretine==1)
				dat += text("<A href='?src=\ref[src];sel_claretine=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_claretine=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Claretine: [machine.ore_claretine]<br>")
		else
			machine.selected_claretine = 0

		//bohrum
		if(machine.ore_bohrum)
			if (machine.selected_bohrum==1)
				dat += text("<A href='?src=\ref[src];sel_bohrum=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_bohrum=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Bohrum: [machine.ore_bohrum]<br>")
		else
			machine.selected_bohrum = 0

		//syreline
		if(machine.ore_syreline)
			if (machine.selected_syreline==1)
				dat += text("<A href='?src=\ref[src];sel_syreline=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_syreline=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Syreline: [machine.ore_syreline]<br>")
		else
			machine.selected_syreline = 0

		//erebite
		if(machine.ore_erebite)
			if (machine.selected_erebite==1)
				dat += text("<A href='?src=\ref[src];sel_erebite=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_erebite=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Erebite: [machine.ore_erebite]<br>")
		else
			machine.selected_erebite = 0

		//cerenkite
		if(machine.ore_cerenkite)
			if (machine.selected_cerenkite==1)
				dat += text("<A href='?src=\ref[src];sel_cerenkite=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_cerenkite=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Cerenkite: [machine.ore_cerenkite]<br>")
		else
			machine.selected_cerenkite = 0

		//cytine
		if(machine.ore_cytine)
			if (machine.selected_cytine==1)
				dat += text("<A href='?src=\ref[src];sel_cytine=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_cytine=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Cytine: [machine.ore_cytine]<br>")
		else
			machine.selected_cytine = 0

		//coal
		if(machine.ore_coal)
			if (machine.selected_coal==1)
				dat += text("<A href='?src=\ref[src];sel_coal=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_coal=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Coal: [machine.ore_coal]<br>")
		else
			machine.selected_coal = 0

		//ruvium
		if(machine.ore_ruvium)
			if (machine.selected_ruvium==1)
				dat += text("<A href='?src=\ref[src];sel_ruvium=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_ruvium=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Ruvium: [machine.ore_ruvium]<br>")
		else
			machine.selected_ruvium = 0

		//lovite
		if(machine.ore_lovite)
			if (machine.selected_lovite==1)
				dat += text("<A href='?src=\ref[src];sel_lovite=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_lovite=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Lovite: [machine.ore_lovite]<br>")
		else
			machine.selected_lovite = 0

		//telecrystal
		if(machine.ore_telecrystal)
			if (machine.selected_telecrystal==1)
				dat += text("<A href='?src=\ref[src];sel_telecrystal=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_telecrystal=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Telecrystal: [machine.ore_telecrystal]<br>")
		else
			machine.selected_telecrystal = 0

		//martian
		if(machine.ore_martian)
			if (machine.selected_martian==1)
				dat += text("<A href='?src=\ref[src];sel_martian=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_martian=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Martian: [machine.ore_martian]<br>")
		else
			machine.selected_martian = 0

		//eldritch
		if(machine.ore_eldritch)
			if (machine.selected_eldritch==1)
				dat += text("<A href='?src=\ref[src];sel_eldritch=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_eldritch=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Eldritch: [machine.ore_eldritch]<br>")
		else
			machine.selected_eldritch = 0

		//ice
		if(machine.ore_ice)
			if (machine.selected_ice==1)
				dat += text("<A href='?src=\ref[src];sel_ice=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_ice=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Ice: [machine.ore_ice]<br>")
		else
			machine.selected_ice = 0

		//uqill
		if(machine.ore_uqill)
			if (machine.selected_uqill==1)
				dat += text("<A href='?src=\ref[src];sel_uqill=no'><font color='green'>Smelting</font></A> ")
			else
				dat += text("<A href='?src=\ref[src];sel_uqill=yes'><font color='red'>Not smelting</font></A> ")
			dat += text("Uqill: [machine.ore_uqill]<br>")
		else
			machine.selected_uqill = 0

		//On or off
		dat += text("Machine is currently ")
		if (machine.on==1)
			dat += text("<A href='?src=\ref[src];set_on=off'>On</A> ")
		else
			dat += text("<A href='?src=\ref[src];set_on=on'>Off</A> ")
	else
		dat+="---No Materials Loaded---"


	user << browse("[dat]", "window=console_processing_unit")
	onclose(user, "console_processing_unit")


/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["sel_iron"])
		if (href_list["sel_iron"] == "yes")
			machine.selected_iron = 1
		else
			machine.selected_iron = 0
	if(href_list["sel_glass"])
		if (href_list["sel_glass"] == "yes")
			machine.selected_glass = 1
		else
			machine.selected_glass = 0
	if(href_list["sel_plasma"])
		if (href_list["sel_plasma"] == "yes")
			machine.selected_plasma = 1
		else
			machine.selected_plasma = 0
	if(href_list["sel_uranium"])
		if (href_list["sel_uranium"] == "yes")
			machine.selected_uranium = 1
		else
			machine.selected_uranium = 0
	if(href_list["sel_gold"])
		if (href_list["sel_gold"] == "yes")
			machine.selected_gold = 1
		else
			machine.selected_gold = 0
	if(href_list["sel_silver"])
		if (href_list["sel_silver"] == "yes")
			machine.selected_silver = 1
		else
			machine.selected_silver = 0
	if(href_list["sel_diamond"])
		if (href_list["sel_diamond"] == "yes")
			machine.selected_diamond = 1
		else
			machine.selected_diamond = 0
	if(href_list["sel_clown"])
		if (href_list["sel_clown"] == "yes")
			machine.selected_clown = 1
		else
			machine.selected_clown = 0
	if(href_list["sel_phazon"])
		if (href_list["sel_phazon"] == "yes")
			machine.selected_phazon = 1
		else
			machine.selected_phazon = 0
	if(href_list["sel_aluminum"])
		if (href_list["sel_aluminum"] == "yes")
			machine.selected_aluminum = 1
		else
			machine.selected_aluminum = 0
	if(href_list["sel_adamantine"])
		if (href_list["sel_adamantine"] == "yes")
			machine.selected_adamantine = 1
		else
			machine.selected_adamantine = 0
	if(href_list["sel_triberium"])
		if (href_list["sel_triberium"] == "yes")
			machine.selected_triberium = 1
		else
			machine.selected_triberium = 0
	if(href_list["sel_mauxite"])
		if (href_list["sel_mauxite"] == "yes")
			machine.selected_mauxite = 1
		else
			machine.selected_mauxite = 0
	if(href_list["sel_molitz"])
		if (href_list["sel_molitz"] == "yes")
			machine.selected_molitz = 1
		else
			machine.selected_molitz = 0
	if(href_list["sel_pharosium"])
		if (href_list["sel_pharosium"] == "yes")
			machine.selected_pharosium = 1
		else
			machine.selected_pharosium = 0
	if(href_list["sel_cobryl"])
		if (href_list["sel_cobryl"] == "yes")
			machine.selected_cobryl = 1
		else
			machine.selected_cobryl = 0
	if(href_list["sel_char"])
		if (href_list["sel_char"] == "yes")
			machine.selected_char = 1
		else
			machine.selected_char = 0
	if(href_list["sel_claretine"])
		if (href_list["sel_claretine"] == "yes")
			machine.selected_claretine = 1
		else
			machine.selected_claretine = 0
	if(href_list["sel_bohrum"])
		if (href_list["sel_bohrum"] == "yes")
			machine.selected_bohrum = 1
		else
			machine.selected_bohrum = 0
	if(href_list["sel_syreline"])
		if (href_list["sel_syreline"] == "yes")
			machine.selected_syreline = 1
		else
			machine.selected_syreline = 0
	if(href_list["sel_erebite"])
		if (href_list["sel_erebite"] == "yes")
			machine.selected_erebite = 1
		else
			machine.selected_erebite = 0
	if(href_list["sel_cerenkite"])
		if (href_list["sel_cerenkite"] == "yes")
			machine.selected_cerenkite = 1
		else
			machine.selected_cerenkite = 0
	if(href_list["sel_cytine"])
		if (href_list["sel_cytine"] == "yes")
			machine.selected_cytine = 1
		else
			machine.selected_cytine = 0
	if(href_list["sel_coal"])
		if (href_list["sel_coal"] == "yes")
			machine.selected_coal = 1
		else
			machine.selected_coal = 0
	if(href_list["sel_ruvium"])
		if (href_list["sel_ruvium"] == "yes")
			machine.selected_ruvium = 1
		else
			machine.selected_ruvium = 0
	if(href_list["sel_lovite"])
		if (href_list["sel_lovite"] == "yes")
			machine.selected_lovite = 1
		else
			machine.selected_lovite = 0
	if(href_list["sel_telecrystal"])
		if (href_list["sel_telecrystal"] == "yes")
			machine.selected_telecrystal = 1
		else
			machine.selected_telecrystal = 0
	if(href_list["sel_martian"])
		if (href_list["sel_martian"] == "yes")
			machine.selected_martian = 1
		else
			machine.selected_martian = 0
	if(href_list["sel_eldritch"])
		if (href_list["sel_eldritch"] == "yes")
			machine.selected_eldritch = 1
		else
			machine.selected_eldritch = 0
	if(href_list["sel_ice"])
		if (href_list["sel_ice"] == "yes")
			machine.selected_ice = 1
		else
			machine.selected_ice = 0
	if(href_list["sel_uqill"])
		if (href_list["sel_uqill"] == "yes")
			machine.selected_uqill = 1
		else
			machine.selected_uqill = 0
	if(href_list["set_on"])
		if (href_list["set_on"] == "on")
			machine.on = 1
		else
			machine.on = 0
	src.updateUsrDialog()
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "furnace"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/CONSOLE = null
	var/ore_gold = 0;
	var/ore_silver = 0;
	var/ore_diamond = 0;
	var/ore_glass = 0;
	var/ore_plasma = 0;
	var/ore_uranium = 0;
	var/ore_iron = 0;
	var/ore_clown = 0;
	var/ore_phazon = 0
	var/ore_aluminum = 0
	var/ore_adamantine = 0
	var/ore_triberium = 0
	var/ore_mauxite = 0
	var/ore_molitz = 0
	var/ore_pharosium = 0
	var/ore_cobryl = 0
	var/ore_char = 0
	var/ore_claretine = 0
	var/ore_bohrum = 0
	var/ore_syreline = 0
	var/ore_erebite = 0
	var/ore_cerenkite = 0
	var/ore_cytine = 0
	var/ore_coal = 0
	var/ore_ruvium = 0
	var/ore_lovite = 0
	var/ore_telecrystal = 0
	var/ore_martian = 0
	var/ore_eldritch = 0
	var/ore_ice = 0
	var/ore_uqill = 0
	var/selected_gold = 0
	var/selected_silver = 0
	var/selected_diamond = 0
	var/selected_glass = 0
	var/selected_plasma = 0
	var/selected_uranium = 0
	var/selected_iron = 0
	var/selected_clown = 0
	var/selected_phazon = 0
	var/selected_aluminum = 0
	var/selected_adamantine = 0
	var/selected_triberium = 0
	var/selected_mauxite = 0
	var/selected_molitz = 0
	var/selected_pharosium = 0
	var/selected_cobryl = 0
	var/selected_char = 0
	var/selected_claretine = 0
	var/selected_bohrum = 0
	var/selected_syreline = 0
	var/selected_erebite = 0
	var/selected_cerenkite = 0
	var/selected_cytine = 0
	var/selected_coal = 0
	var/selected_ruvium = 0
	var/selected_lovite = 0
	var/selected_telecrystal = 0
	var/selected_martian = 0
	var/selected_eldritch = 0
	var/selected_ice = 0
	var/selected_uqill = 0
	var/on = 0 //0 = off, 1 =... oh you know!

/obj/machinery/mineral/processing_unit/New()
	..()
	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		processing_objects.Add(src)
		return
	return

/obj/machinery/mineral/processing_unit/process()
	if (src.output && src.input)
		var/i
		for (i = 0; i < 10; i++)
			if (on)
				if (selected_glass == 1 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_glass > 0)
						ore_glass--;
						new /obj/item/stack/sheet/glass(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 1 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 1 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_glass > 0 && ore_iron > 0)
						ore_glass--;
						ore_iron--;
						new /obj/item/stack/sheet/rglass(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 1 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_gold > 0)
						ore_gold--;
						new /obj/item/stack/sheet/mineral/gold(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 1 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_silver > 0)
						ore_silver--;
						new /obj/item/stack/sheet/mineral/silver(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 1 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_diamond > 0)
						ore_diamond--;
						new /obj/item/stack/sheet/mineral/diamond(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 1 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_plasma > 0)
						ore_plasma--;
						new /obj/item/stack/sheet/mineral/plasma(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 1 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_uranium > 0)
						ore_uranium--;
						new /obj/item/stack/sheet/mineral/uranium(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 1 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_iron > 0)
						ore_iron--;
						new /obj/item/stack/sheet/metal(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 1 && selected_uranium == 0 && selected_iron == 1 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_iron > 0 && ore_plasma > 0)
						ore_iron--;
						ore_plasma--;
						new /obj/item/stack/sheet/plasteel(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 1 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_clown > 0)
						ore_clown--;
						new /obj/item/stack/sheet/mineral/clown(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				//NEW MINERALS AND ORE
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 1 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_phazon > 0)
						ore_phazon--;
						new /obj/item/stack/sheet/mineral/phazon(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 1 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_aluminum > 0)
						ore_aluminum--;
						new /obj/item/stack/sheet/mineral/aluminum(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 1 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_adamantine > 0)
						ore_adamantine--;
						new /obj/item/stack/sheet/mineral/adamantine(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 1 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_triberium > 0)
						ore_triberium--;
						new /obj/item/stack/sheet/mineral/triberium(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 1 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_mauxite > 0)
						ore_mauxite--;
						new /obj/item/stack/sheet/mineral/mauxite(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 1 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_molitz > 0)
						ore_molitz--;
						new /obj/item/stack/sheet/mineral/molitz(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 1 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_pharosium > 0)
						ore_pharosium--;
						new /obj/item/stack/sheet/mineral/pharosium(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 1 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_cobryl > 0)
						ore_cobryl--;
						new /obj/item/stack/sheet/mineral/cobryl(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 1 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_char > 0)
						ore_char--;
						new /obj/item/stack/sheet/mineral/char(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 1 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_claretine > 0)
						ore_claretine--;
						new /obj/item/stack/sheet/mineral/claretine(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 1 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_bohrum > 0)
						ore_bohrum--;
						new /obj/item/stack/sheet/mineral/bohrum(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 1 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_syreline > 0)
						ore_syreline--;
						new /obj/item/stack/sheet/mineral/syreline(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 1 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_erebite > 0)
						ore_erebite--;
						new /obj/item/stack/sheet/mineral/erebite(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 1 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_cerenkite > 0)
						ore_cerenkite--;
						new /obj/item/stack/sheet/mineral/cerenkite(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 1 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_cytine > 0)
						ore_cytine--;
						new /obj/item/stack/sheet/mineral/cytine(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 1 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_ruvium > 0)
						ore_ruvium--;
						new /obj/item/stack/sheet/mineral/ruvium(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 1 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_lovite > 0)
						ore_lovite--;
						new /obj/item/stack/sheet/mineral/lovite(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 1 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_telecrystal > 0)
						ore_telecrystal--;
						new /obj/item/stack/sheet/mineral/telecrystal(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 1 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 0)
					if (ore_martian > 0)
						ore_martian--;
						new /obj/item/stack/sheet/mineral/martian(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 1 && selected_ice == 0 && selected_uqill == 0)
					if (ore_eldritch > 0)
						ore_eldritch--;
						new /obj/item/stack/sheet/mineral/eldritch(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 1 && selected_uqill == 0)
					if (ore_ice > 0)
						ore_ice--;
						new /obj/item/stack/sheet/mineral/ice(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 0 && selected_plasma == 0 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0 && selected_phazon == 0 && selected_aluminum == 0 && selected_adamantine == 0 && selected_triberium == 0 && selected_mauxite == 0 && selected_molitz == 0 && selected_pharosium == 0 && selected_cobryl == 0 && selected_char == 0 && selected_claretine == 0 && selected_bohrum == 0 && selected_syreline == 0 && selected_erebite == 0 && selected_cerenkite == 0 && selected_cytine == 0 && selected_coal == 0 && selected_ruvium == 0 && selected_lovite == 0 && selected_telecrystal == 0 && selected_martian == 0 && selected_eldritch == 0 && selected_ice == 0 && selected_uqill == 1)
					if (ore_uqill > 0)
						ore_uqill--;
						new /obj/item/stack/sheet/mineral/uqill(output.loc)
						CONSOLE.updateDialog()
					else
						on = 0
					continue
				//THESE TWO ARE CODED FOR URIST TO USE WHEN HE GETS AROUND TO IT.
				//They were coded on 18 Feb 2012. If you're reading this in 2015, then firstly congratulations on the world not ending on 21 Dec 2012 and secondly, Urist is apparently VERY lazy. ~Errorage
				/*if (selected_glass == 0 && selected_gold == 0 && selected_silver == 0 && selected_diamond == 1 && selected_plasma == 0 && selected_uranium == 1 && selected_iron == 0 && selected_clown == 0)
					if (ore_uranium >= 2 && ore_diamond >= 1)
						ore_uranium -= 2
						ore_diamond -= 1
						new /obj/item/stack/sheet/mineral/adamantine(output.loc)
					else
						on = 0
					continue
				if (selected_glass == 0 && selected_gold == 0 && selected_silver == 1 && selected_diamond == 0 && selected_plasma == 1 && selected_uranium == 0 && selected_iron == 0 && selected_clown == 0)
					if (ore_silver >= 1 && ore_plasma >= 3)
						ore_silver -= 1
						ore_plasma -= 3
						new /obj/item/stack/sheet/mineral/mythril(output.loc)
					else
						on = 0
					continue*/


				//if a non valid combination is selected

				var/b = 1 //this part checks if all required ores are available

				if (!(selected_gold || selected_silver ||selected_diamond || selected_uranium | selected_plasma || selected_iron || selected_clown || selected_phazon || selected_aluminum || selected_adamantine || selected_triberium || selected_mauxite || selected_molitz || selected_pharosium || selected_cobryl || selected_char || selected_claretine || selected_bohrum || selected_syreline || selected_erebite || selected_cerenkite || selected_cytine || selected_coal || selected_ruvium || selected_lovite || selected_telecrystal || selected_martian || selected_eldritch || selected_ice || selected_uqill))
					b = 0

				if (selected_gold == 1)
					if (ore_gold <= 0)
						b = 0
				if (selected_silver == 1)
					if (ore_silver <= 0)
						b = 0
				if (selected_diamond == 1)
					if (ore_diamond <= 0)
						b = 0
				if (selected_uranium == 1)
					if (ore_uranium <= 0)
						b = 0
				if (selected_plasma == 1)
					if (ore_plasma <= 0)
						b = 0
				if (selected_iron == 1)
					if (ore_iron <= 0)
						b = 0
				if (selected_glass == 1)
					if (ore_glass <= 0)
						b = 0
				if (selected_clown == 1)
					if (ore_clown <= 0)
						b = 0
				if (selected_phazon == 1)
					if (ore_phazon <= 0)
						b = 0
				if (selected_aluminum == 1)
					if (ore_aluminum <= 0)
						b = 0
				if (selected_adamantine == 1)
					if (ore_adamantine <= 0)
						b = 0
				if (selected_triberium == 1)
					if (ore_triberium <= 0)
						b = 0
				if (selected_mauxite == 1)
					if (ore_mauxite <= 0)
						b = 0
				if (selected_molitz == 1)
					if (ore_molitz <= 0)
						b = 0
				if (selected_pharosium == 1)
					if (ore_pharosium <= 0)
						b = 0
				if (selected_cobryl == 1)
					if (ore_cobryl <= 0)
						b = 0
				if (selected_char == 1)
					if (ore_char <= 0)
						b = 0
				if (selected_claretine == 1)
					if (ore_claretine <= 0)
						b = 0
				if (selected_bohrum == 1)
					if (ore_bohrum <= 0)
						b = 0
				if (selected_syreline == 1)
					if (ore_syreline <= 0)
						b = 0
				if (selected_erebite == 1)
					if (ore_erebite <= 0)
						b = 0
				if (selected_cerenkite == 1)
					if (ore_cerenkite <= 0)
						b = 0
				if (selected_cytine == 1)
					if (ore_cytine <= 0)
						b = 0
				if (selected_coal == 1)
					if (ore_coal <= 0)
						b = 0
				if (selected_ruvium == 1)
					if (ore_ruvium <= 0)
						b = 0
				if (selected_lovite == 1)
					if (ore_lovite <= 0)
						b = 0
				if (selected_telecrystal == 1)
					if (ore_telecrystal <= 0)
						b = 0
				if (selected_martian == 1)
					if (ore_martian <= 0)
						b = 0
				if (selected_eldritch == 1)
					if (ore_eldritch <= 0)
						b = 0
				if (selected_ice == 1)
					if (ore_ice <= 0)
						b = 0
				if (selected_uqill == 1)
					if (ore_uqill <= 0)
						b = 0

				if (b) //if they are, deduct one from each, produce slag and shut the machine off
					if (selected_gold == 1)
						ore_gold--
					if (selected_silver == 1)
						ore_silver--
					if (selected_diamond == 1)
						ore_diamond--
					if (selected_uranium == 1)
						ore_uranium--
					if (selected_plasma == 1)
						ore_plasma--
					if (selected_iron == 1)
						ore_iron--
					if (selected_clown == 1)
						ore_clown--
					if (selected_phazon == 1)
						ore_phazon--
					if (selected_aluminum == 1)
						ore_aluminum--
					if (selected_adamantine == 1)
						ore_adamantine--
					if (selected_triberium == 1)
						ore_triberium--
					if (selected_mauxite == 1)
						ore_mauxite--
					if (selected_molitz == 1)
						ore_molitz--
					if (selected_pharosium == 1)
						ore_pharosium--
					if (selected_cobryl == 1)
						ore_cobryl--
					if (selected_char == 1)
						ore_char--
					if (selected_claretine == 1)
						ore_claretine--
					if (selected_bohrum == 1)
						ore_bohrum--
					if (selected_syreline == 1)
						ore_syreline--
					if (selected_erebite == 1)
						ore_erebite--
					if (selected_cerenkite == 1)
						ore_cerenkite--
					if (selected_cytine == 1)
						ore_cytine--
					if (selected_coal == 1)
						ore_coal--
					if (selected_ruvium == 1)
						ore_ruvium--
					if (selected_lovite == 1)
						ore_lovite--
					if (selected_telecrystal == 1)
						ore_telecrystal--
					if (selected_martian == 1)
						ore_martian--
					if (selected_eldritch == 1)
						ore_eldritch--
					if (selected_ice == 1)
						ore_ice--
					if (selected_uqill == 1)
						ore_uqill--
					new /obj/item/weapon/ore/slag(output.loc)
					on = 0
				else
					on = 0
					break
				break
			else
				break
		for (i = 0; i < 10; i++)
			var/obj/item/O
			O = locate(/obj/item, input.loc)
			if (O)
				if (istype(O,/obj/item/weapon/ore/iron))
					ore_iron++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/glass))
					ore_glass++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/diamond))
					ore_diamond++;
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/plasma))
					ore_plasma++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/gold))
					ore_gold++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/silver))
					ore_silver++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/uranium))
					ore_uranium++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/clown))
					ore_clown++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/phazon))
					ore_phazon++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/aluminum))
					ore_aluminum++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/adamantine))
					ore_adamantine++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/triberium))
					ore_triberium++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/mauxite))
					ore_mauxite++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/molitz))
					ore_molitz++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/pharosium))
					ore_pharosium++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/cobryl))
					ore_cobryl++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/char))
					ore_char++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/claretine))
					ore_claretine++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/bohrum))
					ore_bohrum++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/syreline))
					ore_syreline++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/erebite))
					ore_erebite++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/cerenkite))
					ore_cerenkite++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/cytine))
					ore_cytine++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/coal))
					ore_coal++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/ruvium))
					ore_ruvium++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/lovite))
					ore_lovite++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/telecrystal))
					ore_telecrystal++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/martian))
					ore_martian++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/eldritch))
					ore_eldritch++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/ice))
					ore_ice++
					del(O)
					continue
				if (istype(O,/obj/item/weapon/ore/uqill))
					ore_uqill++
					del(O)
					continue
				O.loc = src.output.loc
			else
				break
	return