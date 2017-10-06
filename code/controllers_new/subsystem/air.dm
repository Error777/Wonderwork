var/datum/subsystem/air/SSair

var/air_processing_killed = FALSE


/datum/subsystem/air
	name          = "Air"
	init_order    = SS_INIT_AIR
	priority      = SS_PRIORITY_AIR
	wait          = 2 SECONDS
	flags         = SS_NO_TICK_CHECK
	display_order = SS_DISPLAY_AIR


/datum/subsystem/air/New()
	NEW_SS_GLOBAL(SSair)


/datum/subsystem/air/stat_entry()
	if (air_master)
		..("Z:[zones.len]|TU:[air_master.tiles_to_update.len]|TTZ:[air_master.tiles_to_reconsider_zones.len]|F:[air_master.active_hotspots.len]")
	else
		..("AIR MASTER DOES NOT EXIST.")

/datum/subsystem/air/Initialize(timeofday)
	if (!air_master)
		air_master = new /datum/controller/air_system()
		air_master.setup()

	..()

/datum/subsystem/air/fire(resumed = FALSE)
	// No point doing MC_TICK_CHECK.
	if(!air_processing_killed)
//		last_thing_processed = air_master.type
		air_master.current_cycle++
		if(!air_master.tick()) //Runtimed.
			air_master.failed_ticks++
			if(air_master.failed_ticks > 5)

				world << "<font color='red'><b>RUNTIMES IN ATMOS TICKER.  Killing air simulation!</font></b>"
				world.log << "### ZAS SHUTDOWN"
				message_admins("ZASALERT: unable to run [air_master.tick_progress], shutting down!")
				log_admin("ZASALERT: unable run zone/process() -- [air_master.tick_progress]")

				air_processing_killed = 1
				air_master.failed_ticks = 0