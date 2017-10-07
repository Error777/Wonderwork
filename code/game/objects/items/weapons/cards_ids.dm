/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("Data Disk- '[]'", t)
	else
		src.name = "Data Disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/obj/item/weapon/card/id/proc/UpdateName()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/*
 * ID CARDS
 */
/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"
	var/uses = 10

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	var/access = list()
	var/registered_name = null // The name registered_name on the card
	slot_flags = SLOT_ID

	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/bans = null
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0		// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/New()
	..()
	spawn(30)
	if(istype(loc, /mob/living/carbon/human))
		blood_type = loc:dna:b_type
		dna_hash = loc:dna:unique_enzymes
		fingerprint_hash = md5(loc:dna:uni_identity)

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	..()
	if(istype(W,/obj/item/weapon/id_wallet))
		user << "You slip [src] into [W]."
		src.name = "[src.registered_name]'s [W.name] ([src.assignment])"
		src.desc = W.desc
		src.icon = W.icon
		src.icon_state = W.icon_state
		del(W)
		return

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return


/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	origin_tech = "syndicate=3"
	var/registered_user=null

/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		to_chat(user, "<span class='notice'>The [src]'s microscanners activate as you pass it over \the [I], copying its access.</span>")
		access |= I.access
/*
/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(istype(user, /mob/living) && user.mind)
			if(user.mind.special_role)
				usr << "\blue The card's microscanners activate as you pass it over the ID, copying its access."

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = copytext(sanitize(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant")),1,MAX_MESSAGE_LEN)
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		user << "\blue You successfully forge the ID card."
	else
		..()
*/
/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = sanitize(stripped_input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Agent", MAX_MESSAGE_LEN))
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		to_chat(user, "<span class='notice'>You successfully forge the ID card.</span>")
		registered_user = user
	else if(!registered_user || registered_user == user)

		if(!registered_user) registered_user = user  //

		switch(alert(user,"Would you like to display \the [src] or edit it?","Choose.","Show","Edit"))
			if("Show")
				return ..()
			if("Edit")
				switch(input(user,"What would you like to edit on \the [src]?") in list("Name","Appearance","Occupation","Money account","Blood type","DNA hash","Fingerprint hash","Reset card"))
					if("Name")
						var/new_name = reject_bad_name(input(user,"What name would you like to put on this card?","Agent card name", ishuman(user) ? user.real_name : user.name))
						if(!Adjacent(user)) return

						src.registered_name = new_name
						UpdateName()
						to_chat(user, "Name changed to [new_name].")

					if("Appearance")
						var/list/appearances = list(
							"data",
							"id",
							"gold",
							"silver",
							"soviet",
							"centcom",
							"security",
							"medical",
							"research",
							"supply",
							"engineering",
							"command",
							"ce",
							"cmo",
							"rd",
							"hos",
							"clown",
							"civilian",
							"prison",
							"mime",
							"syndicate",
						)
						var/choice = input(user, "Select the appearance for this card.", "Choose.") in appearances
						if(!Adjacent(user))
							return
						if(!choice)
							return
						src.icon_state = choice
						to_chat(usr, "Appearance changed to [choice].")

					if("Occupation")
						var/new_job = sanitize(stripped_input(user,"What job would you like to put on this card?\nChanging occupation will not grant or remove any access levels.","Agent card occupation", "Assistant", MAX_MESSAGE_LEN))
						if(!Adjacent(user)) return
						src.assignment = new_job
						to_chat(user, "Occupation changed to [new_job].")
						UpdateName()

					if("Money account")
						var/new_account = input(user,"What money account would you like to link to this card?","Agent card account",11111) as num
						if(!Adjacent(user)) return
						associated_account_number = new_account
						to_chat(user, "Linked money account changed to [new_account].")

					if("Blood type")
						var/default = "\[UNSET\]"
						if(ishuman(user))
							var/mob/living/carbon/human/H = user

							if(H.dna)
								default = H.dna.b_type

						var/new_blood_type = sanitize(input(user,"What blood type would you like to be written on this card?","Agent card blood type",default) as text)
						if(!Adjacent(user)) return
						src.blood_type = new_blood_type
						to_chat(user, "Blood type changed to [new_blood_type].")

					if("DNA hash")
						var/default = "\[UNSET\]"
						if(ishuman(user))
							var/mob/living/carbon/human/H = user

							if(H.dna)
								default = H.dna.unique_enzymes

						var/new_dna_hash = sanitize(input(user,"What DNA hash would you like to be written on this card?","Agent card DNA hash",default) as text)
						if(!Adjacent(user)) return
						src.dna_hash = new_dna_hash
						to_chat(user, "DNA hash changed to [new_dna_hash].")

					if("Fingerprint hash")
						var/default = "\[UNSET\]"
						if(ishuman(user))
							var/mob/living/carbon/human/H = user

							if(H.dna)
								default = md5(H.dna.uni_identity)

						var/new_fingerprint_hash = sanitize(input(user,"What fingerprint hash would you like to be written on this card?","Agent card fingerprint hash",default) as text)
						if(!Adjacent(user)) return
						src.fingerprint_hash = new_fingerprint_hash
						to_chat(user, "Fingerprint hash changed to [new_fingerprint_hash].")

					if("Reset card")
						name = initial(name)
						registered_name = initial(registered_name)
						icon_state = initial(icon_state)
						assignment = initial(assignment)
						associated_account_number = initial(associated_account_number)
						blood_type = initial(blood_type)
						dna_hash = initial(dna_hash)
						fingerprint_hash = initial(fingerprint_hash)
						access = initial(access)
						registered_user = null

						to_chat(user, "<span class='notice'>All information has been deleted from \the [src].</span>")
	else
		..()

/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	icon_state = "syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

	New()
		access = get_all_centcom_access()
		..()

/obj/item/weapon/card/id/prisoner
	name = "prisoner ID card"
	desc = "You are a number, you are not a free man."
	icon_state = "prison"
	item_state = "prison-id"
	assignment = "Prisoner"
	registered_name = "Scum"
	var/goal = 0 //How far from freedom?
	var/points = 0

/obj/item/weapon/card/id/prisoner/attack_self(mob/user as mob)
	usr << "<span class='notice'>You have accumulated [points] out of the [goal] points you need for freedom.</span>"

/obj/item/weapon/card/id/prisoner/one
	name = "Prisoner #13-001"
	registered_name = "Prisoner #13-001"

/obj/item/weapon/card/id/prisoner/two
	name = "Prisoner #13-002"
	registered_name = "Prisoner #13-002"

/obj/item/weapon/card/id/prisoner/three
	name = "Prisoner #13-003"
	registered_name = "Prisoner #13-003"

/obj/item/weapon/card/id/prisoner/four
	name = "Prisoner #13-004"
	registered_name = "Prisoner #13-004"

/obj/item/weapon/card/id/prisoner/five
	name = "Prisoner #13-005"
	registered_name = "Prisoner #13-005"

/obj/item/weapon/card/id/prisoner/six
	name = "Prisoner #13-006"
	registered_name = "Prisoner #13-006"

/obj/item/weapon/card/id/prisoner/seven
	name = "Prisoner #13-007"
	registered_name = "Prisoner #13-007"

/obj/item/weapon/card/id/civilian
	name = "Civilian ID"
	registered_name = "Assistant"
	icon_state = "civilian"
	desc = "Holy shit. Where am I?"

/obj/item/weapon/card/id/medical
	name = "Medical ID"
	registered_name = "Doctor"
	icon_state = "medical"
	desc = "A card covered in the blood stains of the wild ride."

/obj/item/weapon/card/id/security
	name = "Security ID"
	registered_name = "Officer"
	icon_state = "security"
	desc = "Some say these cards are drowned in the tears of assistants, forged in the burning bodies of clowns."

/obj/item/weapon/card/id/research
	name = "Research ID"
	registered_name = "Scientist"
	icon_state = "research"
	desc = "Pinnacle of name technology."

/obj/item/weapon/card/id/supply
	name = "Supply ID"
	registered_name = "Cargomen"
	icon_state = "supply"
	desc = "ROH ROH! HEIL THE QUARTERMASTER!"

/obj/item/weapon/card/id/engineering
	name = "Engineering ID"
	registered_name = "Engineer"
	icon_state = "engineering"
	desc = "Shame it's going to be lost in the void of a black hole."

/obj/item/weapon/card/id/hos
	name = "Head of Security ID"
	registered_name = "HoS"
	icon_state = "hos"
	desc = "An ID awarded to only the most robust shits in the buisness."

/obj/item/weapon/card/id/cmo
	name = "Chief Medical Officer ID"
	registered_name = "CMO"
	icon_state = "cmo"
	desc = "It gives off the faint smell of chloral, mixed with a backdraft of shittery."

/obj/item/weapon/card/id/rd
	name = "Research Director ID"
	registered_name = "RD"
	icon_state = "rd"
	desc = "If you put your ear to the card, you can faintly hear screaming, glomping, and mechs. What the fuck."

/obj/item/weapon/card/id/ce
	name = "Chief Engineer ID"
	registered_name = "CE"
	icon_state = "ce"
	desc = "The card has a faint aroma of autism."

/obj/item/weapon/card/id/clown
	name = "Pink ID"
	registered_name = "HONK!"
	icon_state = "clown"
	desc = "Even looking at the card strikes you with deep fear."

/obj/item/weapon/card/id/mime
	name = "Black and White ID"
	registered_name = "..."
	icon_state = "mime"
	desc = "..."

/obj/item/weapon/id_wallet
	name = "ID wallet"
	icon = 'icons/obj/card.dmi'
	icon_state = "passport1"
	desc = "A wallet made of black leather, holding an ID and a gold badge that reads 'NT.'"

