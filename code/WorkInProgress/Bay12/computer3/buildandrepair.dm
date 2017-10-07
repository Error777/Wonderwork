// Computer3 circuitboard specifically
/obj/item/part/computer/circuitboard
	density = 0
	anchored = 0
	w_class = 2.0
	name = "Circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = "programming=2"
	var/id = null
	var/frequency = null
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/powernet = null
	var/list/records = null

	var/datum/file/program/OS = new/datum/file/program/ntos

/obj/machinery/computer3/proc/disassemble(mob/user as mob) // todo
	return

/obj/item/weapon/maincircuitboard
	density = 0
	anchored = 0
	w_class = 2.0
	name = "Mainframe Circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "mainboard"
	item_state = "electronic"
	origin_tech = "programming=2"
	var/id = null
	var/frequency = null
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/powernet = null
	var/list/records = null
	var/frame_desc = null
	var/contain_parts = 1

	var/datum/file/program/OS = new/datum/file/program/ntos


//MAINFRAME CIRCUIT BOARD

/obj/item/weapon/maincircuitboard/holodeck
	name = "Mainframe Circuit board (Holodeck Control)"
	build_path = "/obj/machinery/computer3/HolodeckControl"
/obj/item/weapon/maincircuitboard/arcade
	name = "Mainframe Circuit board (Arcade)"
	build_path = "/obj/machinery/computer3/arcade"
/obj/item/weapon/maincircuitboard/aiupload
	name = "Mainframe Circuit board (AI Upload)"
	build_path = "/obj/machinery/computer3/aiupload"
	origin_tech = "programming=4"
/obj/item/weapon/maincircuitboard/borgupload
	name = "Mainframe Circuit board (Cyborg Upload)"
	build_path = "/obj/machinery/computer3/borgupload"
	origin_tech = "programming=4"
/obj/item/weapon/maincircuitboard/robotics
	name = "Mainframe Circuit board (Cyborg Control)"
	build_path = "/obj/machinery/computer3/robotics"
	origin_tech = "programming=4"
/obj/item/weapon/maincircuitboard/med_data
	name = "Mainframe Circuit board (Medical Records)"
	build_path = "/obj/machinery/computer3/med_data"
/obj/item/weapon/maincircuitboard/crew
	name = "Mainframe Circuit board (Crew Monitoring Console)"
	build_path = "/obj/machinery/computer3/crew"
/obj/item/weapon/maincircuitboard/secure_data
	name = "Mainframe Circuit board (Security Records)"
	build_path = "/obj/machinery/computer3/secure_data"
/obj/item/weapon/maincircuitboard/card
	name = "Mainframe Circuit board (ID Computer)"
	build_path = "/obj/machinery/computer3/card/hop"
	origin_tech = "programming=2;magnets=2"
/obj/item/weapon/maincircuitboard/card/centcom
	name = "Mainframe Circuit board (CentCom ID Computer)"
	build_path = "/obj/machinery/computer3/card/centcom"
/obj/item/weapon/maincircuitboard/powermonitor
	name = "Mainframe Circuit board (Power Monitoring Console)"
	build_path = "/obj/machinery/computer3/powermonitor"
	origin_tech = "programming=2;magnets=2"
/obj/item/weapon/maincircuitboard/atmos_alert
	name = "Mainframe Circuit board (Atmos Alert Console)"
	build_path = "/obj/machinery/computer3/atmos_alert"
	origin_tech = "programming=2;magnets=2"
/obj/item/weapon/maincircuitboard/operating
	name = "Mainframe Circuit board (Operating Table Monitor)"
	build_path = "/obj/machinery/computer3/operating"

/obj/structure/computer3frame
	density = 1
	anchored = 0
	name = "metacomputer-frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "frame0"
	var/state = 0

	var/obj/item/part/computer/circuitboard/circuit = null
	var/completed = /obj/machinery/computer

	// Computer3 components - a carbon copy of the list from
	// computer.dm; however, we will need to check to make sure
	// we don't install more components than the computer frame
	// can handle.  This will be different for certain formfactors.

	var/max_components = 4
	var/list/components = list()

	// Storage
	var/obj/item/part/computer/storage/hdd/hdd				= null
	var/obj/item/part/computer/storage/removable/floppy		= null
	// Networking
	var/obj/item/part/computer/networking/radio/radio		= null	// not handled the same as other networks
	var/obj/item/part/computer/networking/cameras/camnet	= null	// just plain special
	var/obj/item/part/computer/networking/net				= null	// Proximity, area, or cable network
	var/obj/item/part/computer/networking/subspace/centcom	= null	// only for offstation communications

	// Card reader - note the HoP reader is a subtype
	var/obj/item/part/computer/cardslot/cardslot			= null

	// Misc & special purpose
	var/obj/item/part/computer/ai_holder/cradle				= null
	var/obj/item/part/computer/toybox/toybox				= null

	// Battery must be installed BEFORE wiring the computer.
	// if installing it in an existing computer, you will have to
	// get back to this state first.
	var/obj/item/weapon/cell/battery	= null

/obj/structure/computer3frame/server
	name = "server frame"
	completed = /obj/machinery/computer3/server
	max_components = 6
/obj/structure/computer3frame/wallcomp
	name = "wall-computer frame"
	completed = /obj/machinery/computer3/wall_comp
	max_components = 3
/obj/structure/computer3frame/laptop
	name = "laptop frame"
	completed = /obj/machinery/computer3/laptop
	max_components = 3

/obj/structure/computer3frame/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You wrench the frame into place."
					src.anchored = 1
					src.state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					user << "The welding tool must be on to complete this task."
					return
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.isOn()) return
					user << "\blue You deconstruct the frame."
					new /obj/item/stack/sheet/metal( src.loc, 5 )
					del(src)
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					user << "\blue You unfasten the frame."
					src.anchored = 0
					src.state = 0
			if(istype(P, /obj/item/weapon/maincircuitboard) && !circuit)
				var/obj/item/weapon/maincircuitboard/B = P
				if(B.board_type == "computer")
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "\blue You place the circuit board inside the frame."
					src.icon_state = "frame1"
					src.circuit = P
					user.drop_item()
					P.loc = src
				else
					user << "\red This frame does not accept circuit boards of this type!"
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You screw the circuit board into place."
				src.state = 2
				src.icon_state = "frame2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "\blue You remove the circuit board."
				src.state = 1
				src.icon_state = "frame0"
				circuit.loc = src.loc
				src.circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You unfasten the circuit board."
				src.state = 1
				src.icon_state = "frame1"

			if(istype(P, /obj/item/weapon/crowbar))
				if(battery)
					playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
					if(do_after(10))
						battery.loc = loc
						user << "\blue You remove [battery]."
						battery = null
				else
					user << "\red There's no battery to remove!"

			if(istype(P, /obj/item/weapon/cell))
				if(!battery)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(5))
						battery = P
						P.loc = src
						user << "\blue You insert [battery]."
				else
					user << "\red There's already \an [battery] in [src]!"


			if(istype(P, /obj/item/weapon/cable_coil))
				if(P:amount >= 5)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(P)
							P:amount -= 5
							if(!P:amount) del(P)
							user << "\blue You add cables to the frame."
							src.state = 3
							src.icon_state = "frame3"
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				if(components.len)
					user << "There are parts in the way!"
					return
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				user << "\blue You remove the cables."
				src.state = 2
				src.icon_state = "frame2"
				var/obj/item/weapon/cable_coil/A = new /obj/item/weapon/cable_coil( src.loc )
				A.amount = 5

			if(istype(P, /obj/item/weapon/crowbar)) // complicated check
				remove_peripheral()

			if(istype(P, /obj/item/stack/sheet/glass))
				var/obj/item/stack/S = P
				if(S.amount >= 2)
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(S)
							S.use(2)
							user << "<span class='notice'>You put in the glass panel.</span>"
							src.state = 4
							src.icon_state = "frame4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
				user << "\blue You remove the glass panel."
				src.state = 3
				src.icon_state = "frame3"
				new /obj/item/stack/sheet/glass( src.loc, 2 )
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "\blue You connect the monitor."
				var/obj/machinery/computer3/B = new src.circuit.build_path ( src.loc )
				B.circuit = circuit
				circuit.loc = B
				if(circuit.OS)
					circuit.OS.computer = B
				B.RefreshParts()		// todo
				del(src)

/*
	This will remove peripherals if you specify one, but the main function is to
	allow the user to remove a part specifically.
*/
/obj/structure/computer3frame/proc/remove_peripheral(var/obj/item/I = null)
	if(!components || !components.len)
		usr << "\red There are no components in [src] to take out!"
		return 0
	if(!I)
		I = input(usr, "Remove which component?","Remove component", null) as null|obj in components

	if(I)
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		if(do_after(usr,25))
			if(I==hdd)
				components -= hdd
				hdd.loc = loc
				hdd = null
			else if(I==floppy)
				components -= floppy
				floppy.loc = loc
				floppy = null
			else if(I==radio)
				components -= radio
				radio.loc = loc
				radio = null
			else if(I==camnet)
				components -= camnet
				camnet.loc = loc
				camnet = null
			else if(I==net)
				components -= net
				net.loc = loc
				net = null
			else if(I==cradle)
				components -= cradle
				cradle.loc = loc
				cradle = null
			else if(I==toybox)
				components -= toybox
				toybox.loc = loc
				toybox = null
			else
				warning("Erronous component in computerframe/remove_peripheral: [I]")
				I.loc = loc
			usr << "\blue You remove [I]"
			return 1
	return 0
/obj/structure/computer3frame/proc/insert_peripheral(var/obj/item/I)
	if(components.len >= max_components)
		usr << "There isn't room in [src] for another component!"
		return 0
	switch(I.type)
		if(/obj/item/part/computer/storage/hdd)
			if(hdd)
				usr << "There is already \an [hdd] in [src]!"
				return 0
			hdd = I
			components += hdd
			hdd.loc = src
		if(/obj/item/part/computer/storage/removable)
			if(floppy)
				usr << "There is already \an [floppy] in [src]!"
				return 0
			floppy = I
			components += floppy
			floppy.loc = src
		if(/obj/item/part/computer/networking/radio)
			if(radio)
				usr << "There is already \an [radio] in [src]!"
				return 0
			radio = I
			components += radio
			radio.loc = src
		if(/obj/item/part/computer/networking/cameras)
			if(camnet)
				usr << "There is already \an [camnet] in [src]!"
				return 0
			camnet = I
			components += camnet
			camnet.loc = src
		if(/obj/item/part/computer/networking)
			if(net)
				usr << "There is already \an [net] in [src]!"


