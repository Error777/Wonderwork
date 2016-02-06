var/global/list/camera_bugs = list()

/obj/item/device/spydevice
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	item_state = "electronic"
	w_class = 1.0
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_ID | SLOT_BELT
	var/obj/item/device/camera_bug/current
	var/network

/obj/item/device/spydevice/attack_self(mob/user as mob)
	if(!network && user.mind)
		network = "\ref[user.mind]"

	var/list/cameras = list()

	for(var/obj/item/device/camera_bug/C in camera_bugs)
		if(C.network == network)
			cameras += C

	if(!cameras.len)
		to_chat(user, "<span class='warning'>No camera bugs found.</span>")
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/item/device/camera_bug/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null|anything in sortList(friendly_cameras)

	if (!target)
		user.unset_machine()
		user.reset_view(user)
		return
	for(var/obj/item/device/camera_bug/C in cameras)
		if (C.c_tag == target)
			target = C
			break

	if(user.stat) return

	if(target)
		user.client.eye = target
		user.set_machine(src)
		src.current = target
	else
		user.unset_machine()
		return

/obj/item/device/spydevice/check_eye(var/mob/user as mob)
	if ( src.loc != user || user.get_active_hand() != src || !user.canmove || user.blinded || !current || !current.active )
		return null
	user.reset_view(current)
	return 1

/obj/item/device/camera_bug
	name = "bug"
	desc = ""	// Nothing to see here
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0"
	item_state = "nothing"
	force = 1
	w_class = 1.0
	throwforce = 1
	throw_range = 15
	throw_speed = 3
	origin_tech = "engineering=1;programming=2;syndicate=3"
	var/c_tag = ""
	var/active = 0
	var/network = ""
	var/list/excludes = list(/turf/simulated/floor, /turf/space, /turf/simulated/shuttle, /mob/living/carbon, /obj/item/weapon/storage)

/obj/item/device/camera_bug/attack_self(mob/user)
	var/newtag = sanitize(input("Set camera tag") as null|text)
	if(newtag)
		c_tag = newtag
		if(user.mind) network = "\ref[user.mind]"

/obj/item/device/camera_bug/afterattack(atom/A, mob/user)
	if(!c_tag || c_tag == "")
		to_chat(user, "<span class='notice'>Set the tag first dumbass</span>")
		return 0

	if(is_type_in_list(src.excludes))
		to_chat(user, "<span class='warning'>\The [src] won't stick!</span>")
		return 0

	if(istype(A, /obj/item))
		var/obj/item/I = A
		if(I.w_class < 3)
			to_chat(user, "<span class='warning'>\The [I] is too small for \the [src]</span>")
			return 0

	if(user.drop_item(src, A))
		to_chat(user, "<span class='notice'>You stealthily place \the [src] onto \the [A]</span>")
		active = 1
		camera_bugs += src
		return 1

/obj/item/device/camera_bug/emp_act(severity)
	switch(severity)
		if(3)
			if(prob(10))
				removed(message = "<span class='notice'>\The [src] deactivates and falls off!</span>", catastrophic = prob(1))
		if(2)
			if(prob(40))
				removed(message = "<span class='notice'>\The [src] deactivates and falls off!</span>", catastrohpic = prob(5))
		if(1)
			removed(message = "<span class='notice'>\The [src] deactivates and falls off!</span>", catastrohpic = prob(30))

/*
  user is who removed it if possible
  message is the displayed message on removal
  catastrophic is whether it should explode on removal or not
*/
/obj/item/device/camera_bug/proc/removed(mob/user = null, message = "[user] pries \the [src] away from \the [loc]", catastrophic = 0)
	active = 0
	camera_bugs  -= src
	loc = get_turf(src)
	visible_message(message)
	if(catastrophic)
		spawn(5)
			explosion(loc, 0, prob(15), 2, 0)

/obj/item/device/camera_bug/Del()
	camera_bugs -= src
	..()
