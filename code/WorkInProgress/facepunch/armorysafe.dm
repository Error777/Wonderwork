/obj/structure/closet/secure_closet/armorysafe
	name = "Emergency Gun Safe"
	desc = "BLAM BLAM BLAM."
	icon = 'icons/obj/closet.dmi'
	icon_state = "emergarm"
	density = 1
	opened = 0
	locked = 1
	broken = 0
	icon_closed = "emergarm"
	icon_opened = "emergarmopen"
	icon_locked = "emergarm"
	icon_broken = "amergarmopen"
	icon_off = "emergarm"
	health = 400
	anchored = 1

/obj/structure/closet/secure_closet/armorysafe/togglelock(mob/user as mob)
	user << "<span class='notice'>Access Denied: Two members of staff with Armory access must swipe their cards on the side panels to open this safe.</span>"

/obj/structure/closet/secure_closet/armorysafe/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if((istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)||istype(W, /obj/item/device/multitool)) && !src.broken)
		return

/obj/structure/closet/secure_closet/armorysafe/proc/unlock()
	locked = 0
	src.visible_message("\red The Emergency Armory Safe clicks open!")
	icon_opened = "emergarmopen"

/obj/structure/closet/secure_closet/armorysafe/can_close()
	if(opened)
		return 0


/obj/machinery/safe_control
	name = "safe-unlock button"
	desc = "It controls safe, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doombutton"
	power_channel = ENVIRON
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	var/opened_safe = 0
	var/opened_button = 0


/obj/machinery/safe_control/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)

	if(opened_button == 0)
		icon_state = "doombutton_o"
		playsound(src.loc, 'sound/items/flashlight.ogg', 75, 1)
		opened_button = 1

	else if(opened_button == 1 && !opened_safe)
		for(var/obj/structure/closet/secure_closet/armorysafe/A in world)
			if(A.z == 1)
				if(A.locked)
					A.unlock()
					A.open()
		opened_safe = 1
		opened_button = 2
		icon_state = "doombutton_push"
		world << "<font size=4 color='red'>Emergency Armory has been opened</font>"
		world << "<font color='red'>Attention. A high level emergency has been detected on the station. Please be cautious and follow the orders of the heads of staff.</font>"
		world << sound('sound/AI/highlevelemergency.ogg')

	else return