/* =================== CHRISTMAS SHIT  ===================  */
/obj/structure/girlanda
	name = "garland lights"
	desc = "Flashy and pretty."
	icon = 'icons/obj/christmas.dmi'
	icon_state = "xmaslights"
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/girlanda/attack_hand(mob/user)
	var/temp_loc = user.loc
	switch(alert("Do I want to rip the garland from the wall?","You think...","Yes","No"))
		if("Yes")
			if(user.loc != temp_loc)
				return
			visible_message("<span class='warning'>[user] rips [src] in a single, decisive motion!</span>" )
			playsound(src.loc, 'sound/items/poster_ripped.ogg', 100, 1)
			qdel(src)
		if("No")
			return
/*
/obj/structure/girlanda/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/coil/garland))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user << "<span class='notice'>You carefully remove the garland from the wall.</span>"
		remove_garland(user.loc)
		return
*/
/obj/structure/girlanda/proc/remove_garland(turf/location)
	var/obj/structure/girlanda/P = new(src)
	P.loc = location
	loc = P

#define MAXCOIL 25
/obj/item/stack/coil/garland
	name = "garland cable coil"
	icon = 'icons/obj/christmas.dmi'
	icon_state = "coil_gar"
	item_state = "coil_green"
	amount = MAXCOIL
	item_color = "green"
	desc = "A coil of power cable."
	throwforce = 0
	w_class = 2.0
	throw_speed = 3
	throw_range = 5
	m_amt = 50
	g_amt = 400
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")

/obj/item/stack/coil/garland/suicide_act(mob/user)
	if(locate(/obj/structure/stool) in user.loc)
		user.visible_message("<span class='suicide'>[user] is making a noose with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	else
		user.visible_message("<span class='suicide'>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/stack/coil/garland/New(loc, amount = MAXCOIL, var/param_color = null)
	..()
	src.amount = amount
	if (param_color)
		item_color = param_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()

/obj/item/stack/coil/garland/examine()
	set src in view(1)

	if(amount == 1)
		usr << "A short piece of garland."
	else if(amount == 2)
		usr << "A piece of garland."
	else
		usr << "A coil of garland. There are [amount] lengths of garland in the coil."

// Items usable on a garlands coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables
/obj/item/stack/coil/garland/attackby(obj/item/weapon/W, mob/user)
	..()
	if( istype(W, /obj/item/weapon/wirecutters) && src.amount > 1)
		src.amount--
		new/obj/item/stack/coil/garland(user.loc, 1,item_color)
		user << "You cut a piece off the garland coil."
		src.update_icon()
		return

	else if( istype(W, /obj/item/stack/coil/garland) )
		var/obj/item/stack/coil/garland/C = W
		if(C.amount >= MAXCOIL)
			user << "The coil is too long, you cannot add any more to it."
			return

		if( (C.amount + src.amount <= MAXCOIL) )
			user << "You join the garland coils together."
			C.give(src.amount) // give it cable
			src.use(src.amount) // make sure this one cleans up right
			return

		else
			var/amt = MAXCOIL - C.amount
			user << "You transfer [amt] length\s of garland from one coil to the other."
			C.give(amt)
			src.use(amt)
			return

//remove garlands from the stack
/obj/item/stack/coil/garland/use(var/used)
	if(src.amount < used)
		return 0
	else if (src.amount == used)
		qdel(src)
	else
		amount -= used
		update_icon()
		return 1

//add garlands to the stack
/obj/item/stack/coil/garland/proc/give(var/extra)
	if(amount + extra > MAXCOIL)
		amount = MAXCOIL
	else
		amount += extra
	update_icon()

/* -
//placing garlands at wall
/turf/simulated/wall/proc/place_garland(obj/item/stack/coil/garland/P, mob/user)
	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a garland on it.
		if(istype(O,/obj/structure/girlanda))
			user << "<span class='notice'>There already another garland on that wall!</span>"
			return

	user << "<span class='notice'>You start placing the garland on the wall...</span>"	//Looks like it's uncluttered enough. Place the poster.

	//declaring D because otherwise if P gets 'deconstructed' we lose our reference to P.resulting_garland
	var/obj/structure/girlanda/D = P.resulting_garland

	var/temp_loc = user.loc
	D.loc = src
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/Screwdriver.ogg', 100, 1)

	if(!D)	return

	if(istype(src,/turf/simulated/wall) && user && user.loc == temp_loc)	//Let's check if everything is still there
		user << "<span class='notice'>You place the poster!</span>"
	else
		D.remove_garland(temp_loc)
	return */