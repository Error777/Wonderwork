/obj/machinery/door/poddoor/plasticblind
	name = "Blinds"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "plasticblind-close"
	power_channel = ENVIRON

/obj/machinery/door/poddoor/plasticblind/New()
	..()
	layer = 3.2

/obj/machinery/door/poddoor/shutters/attackby(obj/item/weapon/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!(istype(C, /obj/item/weapon/crowbar) || (istype(C, /obj/item/weapon/twohanded/fireaxe) && C:wielded == 1) ))
		return
	if(density && (stat & NOPOWER) && !operating)
		operating = 1
		spawn(-1)
			flick("plasticblind-closed", src)
			icon_state = "plasticblind-open"
			sleep(15)
			density = 0
			SetOpacity(0)
			operating = 0
			return
	return

/obj/machinery/door/poddoor/plasticblind/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("plasticblind-opened", src)
	icon_state = "plasticblind-open"
	sleep(10)
	density = 0
	SetOpacity(0)
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()		//TODO: note to self: look into this ~Carn
	return 1

/obj/machinery/door/poddoor/plasticblind/close()
	if(operating)
		return
	operating = 1
	flick("plasticblind-closed", src)
	icon_state = "plasticblind-close"
	density = 1
	if(visible)
		SetOpacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return