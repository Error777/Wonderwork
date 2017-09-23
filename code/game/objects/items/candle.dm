/obj/item/candle
	name = "red candle"
	desc = "a candle"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	light_color = LIGHT_COLOR_TUNGSTEN
	w_class = 1

	var/wax = 200
	var/lit = 0
	proc
		light(var/flavor_text = "\red [usr] lights the [name].")


/obj/item/candle/update_icon()
	var/i
	if(wax>150)
		i = 1
	else if(wax>80)
		i = 2
	else i = 3
	icon_state = "candle[i][lit ? "_lit" : ""]"


/obj/item/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("\red [user] casually lights the [name] with [W], what a badass.")
	else if(istype(W, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = W
		if(L.lit)
			light()
	else if(istype(W, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = W
		if(M.lit)
			light()
	else if(istype(W, /obj/item/candle))
		var/obj/item/candle/C = W
		if(C.lit)
			light()


/obj/item/candle/light(var/flavor_text = "\red [usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		//src.damtype = "fire"
		for(var/mob/O in viewers(usr, null))
			O.show_message(flavor_text, 1)
		set_light(CANDLE_LUM)
		processing_objects.Add(src)

/obj/item/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped()
		del(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)


/obj/item/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
		user.set_light(CANDLE_LUM)

/obj/item/candle/pickup(mob/user)
	if(lit)
		set_light(0)
		user.set_light(CANDLE_LUM)

/obj/item/candle/dropped(mob/user)
	if(lit)
		user.set_light(0)
		set_light(CANDLE_LUM)

/obj/item/candle/on_enter_storage()
	if(lit)
		lit = 0
		update_icon()
		usr.set_light(0)
	..()
	return