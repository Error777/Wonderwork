//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

var/global/list/special_roles = list( //keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
	"traitor" = IS_MODE_COMPILED("traitor"),             // 0
	"operative" = IS_MODE_COMPILED("nuclear"),           // 1
	"changeling" = IS_MODE_COMPILED("changeling"),       // 2
	"wizard" = IS_MODE_COMPILED("wizard"),               // 3
	"malf AI" = IS_MODE_COMPILED("malfunction"),         // 4
	"revolutionary" = IS_MODE_COMPILED("revolution"),    // 5
	"alien candidate" = 1, //always show                 // 6
	"pAI candidate" = 1, // -- TLE                       // 7
	"cultist" = IS_MODE_COMPILED("cult"),                // 8
	"infested monkey" = IS_MODE_COMPILED("monkey"),      // 9
	"ninja" = "true",									 // 10
	"meme" = IS_MODE_COMPILED("meme"),			// 11
	"vox raider" = IS_MODE_COMPILED("heist"),			 // 11
	"diona" = 1,                                         // 12
)

var/const/MAX_SAVE_SLOTS = 5

//used for alternate_option
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/ckey							//not saved
	var/warns = 0
	var/muted = 0
	var/last_ip							//not saved currently
	var/last_id							//not saved currently
	var/list/jobbans = list()			//not saved - simply fetched from banning system on New()
	var/points = 0
	var/date_first_joined

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#b82e00"
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/toggles = TOGGLES_DEFAULT

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/b_type = "A+"					//blood type (not-chooseable)
	var/underwear = 1					//underwear type
	var/backbag = 2						//backpack type
	var/h_style = "Short Hair"			//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = "Human"
	var/language = "None"				//Secondary language

	//pai/clown/ai character preferences - part of game preferences
	var/pai_name
	var/pai_description
	var/clown_name
	var/ai_name

		//Mob preview
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

	var/job_civilian_1 = 0
	var/job_civilian_2 = 0
	var/job_civilian_3 = 0
	var/job_civilian_4 = 0
	var/job_civilian_5 = 0

	var/job_engsec_1 = 0
	var/job_engsec_2 = 0
	var/job_engsec_3 = 0
	var/job_engsec_4 = 0
	var/job_engsec_5 = 0

	var/job_medsci_1 = 0
	var/job_medsci_2 = 0
	var/job_medsci_3 = 0
	var/job_medsci_4 = 0
	var/job_medsci_5 = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/disabilities = 0

	var/nanotrasen_relation = "Neutral"

		// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

/datum/preferences/New(client/C)
	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
	date_first_joined = world.realtime

	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)

			//cache jobbans here - will be much faster than accessing badly designed jobban database directly
			for(var/role in special_roles)
				if(jobban_isbanned(C.mob, role))
					jobbans += role
			for(var/datum/job/job in job_master.occupations)
				if(jobban_isbanned(C.mob, job.title))
					jobbans += job.title

			if(load_preferences())
				if(load_character())
					return
/*
	if(istype(C))
		ckey = C.ckey
		if(!IsGuestKey(C.key))
			path = load_path()

			//cache jobbans here - will be much faster than accessing badly designed jobban database directly
			for(var/role in special_roles)
				if(jobban_isbanned(C.mob, role))
					jobbans += role
			for(var/datum/job/job in job_master.occupations)
				if(jobban_isbanned(C.mob, job.title))
					jobbans += job.title

			if(load_preferences())
				if(load_character())
					//successfully loaded a compatible savefile (or an old one was updated successfully)
					return
*/
	//if we failed to successfully load a character (or any preferences at all) we do this:
	gender = pick(MALE, FEMALE)
	randomize_appearance_for()
	//this should only really ever happen for guests

/datum/preferences

	proc/ShowChoices(client/C)
		if(!C)	return

		var/dat = "<html><head><link rel='stylesheet' type='text/css' href='preferences.css'></head><body>"


		//top-bar
		dat += "<div id='slots' class='panel'>"
		if(path)
			var/savefile/S = new /savefile(path,1)
			if(S)
				var/name
				for(var/i=1, i<=MAX_SAVE_SLOTS, ++i)
					S.cd = "/character[i]"
					S["real_name"] >> name
					if(!name)	name = "Character[i]"
					dat += "<a[(i==default_slot) ? " style='font-weight:bold'" : ""] href='?_src_=prefs;preference=changeslot;num=[i]'>[name]</a>"
		else
			dat += "Please create a byond account to save your preferences."
		dat += "</div>"


			//left (general-preferences)
		dat += "<div id='general' class='panel'>"
		dat += "<p class='header'><a href='#'>General Preferences<span>Options which will affect all of your characters</span></a></p>"
		dat += "<p><span class='leftcol'>Reward Points:</span><a href='#'>[points]<span>Reward points you have earned, these points may be spent on special rewards</span></a></p>"
		dat += "<p><span class='leftcol'>UI Style:</span><a href='?_src_=prefs;preference=ui'>[UI_style]<span>Which icon-set will be used for your in-game HUD</span></a></p>"
		dat += "<p><span class='leftcol'>Admin Midis:</span><a href='?_src_=prefs;preference=hear_midis'>[(toggles & SOUND_MIDI) ? "On" : "Off"]<span>Whether you will hear uploaded sound files from other clients</span></a></p>"
		dat += "<p><span class='leftcol'>Lobby Music:</span><a href='?_src_=prefs;preference=lobby_music'>[(toggles & SOUND_LOBBY) ? "On" : "Off"]<span>Whether you will hear music in the pregame-lobby</span></a></p>"
		dat += "<p><span class='leftcol'>Ambience:</span><a href='?_src_=prefs;preference=ambience'>[(toggles & SOUND_AMBIENCE) ? "On" : "Off"]<span>Whether you will hear ambient sound-effects/music</span></a></p>"
		dat += "<p><span class='leftcol'>Ghost Ears:</span><a href='?_src_=prefs;preference=ghost_ears'>[(toggles & CHAT_GHOSTEARS) ? "Nearest Creatures" : "All Speech"]<span>Whether, as an observer, you will hear all speech or only speech happening near you</span></a></p>"
		dat += "<p><span class='leftcol'>Ghost Sight:</span><a href='?_src_=prefs;preference=ghost_sight'>[(toggles & CHAT_GHOSTSIGHT) ? "Nearest Creatures" : "All Emotes"]<span>Whether, as an observer, you will see all emotes or only those happening near you</span></a></p>"
		dat += "<p><span class='leftcol'>OOC:</span><a href='?_src_=prefs;preference=ooc'>[(toggles & CHAT_OOC) ? "On" : "Off"]<span>Whether you will see OOC chat.</span></a></p>"

		dat += "<hr>"

		dat += "<p class='header'><a href='#'>Limbs and Glasses<span>These options are responsible for your shortcomings</span></a></p>"
		dat += "<p><span class='leftcol'>Needs Glasses:</span><a href='?_src_=prefs;preference=disabilities'><b>[disabilities == 0 ? "No" : "Yes"]<span>Blah-blah-blah</span></a></p>"
		dat += "<p><span class='leftcol'>Limbs:</span><a href='?_src_=prefs;preference=limbs;task=input'>~<span>Blah-blah-blah</span></a></p>"

		//display limbs below
		var/ind = 0
		for(var/name in organ_data)
			//world << "[ind] \ [organ_data.len]"
			var/status = organ_data[name]
			var/organ_name = null
			switch(name)
				if("l_arm")
					organ_name = "left arm"
				if("r_arm")
					organ_name = "right arm"
				if("l_leg")
					organ_name = "left leg"
				if("r_leg")
					organ_name = "right leg"
				if("l_foot")
					organ_name = "left foot"
				if("r_foot")
					organ_name = "right foot"
				if("l_hand")
					organ_name = "left hand"
				if("r_hand")
					organ_name = "right hand"

			if(status == "cyborg")
				++ind
				if(ind > 1)
					dat += ", "
				dat += "\tMechanical [organ_name] prothesis"
			else if(status == "amputated")
				++ind
				if(ind > 1)
					dat += ", "
				dat += "\tAmputated [organ_name]"
		if(!ind)
			dat += "\[...\]<p></p><p></p>"
		else
			dat += "<p></p><p></p>"

		dat += "<p></p>"

		dat += "</div>"

			//job-preferences
		dat += "<div id='jobs' class='panel'>"
		dat += "<p class='header'><a href='#' >Job Preferences<span>These detail which jobs this character may be selected for. Priorities range from N=never to 1=most-likely. It is wise to enter several jobs as there are a limited number of positions for each. These settings apply only to the current character.</span></a></p>"
		dat += jobtable()

		dat += "<hr>"

			//special roles
		dat += "<p class='header'><a href='#'>Special Role Candidacy<span>These options dictate whether you will be chosen for special roles and events. They apply to all of your characters.</span></a></p>"
		dat += "<table><tr><td>"
		var/n = 0
		for(var/i in special_roles)
			dat += "<p><span class='leftcol'>[i]:</span>"
			if(isJobbanned(i))
				dat += "<a color='red'>Jobbanned<span>You have been jobbanned from this role. You can either wait for it to expire or prove to an admin you have learned from your mistakes.</span></a>"
			else if(special_roles[i])
				dat += "<a href='?_src_=prefs;preference=be_special;num=[n]'>[be_special&(1<<n) ? "Yes" : "No"]</a>"
			else
				dat += "<a color='grey'>Not available</a>"
			dat += "</p>"
			++n
			if(n == 5)
				dat += "</td><td>"
		dat += "</td></tr></table>"

		dat += "</div>"

			//character-preferences
		dat += "<div id='character' class='panel'>"

		dat += "<p class='header'><a href='#'>Human Character Preferences<span>These settings affect only the currently selected character</span></a></p>"
		dat += "<p class='header'><img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64><a href='?_src_=prefs;preference=all;task=random'>~<span>Completely randomise your character's body.</span></a></p>"
		dat += "<p><span class='leftcol'>Name:</span><a href='?_src_=prefs;preference=name;task=input'>[real_name ? real_name : "*random*"]<span>Your character's name. This should contain only letters and common punctuation such as space, hyphen and apostrophes. Enter an empty name in order to randomise your name each round.</span></a><a href='?_src_=prefs;preference=name;task=random'>~<span>Pick a random name</span></a></p>"
		dat += "<p><span class='leftcol'>Gender:</span><a href='?_src_=prefs;preference=gender'>[(gender == MALE) ? "Male" : "Female"]<span>The gender of your character. This will affect customisations available to your character</span></a><a href='?_src_=prefs;preference=gender;task=random'>~<span>Pick a random gender.</span></a></p>"
		dat += "<p><span class='leftcol'>Age:</span><a href='?_src_=prefs;preference=age;task=input'>[age]<span>The age of your character</span></a><a href='?_src_=prefs;preference=age;task=random'>~<span>Pick a random age</span></a></p>"
		dat += "<p><span class='leftcol'>Blood Type:</span><a href='#'>[b_type]<span>Your character's blood-type. You cannot change this value</span></a></p>"
		dat += "<p><span class='leftcol'>Skin Tone:</span><a href='?_src_=prefs;preference=s_tone;task=input'>[-s_tone + 35]/220<span>The color of your character's skin</span></a><a href='?_src_=prefs;preference=s_tone;task=random'>~<span>Pick a random skin-tone.</span></a></p>"
		dat += "<p><span class='leftcol'>Underwear:</span><a href='?_src_=prefs;preference=underwear;task=input'>[(gender == MALE) ? underwear_m[underwear] : underwear_f[underwear]]<span>The underwear worn by your character</span></a><a href='?_src_=prefs;preference=underwear;task=random'>~<span>Pick random underwear</span></a></p>"
		dat += "<p><span class='leftcol'>Backpack:</span><a href='?_src_=prefs;preference=bag;task=input'>[backbaglist[backbag]]<span>The type of bag your character spawns with</span></a><a href='?_src_=prefs;preference=bag;task=random'>~<span>Pick a random bag</span></a></p>"
		dat += "<p><span class='leftcol'>Hair:</span><a href='?_src_=prefs;preference=hair;task=input'><font class='color' style='background-color:rgb([r_hair],[g_hair],[b_hair])'>&nbsp;</font><span>Your character's hair color</span></a><a href='?_src_=prefs;preference=hair;task=random'>~<span>pick a random hair color.</span></a><a href='?_src_=prefs;preference=h_style;task=input'>[h_style]<span>Your character's style of hair</span></a><a href='?_src_=prefs;preference=h_style;task=random'>~<span>pick a random hair style.</span></a></p>"
		dat += "<p><span class='leftcol'>Facial Hair:</span><a href='?_src_=prefs;preference=facial;task=input'><font class='color' style='background-color:rgb([r_facial],[g_facial],[b_facial])'>&nbsp;</font><span>The color of your character's facial hair</span></a><a href='?_src_=prefs;preference=facial;task=random'>~<span>pick a random facial hair color.</span></a><a href='?_src_=prefs;preference=f_style;task=input'>[f_style]<span>The style of your character's facial hair</span></a><a href='?_src_=prefs;preference=f_style;task=random'>~<span>pick a random facial hair style.</span></a></p>"
		dat += "<p><span class='leftcol'>Eye Color:</span><a href='?_src_=prefs;preference=eyes;task=input'><font class='color' style='background-color:rgb([r_eyes],[g_eyes],[b_eyes])'>&nbsp;</font><span>The color of your character's eyes</span></a><a href='?_src_=prefs;preference=eyes;task=random'>~<span>pick a random eye color.</span></a></p>"
		dat += "<p><span class='leftcol'>Nanotrasen Relation:</span><a href ='?_src_=prefs;preference=nt_relation;task=input'>[nanotrasen_relation]<span>Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.</span></a></p>"
		dat += "<p><span class='leftcol'>Flavor Text:</span><a href='?_src_=prefs;preference=flavor_text;task=input'>~<span>Set the flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!</span></a></p>"
		if(jobban_isbanned(C, "Records"))
			dat += "<p><span class='leftcol'>You are banned from using character records.</span></p>"
		else
			dat += "<p><span class='leftcol'>Character Records:</span><a href='?_src_=prefs;preference=records;record=1\'>~<span>Ðÿÿÿÿÿ...</span></a></p>"


		dat += "<hr>"

			//special-character preferences
		dat += "<p class='header'><a href='#'>AI/pAI/Clown Preferences<span>These options will affect all of your characters and are only applied when you recieve one of these particular roles</span></a></p>"
		dat += "<p><span class='leftcol'>AI Name:</span><a href='?_src_=prefs;task=input;preference=ai_name'>[ai_name ? ai_name : "*random*"]<span>This is the name that will be given to any AI character you play.</span></a></p>"
		dat += "<p><span class='leftcol'>pAI Name:</span><a href='?_src_=prefs;task=input;preference=pai_name'>[pai_name ? pai_name : "*random*"]<span>This is the name that will be given to your pAI character, should you be selected for such a role. You will only become a pAI if you are not currently playing in a round (i.e. you're observing/ghosted)</span></a></p>"
		dat += "<p><span class='leftcol'>pAI Desc.:</span><a href='?_src_=prefs;task=input;preference=pai_description'>[pai_description ? "*click to read*" : "*none*"]<span>This is a brief IC description of your pAI personality, so that you can help attract people to choosing you over the other candidates.</span></a></p>"
		dat += "<p><span class='leftcol'>Clown Name:</span><a href='?_src_=prefs;task=input;preference=clown_name'>[clown_name ? clown_name : "*random*"]<span>This is the 'stage-name' that will be given to your character if you recieve the clown job. It replaces your regular human name.</span></a></p>"

		dat += "</div>"


		//bottom (save/load/reset)
		dat += "<div id='special' class='panel'>"
		if(!IsGuestKey(C.key))
			dat += "<a href='?_src_=prefs;preference=load'>Reload All</a>"
			dat += "<a href='?_src_=prefs;preference=character;task=reset'>Reload Character</a>"
			dat += "<a href='?_src_=prefs;preference=save'>Save All</a>"
		dat += "<a href='?_src_=prefs;preference=job;task=reset'>Reset Jobs</a>"
		dat += "<a href='?_src_=prefs;preference=general;task=reset'>Reset General Preferences</a>"
		dat += "</div>"


		dat += "</body></html>"

		if(!preview_icon_front || !preview_icon_side)
			update_preview_icon()

		C << browse_rsc(preview_icon_front, "previewicon.png")
		C << browse_rsc(preview_icon_side, "previewicon2.png")
		C << browse(dat, "window=preferences;size=1000x720")

	proc/jobtable(limit=17)
		var/index = -1

		var/dat = "<table style='width:100%'><tr><td>"
		var/colgroup = "<colgroup><col style='width:40%;text-align:center'><col style='width:60%'></colgroup>"
		//The job before the current job. I only use this to get the previous jobs color when I'm filling in blank rows.

		if(job_master)
			dat += "<table>[colgroup]" // Table within a table for alignment, also allows you to easily add more colomns.

			for(var/datum/job/job in job_master.occupations)
				if(++index >= limit)
					dat += "</table></td><td><table>[colgroup]"
					index = 0

				dat += "<tr style='background-color:[job.selection_color]'><td>"
				var/rank = job.title

				if(isJobbanned(rank))
					dat += "<font color=red>[rank]</font></td><td><font color=red><b> \[BANNED]</b></font></td></tr>"
					continue

				var/timeToWait = job.available_in_days(src)
				if(timeToWait)
					dat += "<font color=red>[rank]</font></td><td><font color=red> \[IN [(timeToWait)] DAYS]</font></td></tr>"
					continue

				if((job_civilian_5 & ASSISTANT) && (rank != "Assistant"))
					dat += "<font color=orange>[rank]</font></td><td></td></tr>"
					continue

				if((rank in command_positions) || (rank == "AI"))//Bold head jobs
					dat += "<b>[rank]</b>"
				else
					dat += "[rank]"

				dat += "</td><td>"

				if(rank == "Assistant")//Assistant is special
					if(job_civilian_5 & ASSISTANT)
						dat += " <a href='?_src_=prefs;preference=job;task=input;text=[rank];level=6'><font color=green>\[Yes\]</font>"
					else
						dat += " <a href='?_src_=prefs;preference=job;task=input;text=[rank];level=5'><font color=red>\[No\]</font>"
					dat += "</a></td></tr>"
					continue
				if(GetJobDepartment(job, 6) & job.flag)
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=6'>N</a>:"
				else
					dat += "<font color=red>\[N\]</font>:"
				if(GetJobDepartment(job, 5) & job.flag)
					dat += "<font color=green>\[5\]</font>:"
				else
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=5'>5</a>:"
				if(GetJobDepartment(job, 4) & job.flag)
					dat += "<font color=green>\[4\]</font>:"
				else
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=4'>4</a>:"
				if(GetJobDepartment(job, 3) & job.flag)
					dat += "<font color=green>\[3\]</font>:"
				else
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=3'>3</a>:"
				if(GetJobDepartment(job, 2) & job.flag)
					dat += "<font color=green>\[2\]</font>:"
				else
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=2'>2</a>:"
				if(GetJobDepartment(job, 1) & job.flag)
					dat += "<font color=green>\[1\]</font>"
				else
					dat += "<a href='?_src_=prefs;preference=job;task=input;text=[rank];level=1'>1</a>"
				if(job.alt_titles)
					dat += "<a href='?_src_=prefs;preference=job;task=alt_title;job=\ref[job]\'>\[[GetPlayerAltTitle(job)]\]</a>"
				dat += "</td></tr>"

			dat += "</table>"
		dat += "</td></tr></table>"



		return dat

	proc/SetDisabilities(mob/user)
		var/HTML = "<body>"
		HTML += "<tt><center>"
		HTML += "<b>Choose disabilities</b><br>"

		HTML += "Need Glasses? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=0\">[disabilities & (1<<0) ? "Yes" : "No"]</a><br>"
		HTML += "Seizures? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=1\">[disabilities & (1<<1) ? "Yes" : "No"]</a><br>"
		HTML += "Coughing? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=2\">[disabilities & (1<<2) ? "Yes" : "No"]</a><br>"
		HTML += "Tourettes/Twitching? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=3\">[disabilities & (1<<3) ? "Yes" : "No"]</a><br>"
		HTML += "Nervousness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=4\">[disabilities & (1<<4) ? "Yes" : "No"]</a><br>"
		HTML += "Deafness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=5\">[disabilities & (1<<5) ? "Yes" : "No"]</a><br>"

		HTML += "<br>"
		HTML += "<a href=\"byond://?src=\ref[user];preferences=1;disabilities=-2\">\[Done\]</a>"
		HTML += "</center></tt>"

		user << browse(null, "window=preferences")
		user << browse(HTML, "window=disabil;size=350x300")
		return

	proc/SetRecords(mob/user)
		var/HTML = "<body>"
		HTML += "<tt><center>"
		HTML += "<b>Set Character Records</b><br>"

		HTML += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">Medical Records</a><br>"

		if(lentext(med_record) <= 40)
			HTML += "[med_record]"
		else
			HTML += "[copytext(med_record, 1, 37)]..."

		HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">Employment Records</a><br>"

		if(lentext(gen_record) <= 40)
			HTML += "[gen_record]"
		else
			HTML += "[copytext(gen_record, 1, 37)]..."

		HTML += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">Security Records</a><br>"

		if(lentext(sec_record) <= 40)
			HTML += "[sec_record]<br>"
		else
			HTML += "[copytext(sec_record, 1, 37)]...<br>"

		HTML += "<br>"
		HTML += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">\[Done\]</a>"
		HTML += "</center></tt>"

		user << browse(null, "window=preferences")
		user << browse(HTML, "window=records;size=350x300")
		return

	proc/GetPlayerAltTitle(datum/job/job)
		return player_alt_titles.Find(job.title) > 0 \
			? player_alt_titles[job.title] \
			: job.title

	proc/SetPlayerAltTitle(datum/job/job, new_title)
		// remove existing entry
		if(player_alt_titles.Find(job.title))
			player_alt_titles -= job.title
		// add one if it's not default
		if(job.title != new_title)
			player_alt_titles[job.title] = new_title

	proc/SetJob(role, level)
		SetJobDepartment(job_master.GetJob(role), level)
		return 1


	proc/ResetJobs()
		update_preview_icon(1)	//setting a job from 1 to 3 etc. would change the clothing of the preview

		job_civilian_1 = 0
		job_civilian_2 = 0
		job_civilian_3 = 0
		job_civilian_4 = 0
		job_civilian_5 = 0

		job_engsec_1 = 0
		job_engsec_2 = 0
		job_engsec_3 = 0
		job_engsec_4 = 0
		job_engsec_5 = 0

		job_medsci_1 = 0
		job_medsci_2 = 0
		job_medsci_3 = 0
		job_medsci_4 = 0
		job_medsci_5 = 0
		return 1


	proc/GetJobDepartment(var/datum/job/job, var/level)
		if(!job || !level)	return 0
		switch(job.department_flag)
			if(CIVILIAN)
				switch(level)
					if(1)
						return job_civilian_1
					if(2)
						return job_civilian_2
					if(3)
						return job_civilian_3
					if(4)
						return job_civilian_4
					if(5)
						return job_civilian_5
					if(6)
						return job_civilian_1 + job_civilian_2 + job_civilian_3 + job_civilian_4 + job_civilian_5
			if(MEDSCI)
				switch(level)
					if(1)
						return job_medsci_1
					if(2)
						return job_medsci_2
					if(3)
						return job_medsci_3
					if(4)
						return job_medsci_4
					if(5)
						return job_medsci_5
					if(6)
						return job_medsci_1 + job_medsci_2 + job_medsci_3 + job_medsci_4 + job_medsci_5
			if(ENGSEC)
				switch(level)
					if(1)
						return job_engsec_1
					if(2)
						return job_engsec_2
					if(3)
						return job_engsec_3
					if(4)
						return job_engsec_4
					if(5)
						return job_engsec_5
					if(6)
						return job_engsec_1 + job_engsec_2 + job_engsec_3 + job_engsec_4 + job_engsec_5

		return 0


	proc/SetJobDepartment(var/datum/job/job, var/level)
		if(!job || !level)	return 0
		if(level == 1)//Changing something to level 1 so clear any existing level 1s by placing it in level 2
			job_civilian_2 |= job_civilian_1
			job_medsci_2 |= job_medsci_1
			job_engsec_2 |= job_engsec_1
			job_civilian_1 = 0
			job_medsci_1 = 0
			job_engsec_1 = 0

		switch(job.department_flag)
			if(CIVILIAN)//First clear the job out of any existing levels
				job_civilian_1 &= ~job.flag
				job_civilian_2 &= ~job.flag
				job_civilian_3 &= ~job.flag
				job_civilian_4 &= ~job.flag
				job_civilian_5 &= ~job.flag
				switch(level)//Then add it to the level it should be in
					if(1)
						job_civilian_1 |= job.flag
					if(2)
						job_civilian_2 |= job.flag
					if(3)
						job_civilian_3 |= job.flag
					if(4)
						job_civilian_4 |= job.flag
					if(5)
						job_civilian_5 |= job.flag
						//no 6 needed because 6 means never and we dont store things set to never
			if(MEDSCI)
				job_medsci_1 &= ~job.flag
				job_medsci_2 &= ~job.flag
				job_medsci_3 &= ~job.flag
				job_medsci_4 &= ~job.flag
				job_medsci_5 &= ~job.flag
				switch(level)
					if(1)
						job_medsci_1 |= job.flag
					if(2)
						job_medsci_2 |= job.flag
					if(3)
						job_medsci_3 |= job.flag
					if(4)
						job_medsci_4 |= job.flag
					if(5)
						job_medsci_5 |= job.flag
			if(ENGSEC)
				job_engsec_1 &= ~job.flag
				job_engsec_2 &= ~job.flag
				job_engsec_3 &= ~job.flag
				job_engsec_4 &= ~job.flag
				job_engsec_5 &= ~job.flag
				switch(level)
					if(1)
						job_engsec_1 |= job.flag
					if(2)
						job_engsec_2 |= job.flag
					if(3)
						job_engsec_3 |= job.flag
					if(4)
						job_engsec_4 |= job.flag
					if(5)
						job_engsec_5 |= job.flag
		return 1


	proc/process_link(mob/user, list/href_list)
		if(!user)	return

		if(!istype(user, /mob/new_player))	return
		if(href_list["preference"] == "records")
			if(text2num(href_list["record"]) >= 1)
				SetRecords(user)
				return
			else
				user << browse(null, "window=records")
			if(href_list["task"] == "med_record")
				var/medmsg = input(usr,"Set your medical notes here.","Medical Records",html_decode(med_record)) as message

				if(medmsg != null)
					medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
					medmsg = html_encode(medmsg)

					med_record = medmsg
					SetRecords(user)

			if(href_list["task"] == "sec_record")
				var/secmsg = input(usr,"Set your security notes here.","Security Records",html_decode(sec_record)) as message

				if(secmsg != null)
					secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
					secmsg = html_encode(secmsg)

					sec_record = secmsg
					SetRecords(user)
			if(href_list["task"] == "gen_record")
				var/genmsg = input(usr,"Set your employment notes here.","Employment Records",html_decode(gen_record)) as message

				if(genmsg != null)
					genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
					genmsg = html_encode(genmsg)

					gen_record = genmsg
					SetRecords(user)

		switch(href_list["task"])
			if("reset")
				switch(href_list["preference"])
					if("job")
						ResetJobs()
					if("character")
						load_character()
					if("general")
						ooccolor = initial(ooccolor)
						be_special = initial(be_special)
						UI_style = initial(UI_style)
						toggles = initial(toggles)
			if("random")
				switch(href_list["preference"])
					if("name")
						real_name = random_name(gender)
					if("age")
						age = rand(AGE_MIN, AGE_MAX)
					if("hair")
						r_hair = rand(0,255)
						g_hair = rand(0,255)
						b_hair = rand(0,255)
						update_preview_icon(1)
					if("h_style")
						h_style = random_hair_style(gender)
						update_preview_icon(1)
					if("facial")
						r_facial = rand(0,255)
						g_facial = rand(0,255)
						b_facial = rand(0,255)
						update_preview_icon(1)
					if("f_style")
						f_style = random_facial_hair_style(gender)
						update_preview_icon(1)
					if("underwear")
						underwear = rand(1,underwear_m.len)
						update_preview_icon(1)
					if("eyes")
						r_eyes = rand(0,255)
						g_eyes = rand(0,255)
						b_eyes = rand(0,255)
						update_preview_icon(1)
					if("s_tone")
						s_tone = random_skin_tone()
						update_preview_icon(1)
					if("bag")
						backbag = rand(1,3)
						update_preview_icon(1)
					if("gender")
						gender = pick(MALE,FEMALE)
						update_preview_icon(1)
					if("all")
						randomize_appearance_for()	//no params needed
						update_preview_icon(1)
			if ("alt_title")
				var/datum/job/job = locate(href_list["job"])
				if (job)
					var/choices = list(job.title) + job.alt_titles
					var/choice = input("Pick a title for [job.title].", "Character Generation", GetPlayerAltTitle(job)) as anything in choices | null
					if(choice)
						SetPlayerAltTitle(job, choice)
						//SetChoices(user)
			if("input")
				switch(href_list["preference"])
					if("job")
						SetJob(href_list["text"], text2num(href_list["level"]))
						update_preview_icon(1)
					if("clown_name")
						var/new_name = reject_bad_name( input(user, "Choose your honktastic clown stage name:\n(leave empty for always random names)", "Clown Preference") as text|null)
						if(new_name != null)
							clown_name = new_name
						else
							user << "<font color='red'>Invalid name. Your clown name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may contain letters. Some symbols are forbidden.</font>"

					if("ai_name")
						var/new_name = reject_bad_name( input(user, "Choose a name for your AI personality:\n(leave empty for always random names)", "AI Preference") as text|null, 1 )
						if(new_name != null)
							ai_name = new_name
						else
							user << "<font color='red'>Invalid name. Your AI name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may contain letters and numbers. Some symbols are forbidden.</font>"

					if("pai_name")
						var/new_name = reject_bad_name( input(user, "Choose a name for your pAI personality:\n(leave empty for always random names)", "pAI Preference") as text|null, 1 )
						if(new_name != null)
							pai_name = new_name
						else
							user << "<font color='red'>Invalid name. Your pAI name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may contain letters and numbers. Some symbols are forbidden.</font>"

					if("pai_description")
						pai_description = reject_bad_text( input(user, "Describe your pAI personality:", "pAI Preference", pai_description) as text|null )

					if("name")
						var/new_name = reject_bad_name( input(user, "Choose your character's name:", "Character Preference")  as text|null )
						if(new_name != null)
							real_name = new_name
						else
							user << "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>"

					if("age")
						var/new_age = input(user, "Choose your character's age:\n([AGE_MIN]-[AGE_MAX])", "Character Preference") as num|null
						if(new_age)
							age = max(min( round(text2num(new_age)), AGE_MAX),AGE_MIN)

					if("hair")
						var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as color|null
						if(new_hair)
							r_hair = hex2num(copytext(new_hair, 2, 4))
							g_hair = hex2num(copytext(new_hair, 4, 6))
							b_hair = hex2num(copytext(new_hair, 6, 8))
							update_preview_icon(1)

					if("h_style")
						var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference")  as null|anything in hair_styles_list
						if(new_h_style)
							h_style = new_h_style
							update_preview_icon(1)

					if("facial")
						var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as color|null
						if(new_facial)
							r_facial = hex2num(copytext(new_facial, 2, 4))
							g_facial = hex2num(copytext(new_facial, 4, 6))
							b_facial = hex2num(copytext(new_facial, 6, 8))
							update_preview_icon(1)

					if("f_style")
						var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference")  as null|anything in facial_hair_styles_list
						if(new_f_style)
							f_style = new_f_style
							update_preview_icon(1)

					if("underwear")
						var/list/underwear_options
						if(gender == MALE)
							underwear_options = underwear_m
						else
							underwear_options = underwear_f

						var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference")  as null|anything in underwear_options
						if(new_underwear)
							underwear = underwear_options.Find(new_underwear)
							update_preview_icon(1)

					if("eyes")
						var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color|null
						if(new_eyes)
							r_eyes = hex2num(copytext(new_eyes, 2, 4))
							g_eyes = hex2num(copytext(new_eyes, 4, 6))
							b_eyes = hex2num(copytext(new_eyes, 6, 8))
							update_preview_icon(1)

					if("s_tone")
						var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference")  as num|null
						if(new_s_tone)
							s_tone = 35 - max(min( round(new_s_tone), 220),1)
							update_preview_icon(1)

					if("ooccolor")
						var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color|null
						if(new_ooccolor)
							ooccolor = new_ooccolor

					if("bag")
						var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference")  as null|anything in backbaglist
						if(new_backbag)
							backbag = backbaglist.Find(new_backbag)
							update_preview_icon(1)

					if("nt_relation")
						var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference")  as null|anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
						if(new_relation)
							nanotrasen_relation = new_relation

					if("flavor_text")
						var/msg = sanitize_uni(input(usr,"Set the flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!","Flavor Text",html_decode(flavor_text)) as message)

						if(msg != null)
							msg = copytext(msg, 1, MAX_MESSAGE_LEN)
							msg = sanitize_uni(msg)

							flavor_text = msg

					if("disabilities")
						if(text2num(href_list["disabilities"]) >= -1)
							if(text2num(href_list["disabilities"]) >= 0)
								disabilities ^= (1<<text2num(href_list["disabilities"])) //MAGIC
							SetDisabilities(user)
							return
						else
							user << browse(null, "window=disabil")

					if("limbs")
						var/limb_name = input(user, "Which limb do you want to change?") as null|anything in list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand")
						if(!limb_name) return

						var/limb = null
						var/second_limb = null // if you try to change the arm, the hand should also change
						var/third_limb = null  // if you try to unchange the hand, the arm should also change
						switch(limb_name)
							if("Left Leg")
								limb = "l_leg"
								second_limb = "l_foot"
							if("Right Leg")
								limb = "r_leg"
								second_limb = "r_foot"
							if("Left Arm")
								limb = "l_arm"
								second_limb = "l_hand"
							if("Right Arm")
								limb = "r_arm"
								second_limb = "r_hand"
							if("Left Foot")
								limb = "l_foot"
								third_limb = "l_leg"
							if("Right Foot")
								limb = "r_foot"
								third_limb = "r_leg"
							if("Left Hand")
								limb = "l_hand"
								third_limb = "l_arm"
							if("Right Hand")
								limb = "r_hand"
								third_limb = "r_arm"

						var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in list("Normal","Amputated","Prothesis")
						if(!new_state) return

						switch(new_state)
							if("Normal")
								organ_data[limb] = null
								if(third_limb)
									organ_data[third_limb] = null
							if("Amputated")
								organ_data[limb] = "amputated"
								if(second_limb)
									organ_data[second_limb] = "amputated"
							if("Prothesis")
								organ_data[limb] = "cyborg"
								if(second_limb)
									organ_data[second_limb] = "cyborg"

			else
				switch(href_list["preference"])
					if("gender")
						if(gender == MALE)
							gender = FEMALE
						else
							gender = MALE
						update_preview_icon(1)

					if("hear_adminhelps")
						toggles ^= SOUND_ADMINHELP

					if("ui")
						switch(UI_style)
							if("Midnight")
								UI_style = "Orange"
							if("Orange")
								UI_style = "old"
							else
								UI_style = "Midnight"

					if("disabilities")				//please note: current code only allows nearsightedness as a disability
						disabilities = !disabilities//if you want to add actual disabilities, code that selects them should be here

					if("be_special")
						var/num = text2num(href_list["num"])
						be_special ^= (1<<num)

					if("radio")
						toggles ^= CHAT_RADIO

					if("deadchat")
						toggles ^= CHAT_DEAD

					if("prayers")
						toggles ^= CHAT_PRAYER

					if("hear_midis")
						toggles ^= SOUND_MIDI
						if(!(toggles & SOUND_MIDI))
							var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = 777)
							break_sound.priority = 250
							user << break_sound	//breaks the client's sound output on channel 777

					if("lobby_music")
						toggles ^= SOUND_LOBBY
						if(toggles & SOUND_LOBBY)
							user << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
						else
							user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)

					if("ambience")
						toggles ^= SOUND_AMBIENCE
						if(!(toggles & SOUND_AMBIENCE))
							user << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
							user << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)

					if("ooc")
						toggles ^= CHAT_OOC

					if("ghost_ears")
						toggles ^= CHAT_GHOSTEARS

					if("ghost_sight")
						toggles ^= CHAT_GHOSTSIGHT

					if("save")
						save_preferences()
						save_character()

					if("reload")
						load_preferences()
						load_character()

					if("open_load_dialog")
						if(!IsGuestKey(user.key))
							open_load_dialog(user)

					if("close_load_dialog")
						close_load_dialog(user)

					if("changeslot")
						load_character(text2num(href_list["num"]))
						close_load_dialog(user)

		ShowChoices(user.client)
		return 1

	proc/copy_to(mob/living/carbon/human/character, safety = 0)
		var/name = real_name ? real_name : random_name(gender)

		if(config.humans_need_surnames)
			var/firstspace = findtext(name, " ")
			var/name_length = length(name)
			if(!firstspace)	//we need a surname
				name += " [pick(last_names)]"
			else if(firstspace == name_length)
				name += "[pick(last_names)]"

		character.real_name = name
		character.name = name
		if(character.dna)
			character.dna.real_name = name

		character.gender = gender
		character.age = age
		character.b_type = b_type

		character.r_eyes = r_eyes
		character.g_eyes = g_eyes
		character.b_eyes = b_eyes

		character.r_hair = r_hair
		character.g_hair = g_hair
		character.b_hair = b_hair

		character.r_facial = r_facial
		character.g_facial = g_facial
		character.b_facial = b_facial

		character.s_tone = s_tone

		character.h_style = h_style
		character.f_style = f_style

		character.underwear = underwear
		character.backbag = backbag

	proc/open_load_dialog(mob/user)
		var/dat = "<body>"
		dat += "<tt><center>"

		var/savefile/S = new /savefile(path)
		if(S)
			dat += "<b>Select a character slot to load</b><hr>"
			var/name
			for(var/i=1, i<=MAX_SAVE_SLOTS, i++)
				S.cd = "/character[i]"
				S["real_name"] >> name
				if(!name)	name = "Character[i]"
				if(i==default_slot)
					name = "<b>[name]</b>"
				dat += "<a href='?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

		dat += "<hr>"
		dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>Close</a><br>"
		dat += "</center></tt>"
		user << browse(dat, "window=saves;size=300x390")

	proc/close_load_dialog(mob/user)
		user << browse(null, "window=saves")

/datum/preferences/proc/isJobbanned(role)
	if(role in jobbans)
		return 1
	return 0

proc/get_preferred_ai_name(ckey)
	if(ckey)
		var/datum/preferences/P = preferences_datums[ckey]
		if(P && P.ai_name)	return P.ai_name
	if(ai_names.len)		return pick_n_take(ai_names)
	return "AI v[rand(0,9)].[rand(0,1000)]"

proc/get_preferred_clown_name(ckey)
	if(ckey)
		var/datum/preferences/P = preferences_datums[ckey]
		if(P && P.clown_name)	return P.clown_name
	if(clown_names.len)			return pick_n_take(clown_names)
	return "Clown [rand(1,1000)]"

proc/get_preferred_pai_name(ckey)
	if(ckey)
		var/datum/preferences/P = preferences_datums[ckey]
		if(P && P.pai_name)	return P.pai_name
	if(ai_names.len)		return pick_n_take(ai_names)
	return "pAI [rand(1,1000)]"
