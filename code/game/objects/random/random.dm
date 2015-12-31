/obj/random
	name = "Random Object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/misc/random.dmi'
	icon_state = "standart"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything


// creates a new object and deletes itself
/obj/random/New()
	..()
	if (!prob(spawn_nothing_percentage))
		spawn_item()
	del src


// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	return (new build_path(src.loc))


/obj/random/tool
	name = "random tool"
	desc = "This is a random tool"
	icon_state = "tool"
	item_to_spawn()
		return pick(/obj/item/weapon/screwdriver,\
					/obj/item/weapon/wirecutters,\
					/obj/item/weapon/weldingtool,\
					/obj/item/weapon/crowbar,\
					/obj/item/weapon/wrench,\
					/obj/item/device/flashlight)


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon_state = "technology_scanner"
	item_to_spawn()
		return pick(prob(5);/obj/item/device/t_scanner,\
					prob(2);/obj/item/device/radio,\
					prob(5);/obj/item/device/analyzer)


/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon_state = "powercell"
	item_to_spawn()
		return pick(prob(10);/obj/item/weapon/cell/crap,\
					prob(40);/obj/item/weapon/cell,\
					prob(40);/obj/item/weapon/cell/high,\
					prob(5);/obj/item/weapon/cell/super,\
					prob(4);/obj/item/weapon/cell/potato,\
					prob(1);/obj/item/weapon/cell/hyper)


/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon_state = "bomb_supply"
	item_to_spawn()
		return pick(/obj/item/device/assembly/igniter,\
					/obj/item/device/assembly/prox_sensor,\
					/obj/item/device/assembly/signaler,\
					/obj/item/device/multitool)


/obj/random/toolbox
	name = "random toolbox"
	desc = "This is a random toolbox."
	icon_state = "toolbox"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/toolbox/mechanical,\
					prob(2);/obj/item/weapon/storage/toolbox/electrical,\
					prob(1);/obj/item/weapon/storage/toolbox/emergency)


/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon_state = "tech_supply"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/random/powercell,\
					prob(2);/obj/random/technology_scanner,\
					prob(1);/obj/item/weapon/packageWrap,\
					prob(2);/obj/random/bomb_supply,\
					prob(1);/obj/item/weapon/extinguisher,\
					prob(3);/obj/item/weapon/cable_coil/random,\
					prob(2);/obj/random/toolbox,\
					prob(2);/obj/item/weapon/storage/belt/utility,\
					prob(5);/obj/random/tool)

/obj/random/medical
	name = "Random Medicine"
	desc = "This is a random medical item."
	icon_state = "medical"
	spawn_nothing_percentage = 25
	item_to_spawn()
		return pick(prob(4);/obj/item/stack/medical/bruise_pack,\
					prob(4);/obj/item/stack/medical/ointment,\
					prob(2);/obj/item/stack/medical/advanced/bruise_pack,\
					prob(2);/obj/item/stack/medical/advanced/ointment,\
					prob(1);/obj/item/stack/medical/splint,\
					prob(2);/obj/item/bodybag,\
					prob(1);/obj/item/bodybag/cryobag,\
					prob(2);/obj/item/weapon/storage/pill_bottle/kelotane,\
					prob(2);/obj/item/weapon/storage/pill_bottle/antitox,\
					prob(2);/obj/item/weapon/storage/pill_bottle/inaprovaline,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/antitoxin,\
					prob(1);/obj/item/weapon/reagent_containers/syringe/antiviral,\
					prob(2);/obj/item/weapon/reagent_containers/syringe/inaprovaline)


/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon_state = "firstaid"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/storage/firstaid/regular,\
					prob(2);/obj/item/weapon/storage/firstaid/toxin,\
					prob(2);/obj/item/weapon/storage/firstaid/o2,\
					prob(1);/obj/item/weapon/storage/firstaid/adv,\
					prob(2);/obj/item/weapon/storage/firstaid/fire)


/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon_state = "contraband"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/soap/syndie,\
					prob(4);/obj/item/weapon/melee/energy/sword,\
					prob(2);/obj/item/weapon/plastique,\
					prob(2);/obj/item/weapon/cloaking_device,\
					prob(5);/obj/item/weapon/card/emag,\
					prob(2);/obj/item/weapon/gun/energy/crossbow,\
					prob(3);/obj/item/weapon/chainsaw,\
					prob(3);/obj/item/clothing/under/chameleon,\
					prob(3);/obj/item/device/camera_bug,\
					prob(1);/obj/item/device/multitool/uplink,\
					prob(2);/obj/item/weapon/storage/toolbox/syndicate,\
					prob(2);/obj/item/clothing/glasses/thermal/syndi,\
					prob(3);/obj/item/clothing/glasses/night,\
					prob(3);/obj/item/weapon/storage/box/emps,\
					prob(2);/obj/item/weapon/storage/box/syndie_kit/space_random,\
					prob(2);/obj/item/device/debugger,\
					prob(3);/obj/item/weapon/gun/projectile/revolver)


/obj/random/energy
	name = "Random Energy Weapon"
	desc = "This is a random security weapon."
	icon_state = "energy"
	item_to_spawn()
		return pick(prob(2);/obj/item/weapon/gun/energy/laser,\
					prob(2);/obj/item/weapon/gun/energy/gun,\
					prob(1);/obj/item/weapon/gun/energy/taser)

/obj/random/projectile
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon_state = "projectile"
	item_to_spawn()
		return pick(prob(1);/obj/item/weapon/gun/projectile/shotgun/combat,\
					prob(3);/obj/item/weapon/gun/projectile/revolver/mateba,\
					prob(1);/obj/item/weapon/gun/projectile/automatic/c20r)

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random security weapon."
	icon_state = "handgun"
	item_to_spawn()
		return pick(prob(3);/obj/item/weapon/gun/projectile/revolver/detective,\
					prob(1);/obj/item/weapon/gun/projectile/revolver/detective/fluff/callum_leamas)


/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon_state = "ammo"
	item_to_spawn()
		return pick(prob(6);/obj/item/ammo_magazine/box/shotgun/bean,\
					prob(2);/obj/item/ammo_magazine/box/shotgun/dart,\
					prob(4);/obj/item/ammo_magazine/box/shotgun,\
					prob(1);/obj/item/ammo_magazine/box/shotgun/stun,\
					prob(2);/obj/item/ammo_magazine/external/mc9mm,\
					prob(4);/obj/item/ammo_magazine/external/m12mm,\
					prob(4);/obj/item/ammo_magazine/box/c38,\
					prob(2);/obj/item/ammo_magazine/box/c38/e,\
					prob(6);/obj/item/ammo_magazine/external/sm45)