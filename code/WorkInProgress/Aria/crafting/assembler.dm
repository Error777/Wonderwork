var/list/assembler_recipes = list()

/obj/machinery/assembler
	name = "Assembler"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "assembler0"
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
	var/volume = 150000 //Industrial, motherfucker.
	var/maxcontents = 250
	var/input = 0
	var/eject = 0
	var/eject_speed = 1

	var/indir = 8
	var/outdir = 4

	var/sleep = 0
	var/maxwork = 10

	var/obj/item/weapon/blueprintdisk/recipedisk

	var/list/possiblerecipes = list()
	var/datum/assemblerprint/selectedrecipe
	var/list/unlockedtechs = list("")
	var/list/lockedtechs = list()
	var/techlevel = 0
	var/list/ejectqueue = list()

	var/autoqueue = 1
	var/list/craftingqueue = list()

	var/error
	var/skin = "base"
	var/windowskin = "blue"

	var/screen = 0

/obj/machinery/assembler/New()
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
		if(recipe.tech in lockedtechs) continue
		if(recipe.simplicity >= 100-techlevel && (unlockedtechs.len == 0 || recipe.tech in unlockedtechs))
			possiblerecipes += recipe



	//1 on success
	//0 on failure
	//-1 on notenoughliquids
	//-2 on lackingcomponents
/obj/machinery/assembler/proc/enqueue(var/datum/assemblerprint/recipe)
	var/list/requiredliquids = recipe.liquidcomponents.Copy()
	var/list/requiredcomponents = recipe.components.Copy()
	var/list/enqueuerecipes = list(recipe)
	if(!ispath(recipe.typepath,/obj/item/chemmaker))
		ejectqueue += recipe.typepath

		//if(!ejectqueue[1])
		//	ejectqueue.Cut(1,2)

		var/maxdepth = 24

		while(requiredcomponents.len)
			maxdepth -= 1

			if(maxdepth <= 0) return 0

			for(var/component in requiredcomponents)
				var/atom/blah = locate(component) in src

				if(!blah)
					var/datum/assemblerprint/R = find(component)

					if(R)
						//world << "found [component] recipe"
						enqueuerecipes.Insert(1,R)
						requiredcomponents -= component
						requiredcomponents.Add(R.components)
						for(var/p in R.liquidcomponents)
							requiredliquids[p] += R.liquidcomponents[p]
							//world << "requirements for liquids are now: [p] = [requiredliquids[p]]"
				else
					requiredcomponents -= component
					//world << "found [component]"

		for(var/p in requiredliquids)
			//world << "Needs [requiredliquids[p]]u of [p]"
		for(var/p in requiredcomponents)
			//world << "Needs [p]"

		craftingqueue += enqueuerecipes

		return 1

/obj/machinery/assembler/proc/buildnext()
	if(!craftingqueue.len)
		return
	var/datum/assemblerprint/R = craftingqueue[1]
	var/success = R.build(src)

	if(success)
		craftingqueue.Cut(1,2)
		if(craftingqueue.len && autoqueue)
			spawn(0)
				buildnext()
		else
			src.visible_message("\icon[src] <b>[src]</b> beeps, \"All jobs finished.\".")
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			src.updateUsrDialog()

/obj/machinery/assembler/proc/find(var/typepath)
	for(var/datum/assemblerprint/recipe in possiblerecipes)
		//world << "Testing [typepath] against [recipe.typepath]([recipe.name])"

		if(recipe.typepath == typepath)
			//world << "Found it."
			return recipe

/obj/machinery/assembler/proc/shock(mob/user, prb)
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

/obj/machinery/assembler/proc/unlockall()
	for(var/datum/assemblerprint/recipe in assembler_recipes)
		if(recipe.simplicity >= 100 && !(recipe in possiblerecipes))
			possiblerecipes += recipe

/obj/machinery/assembler/proc/has_components(var/list/comps,var/list/liquids)
	var/neededmatches = 0

	var/list/matches = list()
	var/list/liquidmatches = list()

	for(var/I in comps)
		neededmatches++

		for(var/obj/IE in src)
			if(istype(IE,I) && !(IE in matches))
				matches += IE
				break

	for(var/R in liquids)
		neededmatches++

		if(reagents.has_reagent(R,liquids[R]))
			liquidmatches[R] = liquids[R]


	if(matches.len + liquidmatches.len >= neededmatches)
		for(var/RR in liquidmatches)
			reagents.remove_reagent(RR,liquidmatches[RR])

		for(var/RO in matches)
			qdel(RO)

		return 1

	return 0

/obj/machinery/assembler/proc/autoinsert(var/obj/O)
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

/obj/machinery/assembler/proc/insert(var/obj/O,var/mob/user)
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

/obj/machinery/assembler/proc/eject(var/obj/O,override = 0)
	var/turf/D = get_step(src,outdir)

	if(!O || !D || !istype(O))
		return

	if(!override)
		if(autoqueue && ejectqueue.len && O.type == ejectqueue[1])
			ejectqueue.Cut(1,2)
		else
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

/obj/machinery/assembler/proc/getcompletiontime()
	var/seconds = 0
	var/minutes = 0
	var/hours = 0

	for(var/datum/assemblerprint/recipe in craftingqueue)
		seconds += recipe.duration / 10

	minutes = round(seconds / 60) % 60
	hours = round(seconds / 3600)
	seconds = seconds % 60

	var/dat = ""

	if(hours)
		dat += "[hours]h "
	if(minutes)
		dat += "[minutes]m "
	if(seconds)
		dat += "[seconds]s"

	return dat

/obj/machinery/assembler/proc/wires_win(mob/user as mob)
	var/dat as text
	dat += "Assembler Wires:<BR>"
	for(var/wire in src.wires)
		dat += text("[wire] Wire: <a href='byond://?src=\ref[src];wire=[wire];act=wire'>[src.wires[wire] ? "Mend" : "Cut"]</a> <A href='byond://?src=\ref[src];wire=[wire];act=pulse'>Pulse</a><BR>")

	dat += text("The red light is [src.disabled ? "off" : "on"].<BR>")
	dat += text("The green light is [src.shocked ? "off" : "on"].<BR>")
	dat += text("The blue light is [src.hacked ? "off" : "on"].<BR>")
	user << browse("<HTML><HEAD><TITLE>Assembler Hacking</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=assembler_hack")
	onclose(user, "assembler_hack")

/obj/machinery/assembler/proc/regular_win(mob/user as mob)
	var/dat as text
	dat = text("<HR>")
	dat += "<a href='byond://?src=\ref[src];menu=0.0'>Main Menu</a> || "
	dat += "<a href='byond://?src=\ref[src];menu=1.0'>Component Storage</a> || "
	dat += "<a href='byond://?src=\ref[src];menu=2.0'>Material Storage</a> || "
	dat += "<a href='byond://?src=\ref[src];menu=3.0'>Blueprint Storage</a> || "
	dat += "<a href='byond://?src=\ref[src];menu=4.0'>Crafting Queue: [craftingqueue.len] processes</a><HR>"
	dat += "ETA: [getcompletiontime()]<HR>"

	switch(screen)
		if(0.0)
			dat += "EJECTION: <a href='byond://?src=\ref[src];mode=1'>[capitalize(eject == 0 ? "no eject" : (eject == 1 ? "manual" : "auto"))]</a> "
			dat += "INLET: <a href='byond://?src=\ref[src];inlet=1'>[capitalize(dir2text(indir))]</a> "
			dat += "OUTLET: <a href='byond://?src=\ref[src];outlet=1'>[capitalize(dir2text(outdir))]</a>"
			dat += " (<a href='byond://?src=\ref[src];swapdir=1'>SWAP</a>)</TT><HR>"
			dat += "<BR>"
			//var/testi = 0
			for(var/datum/assemblerprint/recipe in possiblerecipes)
				var/imagename = recipe.getrecipeicon(user)
				dat += "<IMG SRC='[imagename]'/> "
				dat += "<A href='byond://?src=\ref[src];make=\ref[recipe]'>[recipe.name]</a><BR>"
				//if(testi++ > 10) break
		if(0.1)
			if(selectedrecipe)
				var/imagename = selectedrecipe.getrecipeicon(user)
				dat += "<IMG SRC='[imagename]'/> "
				dat += "[selectedrecipe.name]<BR><BR>"
				dat += "[selectedrecipe.desc]<BR><BR>"
				dat += "<a href='byond://?src=\ref[src];build=1'>BUILD</a> "
				dat += "<a href='byond://?src=\ref[src];build=5'>x5</a> "
				dat += "<a href='byond://?src=\ref[src];build=10'>x10</a> "
				dat += "<a href='byond://?src=\ref[src];build=20'>x20</a> "
				dat += "<a href='byond://?src=\ref[src];build=30'>x30</a> "
				dat += "<a href='byond://?src=\ref[src];build=50'>x50</a> <BR>"
				dat += "<a href='byond://?src=\ref[src];enqueue=1'>ENQUEUE</a> "
				dat += "<a href='byond://?src=\ref[src];enqueue=5'>x5</a> "
				dat += "<a href='byond://?src=\ref[src];enqueue=10'>x10</a> "
				dat += "<a href='byond://?src=\ref[src];enqueue=20'>x20</a> "
				dat += "<a href='byond://?src=\ref[src];enqueue=30'>x30</a> "
				dat += "<a href='byond://?src=\ref[src];enqueue=50'>x50</a> <BR>"
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
				dat += "<a href='byond://?src=\ref[src];eject=\ref[O]'>(Eject)</a><BR>"
		if(2.0)
			dat += "Material Storage<BR><HR>"
			for(var/datum/reagent/R in reagents.reagent_list)
				dat += "Name: [R.name] | Units: [R.volume] "
				dat += "<a href='byond://?src=\ref[src];disposeP=[R.id]'>(Purge)</a><BR>"
			dat += "<a href='byond://?src=\ref[src];disposeallP=1'><U>Disposal All Materials in Storage</U></a><BR>"
		if(3.0)
			dat += "Blueprint Storage<BR><HR>"
			dat += "<a href='byond://?src=\ref[src];menu=3.1'>Internal Storage</a><BR>"
			if(recipedisk)
				dat += "<a href='byond://?src=\ref[src];menu=3.2'>External Storage</a> "
				dat += "<a href='byond://?src=\ref[src];eject=\ref[recipedisk]'>(Eject)</a><BR>"
			else
				dat += "NO BLUEPRINT DISK INSERTED<BR>"
		if(3.1)
			dat += "Internal Blueprint Storage<BR><HR>"
			if(recipedisk)
				dat += "<a href='byond://?src=\ref[src];saveall=1'>Save All</a><BR>"
			else
				dat += "Save All<BR>"
			for(var/datum/assemblerprint/R in possiblerecipes)
				var/imagename = R.getrecipeicon(user)
				dat += "<IMG SRC='[imagename]'/> "
				dat += "[R.name] "
				if(recipedisk)
					dat += "<a href='byond://?src=\ref[src];save=\ref[R]'>Save</a>||"
				else
					dat += "Save||"
				dat += "<a href='byond://?src=\ref[src];deleteP=\ref[R]'>Delete</a><BR>"
		if(3.2)
			dat += "External Blueprint Storage<BR><HR>"
			dat += "<a href='byond://?src=\ref[src];clear=1'>Clear Disk</a>||"
			dat += "<a href='byond://?src=\ref[src];loadall=1'>Load All</a><BR>"
			for(var/datum/assemblerprint/R in recipedisk.recipes)
				var/imagename = R.getrecipeicon(user)
				dat += "<IMG SRC='[imagename]'/> "
				dat += "[R.name] "
				dat += "<a href='byond://?src=\ref[src];load=\ref[R]'>Load</a>||"
				dat += "<a href='byond://?src=\ref[src];delete=\ref[R]'>Delete</a><BR>"
		if(4.0)
			dat += "Crafting Queue<BR><HR>"
			dat += "Automatic Queue Processing: <a href='byond://?src=\ref[src];autoqueue=1'>[autoqueue ? "ON" : "OFF"]</a>||"
			dat += "<a href='byond://?src=\ref[src];clearqueue=1'>Clear Queue</a><BR>"

			if(craftingqueue.len)
				for(var/datum/assemblerprint/R in craftingqueue)
					var/imagename = R.getrecipeicon(user)
					dat += "<IMG SRC='[imagename]'/> "
					dat += "[R.name]<BR>"
			else
				dat += "Queue is empty.<BR>"

	user << browse("<HTML><HEAD><TITLE>Assembler Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=assembler_regular")
	src.updateUsrDialog()
	onclose(user, "assembler_regular")

/obj/machinery/assembler/interact(mob/user as mob)
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
	onclose(user, "assembler_regular")
	return

/obj/machinery/assembler/attackby(var/obj/item/O as obj, var/mob/user as mob)
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
	src.updateUsrDialog()

/obj/machinery/assembler/process()
	var/turf/D = get_step(src,indir)

	update_icon()

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

	if(autoqueue)
		spawn(0)
			buildnext()

	if(!nterm)
		for (var/obj/machinery/power/netterm/term in loc)
			netconnect(term)
			break
	else
		if(nterm.netid == "00000000")
			nterm.requestid()

/obj/machinery/assembler/update_icon()
	overlays.Cut()

	var/isoff = stat & (BROKEN|NOPOWER)

	if(isoff)
		icon_state = "assemblern"
	else if(building)
		icon_state = "assembler1"
	else
		icon_state = "assembler0"

	overlays += icon(icon,"assembskin_[skin]")
	overlays += icon(icon,"asswindow_[windowskin]") * (isoff ? 0.5 : 1)

/obj/machinery/assembler/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/assembler/attack_hand(mob/user as mob)
	user.machine = src
	interact(user)
	src.updateUsrDialog()


/obj/machinery/assembler/Topic(href, href_list)
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
				eject(O,1)
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
	else if(href_list["saveall"])
		for(var/datum/assemblerprint/R in possiblerecipes)
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
	else if(href_list["loadall"])
		for(var/datum/assemblerprint/R in recipedisk.recipes)
			if(recipedisk && R && !(R in possiblerecipes))
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
	else if(href_list["clearqueue"])
		craftingqueue.Cut()
		src.updateUsrDialog()
	else if (href_list["autoqueue"])
		autoqueue = !autoqueue
		src.updateUsrDialog()
	else if (href_list["enqueue"])
		if(selectedrecipe)
			for(var/i = 1, i <= text2num(href_list["enqueue"]), i++)
				src.enqueue(selectedrecipe)
				src.updateUsrDialog()
	else if(href_list["make"])
		var/datum/assemblerprint/A = locate(href_list["make"])
		if(A)
			selectedrecipe = A
			screen = 0.1
	else if (!building)
		if(href_list["build"])
			if(selectedrecipe)
				error = "PROCESSING..."
				screen = 0.2
				src.updateUsrDialog()

				for(var/i = 1, i <= text2num(href_list["build"]), i++)
					var/success = selectedrecipe.build(src)

					if(!success)
						error = "ERROR<BR><BR>"
						error += "NOT ENOUGH COMPONENTS."
						screen = 0.2
						break

				selectedrecipe = null
				screen = 0
			else
				error = "ERROR<BR><BR>"
				error += "SELECTED RECIPE CORRUPTED."
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
							src.unlockall()
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
		usr << "\red The assembler is busy. Please wait for completion of previous operation."
	src.updateUsrDialog()
	return


/obj/machinery/assembler/netreceive(datum/netpacket/p)
	if(p.content["protocol"] != "ASSEMBLYv037b")
		return

	switch(p.content["command"])
		if("addrecipe")
			var/datum/assemblerprint/newrecipe = p.content["recipe"]

			if(!newrecipe)
				return

			for(var/datum/assemblerprint/r in possiblerecipes)
				if(r.name == newrecipe.name)
					possiblerecipes -= r

			possiblerecipes += newrecipe
		if("deleterecipe")
			var/deleterecipename = p.content["recipe"]

			if(!deleterecipename)
				return

			for(var/datum/assemblerprint/r in possiblerecipes)
				if(r.name == deleterecipename)
					possiblerecipes -= r

		if("listrecipes")
			var/datum/netpacket/newpacket = new()

			newpacket.desthost = p.srchost
			newpacket.content["protocol"] = "ASSEMBLYv037b"
			newpacket.content["command"] = "listrecipes"
			newpacket.content["recipelist"] = list(possiblerecipes)

			netsend(newpacket)



	/*setparam(var/param,var/value)
		if(istype(param,/datum/filepath))
			var/datum/filepath/fp = param


	getparam(var/param)
		if(istext(param))
			if(param == "filelist")
				var/returntext = ""

				for(var/datum/assemblerprint/R in possiblerecipes)
					returntext += "/blueprints/[R.name].prnt\n"

				return returntext
		else if(istype(param,/datum/filepath))
			var/datum/filepath/fp = param

			if(fp.path == "/blueprints/")
				for(var/datum/assemblerprint/R in possiblerecipes)
					if("[R.name].prnt" == fp.name)

		return null*/

/*	RefreshParts()
		..()
		var/tot_rating = 0
		for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
			tot_rating += MB.rating
		tot_rating *= 25000
		max_m_amount = tot_rating * 2
		max_g_amount = tot_rating*/
