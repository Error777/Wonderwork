var/datum/subsystem/more_init/SSmore_init

/datum/subsystem/more_init
	name       = "Uncategorized Init"
	init_order = SS_INIT_MORE_INIT
	flags      = SS_NO_FIRE

/datum/subsystem/more_init/New()
	NEW_SS_GLOBAL(SSmore_init)

/datum/subsystem/more_init/Initialize(timeofday)
	setupfactions()
	setup_economy()
	create_global_parallax_icons()