/obj/item/stack/medical/patch/brute
	name = "chemical patch"
	singular_name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/items.dmi'
	icon_state = "patch"
	item_state = "patch"
	amount = 1
	heal_brute = 20
	origin_tech = "biotech=1"

/obj/item/stack/medical/patch/brute/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting.bandage())
			user << "\red The wounds on [M]'s [affecting.display_name] have already been treated."
			return 1
		else
			for (var/datum/wound/W in affecting.wounds)
				if (W.internal)
					continue
				if (W.current_stage <= W.max_bleeding_stage)
					user.visible_message( 	"\blue [user] cleans [W.desc] on [M]'s [affecting.display_name] and seals edges with bioglue.", \
									"\blue You clean and seal [W.desc] on [M]'s [affecting.display_name]." )
					//H.add_side_effect("Itch")
				else if (istype(W,/datum/wound/bruise))
					user.visible_message( 	"\blue [user] places medicine patch over [W.desc] on [M]'s [affecting.display_name].", \
									"\blue You place medicine patch over [W.desc] on [M]'s [affecting.display_name]." )
				else
					user.visible_message( 	"\blue [user] smears some bioglue over [W.desc] on [M]'s [affecting.display_name].", \
									"\blue You smear some bioglue over [W.desc] on [M]'s [affecting.display_name]." )
			affecting.heal_damage(heal_brute,0)
			use(1)

/obj/item/stack/medical/patch/burn
	name = "chemical patch"
	singular_name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/items.dmi'
	icon_state = "patch"
	amount = 1
	heal_burn = 20
	origin_tech = "biotech=2"


/obj/item/stack/medical/patch/burn/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1

	if (istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(!affecting.salve())
			user << "\red The wounds on [M]'s [affecting.display_name] have already been salved."
			return 1
		else
			user.visible_message( 	"\blue [user] covers wounds on [M]'s [affecting.display_name] with patch.", \
									"\blue You cover wounds on [M]'s [affecting.display_name] with patch." )
			affecting.heal_damage(0,heal_burn)
			use(1)