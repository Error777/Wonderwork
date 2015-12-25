/* Toys!
 * ContainsL
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Water flower
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0

/obj/item/toy/syndicateballoon
	name = "syndicate balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = 4.0

/*
 * Telebeacon
 */
/obj/item/device/radio/beacon/blink
	name = "electronic blink toy game"
	desc = "Blink.  Blink.  Blink. Ages 8 and up."

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "Gravitational Singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy gun: Why isnt this an /obj/item/weapon/gun?
 */
/obj/item/toy/gun
	name = "cap gun"
	desc = "There are 0 caps left. Looks almost like the real thing! Ages 8 and up. Please recycle in an autolathe when you're out of caps!"
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT | USEDELAY
	slot_flags = SLOT_BELT
	w_class = 3.0
	g_amt = 10
	m_amt = 10
	attack_verb = list("struck", "pistol whipped", "hit", "bashed")
	var/bullets = 7

	examine()
		set src in usr

		src.desc = text("There are [] caps\s left. Looks almost like the real thing! Ages 8 and up.", src.bullets)
		..()
		return

	attackby(obj/item/toy/ammo/gun/A as obj, mob/user as mob)

		if (istype(A, /obj/item/toy/ammo/gun))
			if (src.bullets >= 7)
				user << "\blue It's already fully loaded!"
				return 1
			if (A.amount_left <= 0)
				user << "\red There is no more caps!"
				return 1
			if (A.amount_left < (7 - src.bullets))
				src.bullets += A.amount_left
				user << text("\red You reload [] caps\s!", A.amount_left)
				A.amount_left = 0
			else
				user << text("\red You reload [] caps\s!", 7 - src.bullets)
				A.amount_left -= 7 - src.bullets
				src.bullets = 7
			A.update_icon()
			return 1
		return

	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if (flag)
			return
		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
			usr << "\red You don't have the dexterity to do this!"
			return
		src.add_fingerprint(user)
		if (src.bullets < 1)
			user.show_message("\red *click* *click*", 2)
			playsound(user, 'sound/weapons/empty.ogg', 100, 1)
			return
		playsound(user, 'sound/weapons/Gunshot.ogg', 100, 1)
		src.bullets--
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] fires a cap gun at []!</B>", user, target), 1, "\red You hear a gunshot", 2)

/obj/item/toy/ammo/gun
	name = "ammo-caps"
	desc = "There are 7 caps left! Make sure to recyle the box in an autolathe when it gets empty."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "357-7"
	flags = FPRINT | TABLEPASS| CONDUCT
	w_class = 1.0
	g_amt = 10
	m_amt = 20
	var/amount_left = 7.0

	update_icon()
		src.icon_state = text("357-[]", src.amount_left)
		src.desc = text("There are [] caps\s left! Make sure to recycle the box in an autolathe when it gets empty.", src.amount_left)
		return

/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/gun.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	flags = FPRINT | TABLEPASS | USEDELAY
	w_class = 2.0
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 5

	examine()
		set src in view(2)
		..()
		if (bullets)
			usr << "\blue It is loaded with [bullets] foam darts!"

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/toy/ammo/crossbow))
			if(bullets <= 4)
				user.drop_item()
				del(I)
				bullets++
				user << "\blue You load the foam dart into the crossbow."
			else
				usr << "\red It's already fully loaded."


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if(!isturf(target.loc) || target == user) return
		if(flag) return

		if (locate (/obj/structure/table, src.loc))
			return
		else if (bullets)
			var/turf/trg = get_turf(target)
			var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
			bullets--
			D.icon_state = "foamdart"
			D.name = "foam dart"
			playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

			for(var/i=0, i<6, i++)
				if (D)
					if(D.loc == trg) break
					step_towards(D,trg)

					for(var/mob/living/M in D.loc)
						if(!istype(M,/mob/living)) continue
						if(M == user) continue
						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("\red [] was hit by the foam dart!", M), 1)
						new /obj/item/toy/ammo/crossbow(M.loc)
						del(D)
						return

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							new /obj/item/toy/ammo/crossbow(A.loc)
							del(D)

				sleep(1)

			spawn(10)
				if(D)
					new /obj/item/toy/ammo/crossbow(D.loc)
					del(D)

			return
		else if (bullets == 0)
			user.Weaken(5)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red [] realized they were out of ammo and starting scrounging for some!", user), 1)


	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

// ******* Check

		if (src.bullets > 0 && M.lying)

			for(var/mob/O in viewers(M, null))
				if(O.client)
					O.show_message(text("\red <B>[] casually lines up a shot with []'s head and pulls the trigger!</B>", user, M), 1, "\red You hear the sound of foam against skull", 2)
					O.show_message(text("\red [] was hit in the head by the foam dart!", M), 1)

			playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)
			new /obj/item/toy/ammo/crossbow(M.loc)
			src.bullets--
		else if (M.lying && src.bullets == 0)
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message(text("\red <B>[] casually lines up a shot with []'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!</B>", user, M), 1, "\red You hear someone fall", 2)
			user.Weaken(5)
		return

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "Its nerf or nothing! Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	flags = FPRINT | TABLEPASS
	w_class = 1.0

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "null"
	anchored = 1
	density = 0


/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	var/active = 0.0
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD
	attack_verb = list("attacked", "struck", "hit")

	attack_self(mob/user as mob)
		src.active = !( src.active )
		if (src.active)
			user << "\blue You extend the plastic blade with a quick flick of your wrist."
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
			src.icon_state = "swordblue"
			src.item_state = "swordblue"
			src.w_class = 4
		else
			user << "\blue You push the plastic blade back down into the handle."
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
			src.icon_state = "sword0"
			src.item_state = "sword0"
			src.w_class = 2
		src.add_fingerprint(user)
		return

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/*
 * Crayons
 */

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Looks tasty. Mmmm..."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1.0
	attack_verb = list("attacked", "coloured")
	var/colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is jamming the [src.name] up \his nose and into \his brain. It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|OXYLOSS)

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = 1

	throw_impact(atom/hit_atom)
		..()
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		new /obj/effect/decal/cleanable/ash(src.loc)
		src.visible_message("\red The [src.name] explodes!","\red You hear a snap!")
		playsound(src, 'sound/effects/snap.ogg', 50, 1)
		del(src)

/obj/item/toy/snappop/HasEntered(H as mob|obj)
	if((ishuman(H))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == "run")
			M << "\red You step on the snap pop!"

			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(2, 0, src)
			s.start()
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message("\red The [src.name] explodes!","\red You hear a snap!")
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			del(src)

/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon = 'icons/obj/toy.dmi'
	icon_state = "ripleytoy"
	var/cooldown = 0

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user as mob)
	if(cooldown < world.time - 8)
		user << "<span class='notice'>You play with [src].</span>"
		playsound(user, 'sound/mecha/mechstep.ogg', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user as mob)
	if(loc == user)
		if(cooldown < world.time - 8)
			user << "<span class='notice'>You play with [src].</span>"
			playsound(user, 'sound/mecha/mechturn.ogg', 20, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"


/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/11."
	icon_state = "phazonprize"

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/obj/item/toy/zlofenix
	name = "Animus Phoenix"
	desc = "At some point in the life cycle of the Animus Phoenix dies and is reborn again."
	icon = 'icons/obj/toy.dmi'
	icon_state = "zlofenix"

/obj/item/toy/newyeartree
	name = "Miniature New Year tree"
	desc = "Tiny cute New Year tree."
	icon = 'icons/obj/toy.dmi'
	icon_state = "tinynewyeartree"
	w_class = 1
	force = 1
	throwforce = 1


/*
 * Toy C4
 */
/obj/item/toy/c4
	name = "toy bomb"
	desc = "A plastic model of a plastic explosive, as seen in action movies. Boom!"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = FPRINT | USEDELAY
	w_class = 2
	var/timer = 10
	var/atom/target = null
	var/overlayicon

/obj/item/toy/c4/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = Clamp(newtime, 10, 600)
		timer = newtime
		user << "Timer set for [timer] seconds."

/obj/item/toy/c4/afterattack(atom/target as obj|turf, mob/user as mob, flag)
	if(!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage))
		return
	user << "Planting explosives..."
	if(ismob(target))
		user.visible_message("\red [user.name] is trying to plant some kind of device on [target.name]!")

	if(do_after(user, 50) && in_range(user, target))
		user.drop_item()
		src.target = target
		loc = null

		if (ismob(target))
			user.visible_message("\red [user.name] finished planting a device on [target.name]!")

		overlayicon = image('icons/obj/assemblies.dmi', "plastic-explosive2")
		target.overlays += overlayicon
		user << "Toy has been planted. Timer counting down from [timer]."
		spawn(timer*10)
			explode(get_turf(target))

/obj/item/toy/c4/proc/explode(var/turf/location)
	if(!target)
		target = src

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 0, location)
	s.start()
	new /obj/effect/decal/cleanable/ash(location)
	location.visible_message("\red The [src.name] explodes!","\red You hear a snap!")
	playsound(src, 'sound/effects/snap.ogg', 50, 1)

	if(target)
		target.overlays -= overlayicon
	del(src)

/obj/item/toy/c4/attack(mob/M as mob, mob/user as mob)
	return

/*
 * Action Figures
 */

/obj/item/toy/figure
	name = "Non-Specific Action Figure action figure"
	desc = "A \"Space Life\" brand... wait, what the hell is this thing?"
	icon = 'icons/obj/toy.dmi'
	icon_state = "nonspecifictoy"
	var/cooldown = 0
	var/toysay = "What the fuck did you do?"
	var/obj/item/toy/accessory/hastoy = null

/obj/item/toy/figure/attack_self(mob/user as mob)
	if(!cooldown)
		user << "<span class='notice'>The [src] says \"[toysay]\".</span>"
		playsound(user, 'sound/machines/click.ogg', 20, 1)
		cooldown = 1
		spawn(30) cooldown = 0

/*/obj/item/toy/figure/attack_hand(mob/user as mob)
	if(loc == user)
		if(!cooldown)
			user << "<span class='notice'>The [src] says \"[toysay]\".</span>"
		playsound(user, 'sound/machines/click.ogg', 20, 1)
			cooldown = 1
			spawn(30) cooldown = 0
			return
*/
/obj/item/toy/figure/cmo
	name = "Chief Medical Officer action figure"
	desc = "A \"Space Life\" brand Chief Medical Officer action figure."
	icon_state = "cmo"
	toysay = "Suit sensors!"

/obj/item/toy/figure/assistant
	name = "Assistant action figure"
	desc = "A \"Space Life\" brand Assistant action figure."
	icon_state = "assistant"
	toysay = "Grey tide world wide!"

/obj/item/toy/figure/atmos
	name = "Atmospheric Technician action figure"
	desc = "A \"Space Life\" brand Atmospheric Technician action figure."
	icon_state = "atmos"
	toysay = "Glory to Atmosia!"

/obj/item/toy/figure/bartender
	name = "Bartender action figure"
	desc = "A \"Space Life\" brand Bartender action figure."
	icon_state = "bartender"
	toysay = "Where is Pun Pun?"

/obj/item/toy/figure/borg
	name = "Cyborg action figure"
	desc = "A \"Space Life\" brand Cyborg action figure."
	icon_state = "borg"
	toysay = "I. LIVE. AGAIN."

/obj/item/toy/figure/botanist
	name = "Botanist action figure"
	desc = "A \"Space Life\" brand Botanist action figure."
	icon_state = "botanist"
	toysay = "Dude, I see colors..."

/obj/item/toy/figure/captain
	name = "Captain action figure"
	desc = "A \"Space Life\" brand Captain action figure."
	icon_state = "captain"
	toysay = "Any heads of staff?"

/obj/item/toy/figure/cargotech
	name = "Cargo Technician action figure"
	desc = "A \"Space Life\" brand Cargo Technician action figure."
	icon_state = "cargotech"
	toysay = "For Cargonia!"

/obj/item/toy/figure/ce
	name = "Chief Engineer action figure"
	desc = "A \"Space Life\" brand Chief Engineer action figure."
	icon_state = "ce"
	toysay = "Wire the solars!"

/obj/item/toy/figure/chaplain
	name = "Chaplain action figure"
	desc = "A \"Space Life\" brand Chaplain action figure."
	icon_state = "chaplain"
	toysay = "Praise Space Jesus!"

/obj/item/toy/figure/chef
	name = "Chef action figure"
	desc = "A \"Space Life\" brand Chef action figure."
	icon_state = "chef"
	toysay = "Pun-Pun is a tasty burger."

/obj/item/toy/figure/chemist
	name = "Chemist action figure"
	desc = "A \"Space Life\" brand Chemist action figure."
	icon_state = "chemist"
	toysay = "Get your pills!"

/obj/item/toy/figure/clown
	name = "Clown action figure"
	desc = "A \"Space Life\" brand Clown action figure."
	icon_state = "clown"
	toysay = "Honk!"

/obj/item/toy/figure/ian
	name = "Ian action figure"
	desc = "A \"Space Life\" brand Ian action figure."
	icon_state = "ian"
	toysay = "Arf!"

/obj/item/toy/figure/detective
	name = "Detective action figure"
	desc = "A \"Space Life\" brand Detective action figure."
	icon_state = "detective"
	toysay = "This airlock has grey jumpsuit and insulated glove fibers on it."

/obj/item/toy/figure/dsquad
	name = "Death Squad Officer action figure"
	desc = "A \"Space Life\" brand Death Squad Officer action figure."
	icon_state = "dsquad"
	toysay = "Eliminate all threats!"

/obj/item/toy/figure/engineer
	name = "Engineer action figure"
	desc = "A \"Space Life\" brand Engineer action figure."
	icon_state = "engineer"
	toysay = "Oh god, the singularity is loose!"

/obj/item/toy/figure/geneticist
	name = "Geneticist action figure"
	desc = "A \"Space Life\" brand Geneticist action figure."
	icon_state = "geneticist"
	toysay = "Smash!"

/obj/item/toy/figure/hop
	name = "Head of Personel action figure"
	desc = "A \"Space Life\" brand Head of Personel action figure."
	icon_state = "hop"
	toysay = "Giving out all access!"

/obj/item/toy/figure/hos
	name = "Head of Security action figure"
	desc = "A \"Space Life\" brand Head of Security action figure."
	icon_state = "hos"
	toysay = "Get the justice chamber ready, I think we got a joker here."

/obj/item/toy/figure/qm
	name = "Quartermaster action figure"
	desc = "A \"Space Life\" brand Quartermaster action figure."
	icon_state = "qm"
	toysay = "Please sign this form in triplicate and we will see about geting you a welding mask within 3 business days."

/obj/item/toy/figure/janitor
	name = "Janitor action figure"
	desc = "A \"Space Life\" brand Janitor action figure."
	icon_state = "janitor"
	toysay = "Look at the signs, you idiot."

/obj/item/toy/figure/lawyer
	name = "Lawyer action figure"
	desc = "A \"Space Life\" brand Lawyer action figure."
	icon_state = "lawyer"
	toysay = "My client is a dirty traitor!"

/obj/item/toy/figure/librarian
	name = "Librarian action figure"
	desc = "A \"Space Life\" brand Librarian action figure."
	icon_state = "librarian"
	toysay = "One day while..."

/obj/item/toy/figure/md
	name = "Medical Doctor action figure"
	desc = "A \"Space Life\" brand Medical Doctor action figure."
	icon_state = "md"
	toysay = "The patient is already dead!"

/obj/item/toy/figure/mime
	name = "Mime action figure"
	desc = "A \"Space Life\" brand Mime action figure."
	icon_state = "mime"
	toysay = "..."

/obj/item/toy/figure/miner
	name = "Shaft Miner action figure"
	desc = "A \"Space Life\" brand Shaft Miner action figure."
	icon_state = "miner"
	toysay = "Oh god it's eating my intestines!"

/obj/item/toy/figure/ninja
	name = "Ninja action figure"
	desc = "A \"Space Life\" brand Ninja action figure."
	icon_state = "ninja"
	toysay = "Oh god! Stop shooting, I'm friendly!"

/obj/item/toy/figure/wizard
	name = "Wizard action figure"
	desc = "A \"Space Life\" brand Wizard action figure."
	icon_state = "wizard"
	toysay = "Ei Nath!"

/obj/item/toy/figure/rd
	name = "Research Director action figure"
	desc = "A \"Space Life\" brand Research Director action figure."
	icon_state = "rd"
	toysay = "Blowing all of the borgs!"

/obj/item/toy/figure/roboticist
	name = "Roboticist action figure"
	desc = "A \"Space Life\" brand Roboticist action figure."
	icon_state = "roboticist"
	toysay = "Big stompy mechs!"

/obj/item/toy/figure/scientist
	name = "Scientist action figure"
	desc = "A \"Space Life\" brand Scientist action figure."
	icon_state = "scientist"
	toysay = "For science!"

/obj/item/toy/figure/syndie
	name = "Nuclear Operative action figure"
	desc = "A \"Space Life\" brand Nuclear Operative action figure."
	icon_state = "syndie"
	toysay = "Get that fucking disk!"

/obj/item/toy/figure/secofficer
	name = "Security Officer action figure"
	desc = "A \"Space Life\" brand Security Officer action figure."
	icon_state = "secofficer"
	toysay = "I am the law!"

/obj/item/toy/figure/virologist
	name = "Virologist action figure"
	desc = "A \"Space Life\" brand Virologist action figure."
	icon_state = "virologist"
	toysay = "The cure is potassium!"

/obj/item/toy/figure/warden
	name = "Warden action figure"
	desc = "A \"Space Life\" brand Warden action figure."
	icon_state = "warden"
	toysay = "Seventeen minutes for coughing at an officer!"

