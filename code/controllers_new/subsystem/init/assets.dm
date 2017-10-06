var/datum/subsystem/assets/SSassets


/datum/subsystem/assets
	name       = "Asset Cache"
	init_order = SS_INIT_ASSETS
	flags      = SS_NO_FIRE


/datum/subsystem/assets/New()
	NEW_SS_GLOBAL(SSassets)


/datum/subsystem/assets/Initialize(timeofday)
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()
	..()
