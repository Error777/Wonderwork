//RISK CODE HERE DON'T USE IN LIVE SERVER,ALSO THERE'S NO CHECK FOR ADMINS SO ANYONE CAN USE IT WATCHOUTYO
//Special proc to set up the server for mapping via screenshots
/client/verb/mapWorld()
	set name = "Map World"
	set desc = "Takes a series of screenshots for mapping"
	set category = "Debug"

	//Gotta prevent dummies
	var/confirm = alert("WARNING: This proc should absolutely not be run on a live server! Make sure you know what you are doing!", "WARNING", "Cancel", "Proceed")
	if(confirm == "Cancel")
		return

	//Viewport size
	var/viewport_width
	var/viewport_height
	var/inputView = input(src, "Set your desired viewport size. (60 for 300x300 maps, 50 for 200x200)", "Viewport Size", 60) as num
	if (inputView < 1)
		return
	else
		viewport_width = inputView
		viewport_height = inputView

	src.view = "[viewport_width]x[viewport_height]"

	//Z levels to map
	var/z
	var/allZ = 0
	var/safeAllZ = 0
	var/inputZ = input(src, "What Z level do you want to map? (10 for all levels, 11 for all except centcom level)", "Z Level", 11) as num
	if (inputZ < 1)
		return
	else if (inputZ == 10)
		allZ = 1
	else if (inputZ == 11)
		safeAllZ = 1
	else z = inputZ

	var/delay
	var/inputDelay = input(src, "Delay between changing location/taking screenshots. (If unsure, leave as as default)", "Delay", 7) as num
	if (inputDelay < 1)
		return
	else delay = inputDelay
	var/start_x = (viewport_width / 2) + 1
	var/start_y = (viewport_height / 2) + 1

        //Map eeeeverything
	if (allZ || safeAllZ)
		for (var/curZ = 1; curZ <= world.maxz; curZ++)
			if (safeAllZ && curZ == 2)
				continue //Skips centcom
			for (var/y = start_y; y <= world.maxy; y += viewport_height)
				for (var/x = start_x; x <= world.maxx; x += viewport_width)
					src.mob.x = x
					src.mob.y = y
					src.mob.z = curZ
					sleep(delay)
					winset(src, null, "command=\".screenshot auto\"")
					sleep(delay)
			if (curZ != world.maxz)
				var/pause = alert("Z Level ([curZ]) finished. Organise your screenshot files and press Ok to continue or Cancel to cease mapping.", "Tea break", "Ok", "Cancel")
				if (pause == "Cancel")
					return
        //Or just one level I GUESS
	else
		for (var/y = start_y; y <= world.maxy; y += viewport_height)
			for (var/x = start_x; x <= world.maxx; x += viewport_width)
				src.mob.x = x
				src.mob.y = y
				src.mob.z = z
				sleep(delay)
				winset(src, null, "command=\".screenshot auto\"")
				sleep(delay)

	alert("Mapping complete!", "Yay!", "Ok")