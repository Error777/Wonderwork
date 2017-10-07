var/datum/subsystem/xenoarch/SSxenoarch


/datum/subsystem/xenoarch
	name       = "Xenoarch"
	init_order = SS_INIT_MORE_INIT
	flags      = SS_NO_FIRE


/datum/subsystem/xenoarch/New()
	NEW_SS_GLOBAL(SSxenoarch)


/datum/subsystem/xenoarch/Initialize(timeofday)

	for(var/i=0, i<max_secret_rooms, i++)
		make_mining_asteroid_secret()

	..()