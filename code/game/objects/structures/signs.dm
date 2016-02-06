/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			del(src)
			return
		else
	return

/obj/structure/sign/blob_act()
	del(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/weapon/screwdriver) && !istype(src, /obj/structure/sign/double))
		user << "You unfasten the sign with your [tool]."
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		del(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = 3		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		user << "You fasten \the [S] with your [tool]."
		del(src)
	else ..()

/obj/structure/sign/wantedposter
	name = "Wanted poster"
	desc = "An old faded wanted poster with a picture of somebody wearing a gas mask. The text is illegible from age."
	icon_state = "wantedposter"

/obj/structure/sign/double/map
	icon_state = "map"
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/soviet/passport
	name = "My comrade"
	desc = "A sign depicting a passport os USSR-3, the slogan reads 'Moy tovarysch.'"
	icon_state = "sovietposter"

/obj/structure/sign/soviet/ks13glory
	name = "KS13"
	desc = "A sign which reads 'Glory to the space station of The New Comintern!"
	icon_state = "KC13glory"

/obj/structure/sign/soviet/armyglory
	name = "Space Army"
	desc = "A sign which reads 'Glory to the Space Army!"
	icon_state = "glorytospacearmy"

/obj/structure/sign/double/planet
	name = "planet"
	desc = "A framed picture of the planet."

/obj/structure/sign/double/planet/left
	icon_state = "planet-left"

/obj/structure/sign/double/planet/right
	icon_state = "planet-right"

/obj/structure/sign/double/sky
	name = "cloudy sky"
	desc = "A framed picture of the cloudy sky."

/obj/structure/sign/double/sky/left
	icon_state = "sky-left"

/obj/structure/sign/double/sky/right
	icon_state = "sky-right"

/obj/structure/sign/double/mountain
	name = "mountain"
	desc = "A framed picture of the mountain."

/obj/structure/sign/double/mountain/left
	icon_state = "mountain-left"

/obj/structure/sign/double/mountain/right
	icon_state = "mountain-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'"
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'"
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'"
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'"
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'"
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'"
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'"
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'"
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "\improper medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "\improper medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "greencross"

/obj/structure/sign/medbaylogo
	name = "\improper medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "medlogo"

/obj/structure/sign/medbaylogo2
	name = "\improper medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here.'"
	icon_state = "medlogo2"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/animusposter
	name = "Clear Portrait"
	desc = "Stay Animus. Stay Robust."
	icon = 'icons/obj/animusposters.dmi'
	icon_state = "clear"

/obj/structure/sign/kiddieplaque
	name = "AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA Atmospherics Division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'"
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'"
	icon_state = "chemistry1"

/obj/structure/sign/radiation
	name = "\improper RADIOACTIVE AREA"
	desc = "A warning sign which reads 'RADIOACTIVE AREA'."
	icon_state = "radiation"

/obj/structure/sign/sovietradiation
	name = "\improper RADIOACTIVE AREA"
	desc = "A warning sign which reads 'RADIOACTIVE AREA'."
	icon_state = "goonradiation"

/obj/structure/sign/soviet
	name = "\improper SOVIET SERP AND MOLOT"
	desc = "In NanoTrasen, you can always find a party, in Space Soviet Russia, Party finds YOU!!"
	icon_state = "sovietbanner"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'"
	icon_state = "hydro1"

/obj/structure/sign/tombstone
	name = "\improper tombstone"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tombstone"
	desc = "An old tombstone marking a grave of a Black Tyranny."

/obj/structure/sign/casino
	name = "Casino Night"
	desc = "Come on in and have a drink!."
	icon = 'icons/obj/scooterstuff.dmi'
	icon_state = "casino"

/*####################D2 SIGNS####################*/
/*obj/structure/sign/noshitlers
	name = "No shitlers!"
	desc = "A warning sign which reads 'No shitlers allowed!'"
	icon_state = "noshitlers"*/ //Sometime

/obj/structure/sign/cleanhands
	name = "CLEAN HANDS!"
	desc = "A warning sign which reads 'Clean hands! Save Lives!'"
	icon_state = "cleanhands"

/obj/structure/sign/silenceplease
	name = "Silence please!"
	desc = "A warning sign which reads 'Silence please!'"
	icon_state = "silenceplease"

/obj/structure/sign/medholo
	name = "Medical Hologram"
	desc = "A medical hologram. Looks very nice."
	icon_state = "medholo"

/obj/structure/sign/noshit
	name = "People DIE if you KILL!"
	desc = "A warning sign which reads 'People DIE if you KILL!'"
	icon_state = "noshit"

/obj/structure/sign/double/laundromat
	name = "Laundromat"
	icon = 'icons/obj/barsigns.dmi'
	desc = "Laundromat"
	icon_state = "laundromat"

/obj/structure/sign/double/church
	name = "Jesus Chatline"
	icon = 'icons/obj/barsigns.dmi'
	desc = ""
	icon_state = "church"

/obj/structure/sign/double/bully
	name = "No cyberbullying!"
	icon = 'icons/obj/barsigns.dmi'
	desc = ""
	icon_state = "bully"

/obj/structure/sign/double/chan
	name = "for chan poster"
	icon_state = "4chan"

/obj/structure/sign/double/chan/left1
	icon_state = "chan0"

/obj/structure/sign/double/chan/left2
	icon_state = "chan1"

/obj/structure/sign/double/chan/right1
	icon_state = "chan2"

/obj/structure/sign/double/chan/right2
	icon_state = "chan3"

/obj/structure/sign/medicalarrow
	name = "Medical Arrow"
	desc = ""
	icon_state = "medicalfs"


/*####################DECK SIGNS####################*/
/obj/structure/sign/deck/bridge
	name = "Bridge"
	desc = ""

	bridge0
		icon_state = "bridge0"
	bridge1
		icon_state = "bridge1"
	bridge2
		icon_state = "bridge2"

/obj/structure/sign/deck/sub
	name = "Sub Deck"
	desc = ""

	sub0
		icon_state = "sub0"
	sub1
		icon_state = "sub1"

/obj/structure/sign/deck/main
	name = "Main Deck"
	desc = ""

	main0
		icon_state = "main0"
	main1
		icon_state = "main1"

/obj/structure/sign/deck/engine
	name = "Engine Deck"
	desc = ""

	enge0
		icon_state = "enge0"
	enge1
		icon_state = "enge1"
	enge2
		icon_state = "enge2"
	enge3
		icon_state = "enge3"

/*####################SIGNS OF DEPATRTAMENTS####################*/

/obj/structure/sign/departments/library
	desc = "Library"
	name = "Library"
	icon_state = "library"

/obj/structure/sign/departments/old/lounge
	desc = "The Lounge"
	name = "The Lounge"
	icon_state = "lounge_old"

/obj/structure/sign/departments/Storage
	desc = "Storage"
	name = "Storage"
	icon_state = "Storage"

/obj/structure/sign/departments/old/AI
	desc = "AI"
	name = "AI"
	icon_state = "AI_old"

/obj/structure/sign/departments/old/kitchen
	desc = "Kitchen"
	name = "Kitchen"
	icon_state = "kitchen_old"

/obj/structure/sign/departments/old/bar
	desc = "Bar"
	name = "Bar"
	icon_state = "bar_old"

/obj/structure/sign/departments/old/medbay
	desc = "Medbay"
	name = "Medbay"
	icon_state = "medbay_old"

/obj/structure/sign/departments/hydroponics
	desc = "Hydroponics"
	name = "Hydroponics"
	icon_state = "hydroponics"

/obj/structure/sign/departments/old/engineering
	desc = "Engineering"
	name = "Engineering"
	icon_state = "engineering_old"

/obj/structure/sign/departments/old/bridge
	desc = "Bridge"
	name = "Bridge"
	icon_state = "bridge_old"

/obj/structure/sign/departments/brig
	desc = "Brig"
	name = "Brig"
	icon_state = "brig"

/obj/structure/sign/departments/old/atmos
	desc = "Atmospherics"
	name = "Atmospherics"
	icon_state = "atmos_old"

/obj/structure/sign/departments/crew
	desc = "Dormitory"
	name = "Dormitory"
	icon_state = "crew"
/obj/structure/sign/departments/old/tele
	desc = "Teleporter"
	name = "Teleporter"
	icon_state = "Teleporter_old"

/obj/structure/sign/departments/qm
	desc = "Quatermaster"
	name = "Quatermaster"
	icon_state = "Quatermaster"

/obj/structure/sign/departments/old/gas
	desc = "Gas Storage"
	name = "Gas Storage"
	icon_state = "Gas Storage_old"

/obj/structure/sign/departments/chemist
	name = "Chemist"
	desc = "Chemist"
	icon_state = "Chemist"

/obj/structure/sign/departments/morgue
	name = "Morgue"
	desc = "DEAD NIGGERS STORAGE"
	icon_state = "Morgue"

/obj/structure/sign/departments/emt
	name = "E.M.T"
	desc = "E.M.T"
	icon_state = "EMT"

/obj/structure/sign/departments/genetics
	name = "Genetics"
	desc = "Genetics"
	icon_state = "genetics"

/obj/structure/sign/departments/virology
	name = "Virology"
	desc = "Virology"
	icon_state = "virology"

/obj/structure/sign/departments/cryo
	name = "Cryogenics"
	desc = "Cryogenics"
	icon_state = "Cryogenics"

/obj/structure/sign/departments/chiefengineer
	name = "Chief Engineer"
	desc = "Chef Engineer's office"
	icon_state = "chief"

/obj/structure/sign/departments/old/virology
	name = "Virology"
	desc = "Virology Lab"
	icon_state = "Virology_old"

/obj/structure/sign/departments/old/bank
	name = "Bank"
	desc = "Bank"
	icon_state = "Bank_old"

/obj/structure/sign/departments/old/brig
	name = "Brig"
	desc = "Brig"
	icon_state = "Brig_old"

/obj/structure/sign/departments/old/chemist
	name = "Chemist"
	desc = "Chem. Lab"
	icon_state = "Chemist_old"

/obj/structure/sign/departments/old/dorm
	name = "Dormitories"
	desc = "Dormitories"
	icon_state = "Crew_old"

/obj/structure/sign/departments/old/cryo
	name = "Cryogenics"
	desc = "Cryogenics"
	icon_state = "Cryogenics_old"

/obj/structure/sign/departments/old/robotics
	name = "Mech Bay"
	desc = "Mech Bay"
	icon_state = "Robotics_old"

/obj/structure/sign/departments/old/store
	name = "Store"
	desc = "Store"
	icon_state = "Storage_old"

/obj/structure/sign/departments/cargo
	name = "Cargobay"
	desc = "Cargobay"
	icon_state = "Cargobay"

/obj/structure/sign/departments/bank
	name = "Bank"
	desc = "Bank"
	icon_state = "Bank"

/obj/structure/sign/departments/emergency
	name = "E.R"
	desc = "Emergency Response"
	icon_state = "emergency"

/obj/structure/sign/pipemarker/no2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrous oxide pipeline"
	icon_state = "pipemark_no2"

/obj/structure/sign/pipemarker/o2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "oxygen pipeline"
	icon_state = "pipemark_o2"

/obj/structure/sign/pipemarker/co2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "carbon dioxide pipeline"
	icon_state = "pipemark_co2"

/obj/structure/sign/pipemarker/pl
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "plasma pipeline"
	icon_state = "pipemark_pl"

/obj/structure/sign/pipemarker/air
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "mixed-air pipeline"
	icon_state = "pipemark_air"

/obj/structure/sign/pipemarker/n2
	desc = "A small marker that indicates the preferred content of a pipe line"
	name = "nitrogen pipeline"
	icon_state = "pipemark_n2"

/*####################TG SIGNS####################*/

/obj/structure/sign/directions/science
	name = "science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/evac
	name = "escape arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

/*####################GEMINI SIGNS####################*/

/obj/structure/sign/minerscape
	name = "escape arrow"
	desc = "The marker of direction to escape shuttle"
	icon_state = "whitescape"

/obj/structure/sign/minerscape/red
	color = "red"

/obj/structure/sign/minerscape/green
	color = "green"

/obj/structure/sign/minerscape/yellow
	color = "yellow"

/obj/structure/sign/minerscape/blue
	color = "blue"

/obj/structure/sign/minerscape/cyan
	color = "cyan"