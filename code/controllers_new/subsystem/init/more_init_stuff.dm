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
	var/watch=start_watch()

	watch=start_watch()
	log_startup_progress("Caching space parallax simulation...")
	create_global_parallax_icons()
	log_startup_progress("  Finished caching space parallax simulation in [stop_watch(watch)]s.")