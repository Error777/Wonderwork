/obj/machinery/disassembler
	name = "Disassembler"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "a_analyzer"
	density = 1
	anchored = 1
	use_power = 1
	flags = OPENCONTAINER | NOREACT

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire
	var/opened = 0
	var/building
	var/volume = 25000
	var/maxcontents = 150
	var/input = 0
	var/eject = 0
	var/eject_speed = 1

	var/indir = 8
	var/outdir = 4

	var/sleep = 0
	var/maxwork = 10

	var/obj/selecteditem
	var/datum/assemblerprint/selectedrecipe

	var/error

	var/obj/item/weapon/blueprintdisk/recipedisk
	var/canresearch = 1
	var/list/possiblerecipes = list()

	var/screen = 0

/obj/machinery/disassembler/New()
	..()

	wires["Red"] = 0
	wires["Blue"] = 0
	wires["Green"] = 0
	wires["Yellow"] = 0
	wires["Black"] = 0
	wires["White"] = 0
	var/list/w = list("Red","Blue","Green","Yellow","Black","White")
	src.hack_wire = pick(w)
	w -= src.hack_wire
	src.shock_wire = pick(w)
	w -= src.shock_wire
	src.disable_wire = pick(w)
	w -= src.disable_wire

	var/datum/reagents/R = new/datum/reagents(volume)		//Holder for the reagents used as materials.
	reagents = R
	R.my_atom = src

	generate_assembler_recipes()

	/*if(!assembler_recipes.len)
		for(var/recipe in typesof(/datum/assemblerprint) - recipeblacklist)
			var/datum/assemblerprint/newrecipe = new recipe(src)
			assembler_recipes += newrecipe*/

	for(var/datum/assemblerprint/recipe in assembler_recipes)
		if(recipe.simplicity >= 100)
			possiblerecipes += recipe



/obj/machinery/disassembler/proc/getrecipe(var/obj/O)
	if(!O)
		return

	for(var/datum/assemblerprint/A in assembler_recipes)
		if(A.simplicity >= 0 && ispath(O.type,A.typepath))
			return A

/obj/machinery/disassembler/proc/doresearch(var/datum/assemblerprint/recipe)
	var/datum/assemblerprint/newrecipe

	if(!recipe)
		//world << "DEBUG:no recipe found."
		return

	for(var/datum/assemblerprint/A in assembler_recipes)
		//world << "DEBUG: checking [A.name]."
		//world << "[recipe.typepath] to [A.typepath]"

		if(ispath(recipe.typepath,A.typepath) && !(A in possiblerecipes))
			if(prob(A.simplicity))
				newrecipe = A
		else if(!(A in possiblerecipes))
			for(var/rtype in A.components)
				if(ispath(recipe.typepath,rtype) && prob(A.simplicity))
					newrecipe = A

	if(newrecipe)
		error = "NEW DISCOVERY<BR><BR>"
		error += "[newrecipe.name]<BR><BR>"
		error += "[newrecipe.desc]<BR><BR>"
		screen = 0.2
		possiblerecipes += newrecipe
		return 1

	return

/obj/machinery/disassembler/proc/shock(mob/user, prb)
	if(stat & (BROKEN|NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if (electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/disassembler/proc/autoinsert(var/obj/O)
	if (istype(O,/obj/item/stack))
		var/obj/item/stack/S = O

		var/amount = S.amount

		for(var/i = 1,i <= amount,i++)
			new S.type(src)
		qdel(S)
	else if (istype(O,/obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/C = O

		var/amount = C.amount

		for(var/i = 1,i <= amount,i++)
			var/obj/item/weapon/cable_coil/CN = new C.type(src)
			CN.amount = 1
			CN.color = C.color
			CN.updateicon()
		C.use(amount)
	else if (istype(O,/obj/item/weapon/liquidcartridge))
		O.reagents.trans_to(src,O.reagents.total_volume)
		qdel(O)
	else
		O.loc = src

/obj/machinery/disassembler/proc/insert(var/obj/O,var/mob/user)
	if (istype(O,/obj/item/stack))
		var/obj/item/stack/S = O

		var/amount = round(input("How many sheets do you want to add?") as num)
		if(amount < 0)
			amount = 0
		if(amount == 0)
			return
		if(amount > S.amount)
			amount = min(S.amount, amount)

		for(var/i = 1,i <= amount,i++)
			new S.type(src)
		user << "You insert [amount] [S.singular_name ? S.singular_name : S.name][amount>1?"s":""]."
		S.use(amount)
	else if (istype(O,/obj/item/weapon/cable_coil))
		var/obj/item/weapon/cable_coil/C = O

		var/amount = round(input("How many cablelengths do you want to add?") as num)
		if(amount < 0)
			amount = 0
		if(amount == 0)
			return
		if(amount > C.amount)
			amount = min(C.amount, amount)

		for(var/i = 1,i <= amount,i++)
			var/obj/item/weapon/cable_coil/CN = new C.type(src)
			CN.amount = 1
			CN.color = C.color
			CN.updateicon()
		user << "You insert [amount] piece[amount>1?"s":""] of cable."
		C.use(amount)
	else if (istype(O,/obj/item/weapon/liquidcartridge))
		O.reagents.trans_to(src,O.reagents.total_volume)
		qdel(O)
		user << "You insert a liquid cartridge."
	else
		usr.before_take_item(O)
		O.loc = src
		user << "You insert \the [O]."

/obj/machinery/disassembler/proc/eject(var/obj/O)
	var/turf/D = get_step(src,outdir)

	if(!O || !D || !istype(O))
		return

	switch(eject)
		if(0)
			return
		if(1)
			O.loc = src.loc
		if(2)
			O.loc = src.loc
			O.dir = src.outdir
			O.throw_at(D,eject_speed,eject_speed)
	return

/obj/machinery/disassembler/proc/wires_win(mob/user as mob)
	var/dat as text
	dat += "Disassembler Wires:<BR>"
	for(var/wire in src.wires)
		dat += text("[wire] Wire: <a href='byond://?src=\ref[src];wire=[wire];act=wire'>[src.wires[wire] ? "Mend" : "Cut"]</a> <a href='byond://?src=\ref[src];wire=[wire];act=pulse'>Pulse</a><BR>")

	dat += text("The red light is [src.disabled ? "off" : "on"].<BR>")
	dat += text("The green light is [src.shocked ? "off" : "on"].<BR>")
	dat += text("The blue light is [src.hacked ? "off" : "on"].<BR>")
	user << browse("<HTML><HEAD><TITLE>Disassembler Hacking</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=disassembler_hack")
	onclose(user, "disassembler_hack")

/obj/machinery/disassembler
	proc/
		regular_win(mob/user as mob)
			var/dat as text
			dat = text("<HR>")
			dat += "<a href='byond://?src=\ref[src];menu=0.0'>Main Menu</a> || "
			dat += "<a href='byond://?src=\ref[src];menu=1.0'>Component Storage</a> || "
			dat += "<a href='byond://?src=\ref[src];menu=2.0'>Material Storage</a> || "
			dat += "<a href='byond://?src=\ref[src];menu=3.0'>Blueprint Storage</a><HR>"

			switch(screen)
				if(0.0)
					dat += "EJECTION: <a href='byond://?src=\ref[src];mode=1'>[capitalize(eject == 0 ? "no eject" : (eject == 1 ? "manual" : "auto"))]</a> "
					dat += "INLET: <a href='byond://?src=\ref[src];inlet=1'>[capitalize(dir2text(indir))]</a> "
					dat += "OUTLET: <a href='byond://?src=\ref[src];outlet=1'>[capitalize(dir2text(outdir))]</a>"
					dat += " (<a href='byond://?src=\ref[src];swapdir=1'>SWAP</a>)</TT><HR>"
					dat += "<BR>"
				if(1.1)
					if(selectedrecipe)
						dat += "[selectedrecipe.name]<BR><BR>"
						dat += "[selectedrecipe.desc]<BR><BR>"
						dat += "<a href='byond://?src=\ref[src];confirm=1'>Destroy</a><BR>"
						dat += "<a href='byond://?src=\ref[src];confirmall=1'>Destroy All</a><BR>"
				if(0.2)
					if(error)
						dat += "[error]<BR><BR>"
						dat += "<a href='byond://?src=\ref[src];menu=0.0'>Main Menu</a>"
				if(1.0)
					dat += "Component Storage<BR><HR>"
					for(var/obj/O in contents)
						if(O == recipedisk)
							continue
						dat += "[O.name] "
						dat += "<a href='byond://?src=\ref[src];disassemble=\ref[O]'>(Disassemble)</a>"
						dat += "<a href='byond://?src=\ref[src];eject=\ref[O]'>(Eject)</a><BR>"
				if(2.0)
					dat += "Material Storage<BR><HR>"
					for(var/datum/reagent/R in reagents.reagent_list)
						dat += "Name: [R.name] | Units: [R.volume] "
						dat += "<a href='byond://?src=\ref[src];disposeP=[R.id]'>(Purge)</a><BR>"
					dat += "<a href='byond://?src=\ref[src];disposeallP=1'><U>Disposal All Materials in Storage</U></a><BR>"
				if(3.0)
					dat += "Blueprint Storage<BR><HR>"
					dat += "<A href='?src=\ref[src];menu=3.1'>Internal Storage</a><BR>"
					if(recipedisk)
						dat += "<a href='byond://?src=\ref[src];menu=3.2'>External Storage</a> "
						dat += "<a href='byond://?src=\ref[src];eject=\ref[recipedisk]'>(Eject)</a><BR>"
					else
						dat += "NO BLUEPRINT DISK INSERTED<BR>"
				if(3.1)
					dat += "Internal Blueprint Storage<BR><HR>"
					for(var/datum/assemblerprint/R in possiblerecipes)
						dat += "[R.name] "
						if(recipedisk)
							dat += "<a href='byond://?src=\ref[src];save=\ref[R]'>Save</a>||"
						else
							dat += "Save||"
						dat += "<a href='byond://?src=\ref[src];deleteP=\ref[R]'>Delete</a><BR>"
				if(3.2)
					dat += "External Blueprint Storage<BR><HR>"
					dat += "<a href='byond://?src=\ref[src];clear=1'>Clear Disk</a><BR>"
					for(var/datum/assemblerprint/R in recipedisk.recipes)
						dat += "[R.name] "
						dat += "<a href='byond://?src=\ref[src];load=\ref[R]'>Load</a>||"
						dat += "<a href='byond://?src=\ref[src];delete=\ref[R]'>Delete</a><BR>"
			user << browse("<HTML><HEAD><TITLE>Disassembler Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=disassembler_regular")
			onclose(user, "disassembler_regular")

/obj/machinery/disassembler/interact(mob/user as mob)
	if(..())
		return
	if (src.shocked)
		src.shock(user,50)
	if (src.opened)
		wires_win(user,50)
		return
	if (src.disabled)
		user << "\red You press the button, but nothing happens."
		return
	regular_win(user)
	return

/obj/machinery/disassembler/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (shocked)
		shock(user,50)
	else if (O.is_open_container())
		return 1
	else if (istype(O,/obj/item/weapon/blueprintdisk) && !recipedisk)
		usr.before_take_item(O)
		recipedisk = O
		O.loc = src
	else
		insert(O,user)

/obj/machinery/disassembler/process()
	var/turf/D = get_step(src,indir)

	if(stat || sleep)
		if(sleep > 0) // prevent input or output errors from happening every tick
			sleep--
		use_power = 0

		//Do not let things get stuck inside.  That's broken behavior.
		for(var/obj/O in contents)
			O.loc = loc
		for(var/mob/M in contents)
			M.loc = loc
			if(M.client)
				M.client.eye = M.client.mob
				M.client.perspective = MOB_PERSPECTIVE
				M << "\blue The machine turns off, and you fall out."

		return

	if(D)
		var/done = 0
		var/work = 0

		for(var/obj/item/O in D)
			if(sleep)
				break // Something stopped the machine
			if(!O || O.loc != D || done)
				continue // next item

			if(!O.anchored && contents.len < maxcontents)
				autoinsert(O)
				work++

			if(work > maxwork)
				done = 1

		if(work)
			use_power = 2
		else
			use_power = 1

	if(!nterm)
		for (var/obj/machinery/power/netterm/term in loc)
			netconnect(term)
			break
	else
		if(nterm.netid == "00000000")
			nterm.requestid()

/obj/machinery/disassembler/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/disassembler/attack_hand(mob/user as mob)
	user.machine = src
	interact(user)

/obj/machinery/disassembler

	Topic(href, href_list)
		if(..())
			return
		usr.machine = src
		src.add_fingerprint(usr)

		if(href_list["menu"]) //Switches menu screens. Converts a sent text string into a number. Saves a LOT of code.
			var/temp_screen = text2num(href_list["menu"])
			if(src.allowed(usr) || emagged) //Unless you are making something, you need access.
				screen = temp_screen
			else
				usr << "Unauthorized Access."
		else if(href_list["mode"])
			eject++
			if(eject > 2)
				eject = 0
		else if(href_list["inlet"])
			indir *= 2 // N S E W
			if(indir > 8)
				indir = 1 // W N
			if(indir == src.outdir)
				indir *= 2
				if(indir > 8)
					indir = 1
		else if(href_list["outlet"])
			outdir *= 2
			if(outdir > 8)
				outdir = 1
			if(outdir == indir)
				outdir *= 2
				if(outdir > 8)
					outdir = 1
		else if(href_list["swapdir"])
			var/temp = outdir
			outdir = indir
			indir = temp
		else if(href_list["eject"])  //Causes the protolathe to dispose of a single reagent (all of it)
			var/obj/O = locate(href_list["eject"])

			if(O)
				if(recipedisk == O)
					recipedisk = null

				if(eject == 0)
					O.loc = src.loc
				else
					eject(O)
		else if(href_list["disposeP"])  //Causes the protolathe to dispose of a single reagent (all of it)
			var/obj/item/weapon/liquidcartridge/cart = new(src.loc)
			reagents.trans_id_to(cart, href_list["disposeP"], reagents.get_reagent_amount(href_list["disposeP"]))
			//reagents.del_reagent(href_list["dispose"])
		else if(href_list["disposeallP"]) //Causes the protolathe to dispose of all it's reagents.
			for(var/datum/reagent/R in reagents.reagent_list)
				var/obj/item/weapon/liquidcartridge/cart = new(src.loc)
				reagents.trans_id_to(cart, R.id, reagents.get_reagent_amount(R.id))
			//reagents.clear_reagents()
		else if(href_list["deleteP"])
			var/datum/assemblerprint/R = locate(href_list["deleteP"])

			if(R)
				possiblerecipes -= R
		else if(href_list["save"])
			var/datum/assemblerprint/R = locate(href_list["save"])

			if(recipedisk && R && !(R in recipedisk.recipes))
				recipedisk.recipes += R
			else if(!recipedisk)
				error = "ERROR<BR><BR>"
				error += "DISK WAS REMOVED DURING OPERATION."
				screen = 0.2
		else if(href_list["load"])
			var/datum/assemblerprint/R = locate(href_list["load"])

			if(recipedisk && R && (R in recipedisk.recipes) && !(R in possiblerecipes))
				possiblerecipes += R
			else if(!recipedisk)
				error = "ERROR<BR><BR>"
				error += "DISK WAS REMOVED DURING OPERATION."
				screen = 0.2
		else if(href_list["delete"])
			var/datum/assemblerprint/R = locate(href_list["delete"])

			if(recipedisk && R)
				recipedisk.recipes -= R
			else if(!recipedisk)
				error = "ERROR<BR><BR>"
				error += "DISK WAS REMOVED DURING OPERATION."
				screen = 0.2
		else if(href_list["clear"])
			if(recipedisk)
				recipedisk.recipes = list()
			else if(!recipedisk)
				error = "ERROR<BR><BR>"
				error += "DISK WAS REMOVED DURING OPERATION."
				screen = 0.2
		else if (!building)
			if(href_list["disassemble"])
				var/obj/A = locate(href_list["disassemble"])
				if(A)
					selectedrecipe = getrecipe(A)
					if(selectedrecipe)
						selecteditem = A
						screen = 1.1
					else
						error = "ERROR<BR><BR>"
						error += "COMPONENT CAN'T BE DISASSEMBLED."
						screen = 0.2

			if(href_list["confirm"])
				var/datum/assemblerprint/selectedrecipe = getrecipe(selecteditem)

				if(selecteditem && selectedrecipe)
					error = "PROCESSING..."
					screen = 0.2
					src.updateUsrDialog()

					var/newresearch = selectedrecipe.destroy(src)

					qdel(selecteditem)

					selecteditem = null
					selectedrecipe = null

					if(!newresearch)
						screen = 1
				else
					error = "ERROR<BR><BR>"
					error += "SELECTION CORRUPTED."
					screen = 0.2

			if(href_list["confirmall"])
				var/datum/assemblerprint/selectedrecipe = getrecipe(selecteditem)

				if(selecteditem && selectedrecipe)
					var/selectedtype = selecteditem.type

					error = "PROCESSING..."
					screen = 0.2
					src.updateUsrDialog()

					var/newresearch

					for(var/obj/O in contents)
						if(istype(O,selectedtype))
							newresearch = selectedrecipe.destroy(src)
							qdel(O)

					if(!newresearch)
						screen = 1

					selecteditem = null
					selectedrecipe = null
				else
					error = "ERROR<BR><BR>"
					error += "SELECTION CORRUPTED."
					screen = 0.2

			if(href_list["act"])
				var/temp_wire = href_list["wire"]
				if(href_list["act"] == "pulse")
					if (!istype(usr.equipped(), /obj/item/device/multitool))
						usr << "You need a multitool!"
					else
						if(src.wires[temp_wire])
							usr << "You can't pulse a cut wire."
						else
							if(src.hack_wire == temp_wire)
								src.hacked = !src.hacked
								spawn(100) src.hacked = !src.hacked
							if(src.disable_wire == temp_wire)
								src.disabled = !src.disabled
								src.shock(usr,50)
								spawn(100) src.disabled = !src.disabled
							if(src.shock_wire == temp_wire)
								src.shocked = !src.shocked
								src.shock(usr,50)
								spawn(100) src.shocked = !src.shocked
				if(href_list["act"] == "wire")
					if (!istype(usr.equipped(), /obj/item/weapon/wirecutters))
						usr << "You need wirecutters!"
					else
						wires[temp_wire] = !wires[temp_wire]
						if(src.hack_wire == temp_wire)
							src.hacked = !src.hacked
						if(src.disable_wire == temp_wire)
							src.disabled = !src.disabled
							src.shock(usr,50)
						if(src.shock_wire == temp_wire)
							src.shocked = !src.shocked
							src.shock(usr,50)
		else
			usr << "\red The disassembler is busy. Please wait for completion of previous operation."
		src.updateUsrDialog()
		return


/*	RefreshParts()
		..()
		var/tot_rating = 0
		for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
			tot_rating += MB.rating
		tot_rating *= 25000
		max_m_amount = tot_rating * 2
		max_g_amount = tot_rating*/