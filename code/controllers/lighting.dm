#define STAGE_SOURCES  1
#define STAGE_CORNERS  2
#define STAGE_OVERLAYS 3

var/datum/controller/lighting/lighting_controller

var/list/lighting_update_lights    = list() // List of lighting sources  queued for update.
var/list/lighting_update_corners   = list() // List of lighting corners  queued for update.
var/list/lighting_update_overlays  = list() // List of lighting overlays queued for update.


/datum/controller/lighting
	var/initialized = FALSE

	var/iteration = 0
	var/processing = 0
	var/processing_interval = 5	//setting this too low will probably kill the server. Don't be silly with it!

	var/list/currentrun_lights
	var/list/currentrun_corners
	var/list/currentrun_overlays

	var/paused = 0        // Was this controller paused mid fire.
	var/paused_ticks = 0  // Ticks this ss is taking to run right now.
	var/paused_tick_usage // Total tick_usage of all of our runs while pausing this run

	var/resuming_stage = 0


/datum/controller/lighting/New()
	if(lighting_controller != src)
		if(istype(lighting_controller,/datum/controller/lighting))
			Recover()
			del(lighting_controller)
		lighting_controller = src

/datum/controller/lighting/proc/pause()
	. = 1
	paused = TRUE
	paused_ticks++

/datum/controller/lighting/proc/stat_entry()
	var/msg = "L:[lighting_update_lights.len]|C:[lighting_update_corners.len]|O:[lighting_update_overlays.len]"
	to_chat(world, "<span class='danger'>[msg]</span>")

/datum/controller/lighting/proc/Initialize(timeofday)
	create_all_lighting_overlays()
	initialized = TRUE
	var/time = (world.timeofday - timeofday) / 10
	var/msg = "Initialized Lighting controller within [time] seconds!"
	to_chat(world, "<span class='danger'>[msg]</span>")
	stat_entry()
	return time

/datum/controller/lighting/proc/process()
	if (resuming_stage == 0)
		currentrun_lights   = lighting_update_lights
		lighting_update_lights   = list()

		resuming_stage = STAGE_SOURCES

	while (currentrun_lights.len)
		var/datum/light_source/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if (L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if (!L.destroyed)
				L.apply_lum()

		else if (L.vis_update) //We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		if ( world.tick_usage > 80 ? pause() : 0 )
			return

	if (resuming_stage == STAGE_SOURCES)
		if (currentrun_corners && currentrun_corners.len)
			to_chat(world, "we still have corners to do, but we're gonna override them?")

		currentrun_corners  = lighting_update_corners
		lighting_update_corners  = list()

		resuming_stage = STAGE_CORNERS

	while (currentrun_corners.len)
		var/datum/lighting_corner/C = currentrun_corners[currentrun_corners.len]
		currentrun_corners.len--

		C.update_overlays()
		C.needs_update = FALSE

		if ( world.tick_usage > 80 ? pause() : 0 )
			return

	if (resuming_stage == STAGE_CORNERS)
		currentrun_overlays = lighting_update_overlays
		lighting_update_overlays = list()

		resuming_stage = STAGE_OVERLAYS

	while (currentrun_overlays.len)
		var/atom/movable/lighting_overlay/O = currentrun_overlays[currentrun_overlays.len]
		currentrun_overlays.len--

		O.update_overlay()
		O.needs_update = FALSE

		if ( world.tick_usage > 80 ? pause() : 0 )
			return

	resuming_stage = 0


/datum/controller/lighting/proc/Recover()
	initialized = lighting_controller.initialized
	lighting_controller.Initialize(world.timeofday)

#undef STAGE_SOURCES
#undef STAGE_CORNERS
#undef STAGE_OVERLAYS
