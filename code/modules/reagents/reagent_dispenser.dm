

/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "tankold"
	density = 1
	anchored = 0
	flags = FPRINT
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(3000)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
		..()

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing."

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set category = "Object"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			if(3.0)
				if (prob(5))
					new /obj/effect/effect/water(src.loc)
					qdel(src)
					return
			else
		return

	blob_act()
		if(prob(50))
			new /obj/effect/effect/water(src.loc)
			qdel(src)







//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/structure/reagent_dispensers/watertank/hv
	name = "high-volume watertank"
	desc = "A large watertank"
	icon_state = "hvwatertank"
	New()
		..()
		reagents.add_reagent("water",2000)

/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null
	New()
		..()
		reagents.add_reagent("fuel",1000)

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		if(modded)
			usr << "\red Fuel faucet is wrenched open, leaking the fuel!"
		if(rig)
			usr << "<span class='notice'>There is some kind of device rigged to the tank."

	attack_hand()
		if (rig)
			usr.visible_message("[usr] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
			if(do_after(usr, 20))
				usr.visible_message("\blue [usr] detaches [rig] from \the [src].", "\blue  You detach [rig] from \the [src]")
				rig.loc = get_turf(usr)
				rig = null
				overlays = new/list()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W,/obj/item/weapon/wrench))
			user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
				"You wrench [src]'s faucet [modded ? "closed" : "open"]")
			modded = modded ? 0 : 1
		if (istype(W,/obj/item/device/assembly_holder))
			if (rig)
				user << "\red There is another device in the way."
				return ..()
			user.visible_message("[user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")
			if(do_after(user, 20))
				user.visible_message("\blue [user] rigs [W] to \the [src].", "\blue  You rig [W] to \the [src]")

				var/obj/item/device/assembly_holder/H = W
				if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
					message_admins("[key_name_admin(user)] rigged fueltank at ([loc.x],[loc.y],[loc.z]) for explosion.")
					log_game("[key_name(user)] rigged fueltank at ([loc.x],[loc.y],[loc.z]) for explosion.")

				rig = W
				user.drop_item()
				W.loc = src

				var/icon/test = getFlatIcon(W)
				test.Shift(NORTH,1)
				test.Shift(EAST,6)
				overlays += test

		return ..()


	bullet_act(var/obj/item/projectile/Proj)
		if(istype(Proj ,/obj/item/projectile/beam)||istype(Proj,/obj/item/projectile/bullet))
			if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
				explode()

	blob_act()
		explode()

	ex_act()
		explode()

	proc/explode()
		if(reagents.total_volume > 1000) // Only for big fueltanks
			explosion(src.loc,1,3,5)
		else if (reagents.total_volume > 500)
			explosion(src.loc,1,2,4)
		else if (reagents.total_volume > 100)
			explosion(src.loc,0,1,3)
		else
			explosion(src.loc,-1,1,2)
		if(src)
			qdel(src)

/obj/structure/reagent_dispensers/fueltank/HasProximity(atom/movable/AM as mob|obj)
	if(rig)
		rig.HasProximity(AM)

/obj/structure/reagent_dispensers/fueltank/hear_talk(mob/living/M, msg)
	if(rig)
		rig.hear_talk(M, msg)

/obj/structure/reagent_dispensers/fueltank/hv
	name = "high-volume fueltank"
	desc = "A large fueltank"
	icon_state = "hvweldtank"
	New()
		..()
		reagents.add_reagent("fuel",1000)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refill pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45
	New()
		..()
		reagents.add_reagent("condensedcapsaicin",1000)

/obj/structure/reagent_dispensers/coffeetank
	name = "Coffeetank"
	desc = "A coffeetank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "coffeetank"
	New()
		..()
		reagents.add_reagent("coffee",1000)

/obj/structure/reagent_dispensers/enyismetank
	name = "Enzymetank"
	desc = "A enzymetank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "enzymetank"
	New()
		..()
		reagents.add_reagent("enzyme",1000)

/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink"
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	New()
		..()
		reagents.add_reagent("water",500)

/obj/structure/reagent_dispensers/chemtank
	name = "Chemical Tank"
	desc = "May contain dangerous chemicals."
	icon = 'icons/obj/objects.dmi'
	icon_state = "chemtank"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,30,50,100)	//up to the big beaker, and not an unit further

/obj/structure/reagent_dispensers/chemtank/inaprovaline
	name = "Inaprovaline Tank"
	New()
		..()
		reagents.add_reagent("inaprovaline",1000)

/obj/structure/reagent_dispensers/chemtank/sulphuric
	name = "Sulphuric acid Tank"
	New()
		..()
		reagents.add_reagent("sacid",1000)

/obj/structure/reagent_dispensers/chemtank/radium
	name = "Radium Tank"
	New()
		..()
		reagents.add_reagent("radium",1000)

/obj/structure/reagent_dispensers/chemtank/cleaner
	name = "Space cleaner Tank"
	New()
		..()
		reagents.add_reagent("cleaner",1000)

/obj/structure/reagent_dispensers/chemtank/dexalin
	name = "Dexalin Tank"
	New()
		..()
		reagents.add_reagent("dexalin",1000)

/obj/structure/reagent_dispensers/chemtank/tramadol
	name = "Tramadol Tank"
	New()
		..()
		reagents.add_reagent("tramadol",1000)

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	New()
		..()
		reagents.add_reagent("beer",1000)

/obj/structure/reagent_dispensers/beerkeg/blob_act()
	explosion(src.loc,0,3,5,7,10)
	qdel(src)

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	anchored = 1

	New()
		..()
		reagents.add_reagent("virusfood", 1000)

proc/is_reagent_dispenser(var/obj/O)
	return (istype(O, /obj/structure/reagent_dispensers) || istype(O, /obj/item/weapon/weldpack))

