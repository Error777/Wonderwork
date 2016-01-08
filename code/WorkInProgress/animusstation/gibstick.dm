//FERNFLOWER STUFF//
/obj/item/weapon/melee/gibstick
	name = "Centcomm Manipulation Device"
	desc = "Product of weird technology from deepest CentComm labs."
	icon = 'icons/obj/device.dmi'
	icon_state = "gibstick"
	var/mode

	attack_self (mob/user)
		mode ++
		if(mode == 5)
			mode = 0
		switch(mode)
			if(0)
				usr << "You turn off manipulation device"
			if(1)
				usr << "You turn gib mode"
			if(2)
				usr << "You turn stun mode"
			if(3)
				usr << "You turn heal mode"
			if(4)
				usr << "You turn cuff mode"

	attack(mob/living/carbon/M as mob, mob/user as mob)
		switch(mode)
			if(0)
				..()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[user] has turned off CentComm Manipulation Device!</B>", 1, "\red You hear something clicked", 2)
			if(1)
				M.gib()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been destroyed with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone gibs", 2)
					message_admins("ADMIN: [user] gibbed ([M]) with the CCMD.")
					log_game("[user] gibbed ([M]) with the CCMD.")
			if(2)
				M.Stun(25)
				M.Weaken(25)
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been stunned with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone fall", 2)
					message_admins("ADMIN: [user] stunned ([M]) with the CCMD.")
					log_game("[user] stunned ([M]) with the CCMD.")
			if(3)
				M.revive()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been healed with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone heals", 2)
					message_admins("ADMIN: [user] healed ([M]) with the CCMD.")
					log_game("[user] healed ([M]) with the CCMD.")
			if(4)
				M.handcuffed = new /obj/item/weapon/handcuffs(M)
				M.update_inv_handcuffed()	//update the handcuffs overlay
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been handcuffed with the CCMD by [user]!</B>", 1, "\red You hear someone screams", 2)
					message_admins("ADMIN: [user] handcuffed ([M]) with the CCMD.")
					log_game("[user] handcuffed ([M]) with the CCMD.")
		return