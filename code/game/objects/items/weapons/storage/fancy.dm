/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"

/obj/item/weapon/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

/obj/item/weapon/storage/fancy/examine()
	set src in oview(1)

	if(contents.len <= 0)
		usr << "There are no [src.icon_type]s left in the box."
	else if(contents.len == 1)
		usr << "There is one [src.icon_type] left in the box."
	else
		usr << "There are [src.contents.len] [src.icon_type]s in the box."

	return



/*
 * Donut Box
 */

/obj/item/weapon/storage/fancy/donut_box
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	icon_type = "donut"
	name = "donut box"
	storage_slots = 6
	can_hold = list("/obj/item/weapon/reagent_containers/food/snacks/donut")


/obj/item/weapon/storage/fancy/donut_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/donut/normal(src)
	return

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list("/obj/item/weapon/reagent_containers/food/snacks/egg")

/obj/item/weapon/storage/fancy/egg_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
	return

/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "Candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	flags = TABLEPASS
	slot_flags = SLOT_BELT


/obj/item/weapon/storage/fancy/candle_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/candle(src)
	return

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	storage_slots = 6
	icon_type = "crayon"
	can_hold = list(
		"/obj/item/toy/crayon"
	)

/obj/item/weapon/storage/fancy/crayons/New()
	..()
	new /obj/item/toy/crayon/red(src)
	new /obj/item/toy/crayon/orange(src)
	new /obj/item/toy/crayon/yellow(src)
	new /obj/item/toy/crayon/green(src)
	new /obj/item/toy/crayon/blue(src)
	new /obj/item/toy/crayon/purple(src)
	update_icon()

/obj/item/weapon/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/toy/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/obj/item/weapon/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/toy/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	flags = TABLEPASS
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list("/obj/item/clothing/mask/cigarette")
	icon_type = "cigarette"

/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/cigarette(src)
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one

/obj/item/weapon/storage/fancy/cigarettes/Del()
	del(reagents)
	..()


/obj/item/weapon/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	desc = "There are [contents.len] cig\s left!"
	return

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/cigarette/C = W
		if(!istype(C)) return // what
		reagents.trans_to(C, (reagents.total_volume/contents.len))
		..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_sel.selecting == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/cigarette/W = new /obj/item/clothing/mask/cigarette(user)
		reagents.trans_to(W, (reagents.total_volume/contents.len))
		user.equip_to_slot_if_possible(W, slot_wear_mask)
		reagents.maximum_volume = 15 * contents.len
		contents.len--
		user << "<span class='notice'>You take a cigarette out of the pack.</span>"
		update_icon()
	else
		..()


/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("tricordrazine", 2) //DromedaryCo put 2 tricord in their cigs.

/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "upliftpacket"
	item_state = "upliftpacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift/New()
	..()
	var/choice = pick("dexalin", "dexalinp", "leporazine") //The reason why "choice" is outside the for loop is so cigs don't just have all these chems at once with randomised amounts.
	for(var/i = 1 to storage_slots)
		//Simulated menthol effects.
		reagents.add_reagent(choice, 2) //Leporazine stabilises temperature so uplift smooth can be ideal for space travel if you're lucky.
		reagents.add_reagent("dexalin", 3) //Always contains dexalin so it's the main reason to smoke uplifts.
		reagents.add_reagent("nicotine", 2) //More nicotine because gotta have some downside.

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robustpacket"
	item_state = "robustpacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust/New()
	..()
	var/choice = pick("tricordrazine", "hyperzine", "synaptizine", "hyronalin") //Tricord = heals, hyperzine = fast, synaptizine = stun reduction, hyronalin = anti-radiation.
	for(var/i = 1 to storage_slots)
		reagents.add_reagent(choice, 5)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustgpacket"
	item_state = "robustgpacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold/New()
	..()
	var/choice = pick("tricordrazine", "hyperzine", "synaptizine", "hyronalin", "alkysine", "leporazine") //7 units! AND MORE CHEMICALS! WOOT!
	for(var/i = 1 to storage_slots)
		reagents.add_reagent(choice, 7)
		reagents.add_reagent("gold", 1)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313. (Not reccomended for smoking)"
	icon_state = "carppacket"
	item_state = "carppacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("carpotoxin", 2) //Low amount since it's possible to grind cigs.

/obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndiepacket"
	item_state = "syndiepacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.remove_reagent("nicotine", 5) //Make room for Doctor's Delight
		reagents.add_reagent("doctorsdelight",15)


/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midoripacket"
	item_state = "midoripacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori/New()
	..()
	var/choice = pick("space_drugs", "serotrotium") //Serotrotium only makes you twitch and stuff.
	for(var/i = 1 to storage_slots)
		// reagents.add_reagent("toxin", 1) //Toxins removed
		reagents.add_reagent(choice, 5)
		reagents.add_reagent("ethylredoxrazine", 5) //Smoke Midori packets if you're utterly drunk. Tradeoff? Possibility of space drugs.

/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims
	name ="\improper Shady Jim's Super Slims"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjimpacket"
	item_state = "shadyjimpacket"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims/New()
	..()
	var/choice = pick("mindbreaker", "sodium", "alkysine")
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("lipozine", 4) //Burns off your fat, as advertised.
		reagents.add_reagent(choice, rand(2, 6)) //Sodium does nothing, mindbreaker = worse than space drugs and alks heals brain damage. It's a shot in the dark with these cigs.

/obj/item/weapon/storage/fancy/cigarettes/chempacket
	name = "\improper ChemBrand packet"
	desc = "A brand of cigarettes commonly used as medicine. The cigs contain no harmful chemicals, so chemists can dip their cigs in their favorite reagents and have a delightful, nicotine-free smoke!"
	icon_state = "chempacket"
	item_state = "chempacket"

/obj/item/weapon/storage/fancy/cigarettes/chempacket/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.remove_reagent("nicotine", 5) //Makes all cigs completely empty!

/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")


/obj/item/weapon/storage/fancy/vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	return

/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 3
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/adv
	name = "metal box"
	desc = "A metall locked box."
	icon_state = "medalbox+l"
	item_state = "syringe_kit"
	w_class = 3
	max_w_class = 2
	storage_slots = 6
	req_access = list(access_captain)
	icon_locked = "medalbox+l"
	icon_closed = "medalbox"
	icon_broken = "medalbox+b"