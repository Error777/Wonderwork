/area
	luminosity           = 1
	var/dynamic_lighting = 1

/area/New()
	. = ..()

	if (dynamic_lighting)
		luminosity = 0

/area/proc/set_dynamic_lighting(var/new_dynamic_lighting = 1)
	if (new_dynamic_lighting == dynamic_lighting)
		return 0

	dynamic_lighting = new_dynamic_lighting

	if (new_dynamic_lighting)
		for (var/turf/T in world)
			if (T.dynamic_lighting)
				T.lighting_build_overlay()

	else
		for (var/turf/T in world)
			if (T.lighting_overlay)
				T.lighting_clear_overlay()

	return 1
