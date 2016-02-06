/obj/item/weapon/reagent_containers/pill/patch
	name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/items.dmi'
	icon_state = "patch_med"
	possible_transfer_amounts = list()
	volume = 50
	apply_method = "apply"

/obj/item/weapon/reagent_containers/pill/patch/afterattack(obj/target, mob/user , flag)
	return // thanks inheritance again

/obj/item/weapon/reagent_containers/pill/patch/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return 0
	return 1 // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/weapon/reagent_containers/pill/patch/styptic
	name = "brute patch"
	desc = "Helps with brute injuries."
	New()
		..()
		reagents.add_reagent("styptic_powder", 50)

/obj/item/weapon/reagent_containers/pill/patch/silver_sulf
	name = "burn patch"
	desc = "Helps with burn injuries."
	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 50)

/obj/item/weapon/reagent_containers/pill/patch/cyanide
	name = "cyanide patch"
	icon_state = "patch_synd"
	desc = "Helps to die."
	New()
		..()
		reagents.add_reagent("cyanide", 50)