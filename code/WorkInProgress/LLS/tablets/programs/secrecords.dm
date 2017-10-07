/datum/program/secrecords
	name = "Security Records"
	app_id = "secrecords"
	var/mode = 1
	var/datum/data/record/active1 = null //General
	var/datum/data/record/active2 = null //Medical
	var/datum/data/record/active3 = null //Security

	use_app()
		if (mode==1) //security records
			dat = "<h4>Security Record List</h4>"
			if(data_core.general)
				for (var/datum/data/record/R in sortRecord(data_core.general))
					dat += "<a href='byond://?src=\ref[src];choice=Security Records;target=[R.fields["id"]]'>[R.fields["id"]]: [R.fields["name"]]</a><br>"

			dat += "<br>"
		if(mode==2)
			dat = {"<a href='byond://?src=\ref[src];choice=CloseRecord'>Close Record</a>"}
			dat += "<h4>Security Record</h4>"

			if ((istype(active1, /datum/data/record) && data_core.general.Find(active1)))
				dat += "Name: [active1.fields["name"]] ID: [active1.fields["id"]]<br>"
				dat += "Sex: [active1.fields["sex"]]<br>"
				dat += "Age: [active1.fields["age"]]<br>"
				dat += "Rank: [active1.fields["rank"]]<br>"
				dat += "Fingerprint: [active1.fields["fingerprint"]]<br>"
				dat += "Physical Status: [active1.fields["p_stat"]]<br>"
				dat += "Mental Status: [active1.fields["m_stat"]]<br>"
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"

			dat += "<h4>Security Data</h4>"
			if ((istype(active2, /datum/data/record) && data_core.security.Find(active2)))
				dat += "Criminal Status: [active2.fields["criminal"]]<br>"

				dat += "Minor Crimes: [active2.fields["mi_crim"]]<br>"
				dat += "Details: [active2.fields["mi_crim"]]<br><br>"
				dat += "Major Crimes: [active2.fields["ma_crim"]]<br>"
				dat += "Details: [active2.fields["ma_crim_d"]]<br><br>"

				dat += "Important Notes:<br>"
				dat += "[active2.fields["notes"]]"
			else
				dat += "<b>Record Lost!</b><br>"

			dat += "<br>"


	Topic(href, href_list)
		if (!..()) return
		switch(href_list["choice"])
			if("Security Records")
				var/datum/data/record/R = locate(href_list["target"])
				var/datum/data/record/S = locate(href_list["target"])
				mode = 2
				if (R in data_core.general)
					for (var/datum/data/record/E in data_core.security)
						if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
							S = E
							break
					active1 = R
					active3 = S
				if(!active3)
					active1 = null
			if("CloseRecord")
				active1 = null
				active2 = null
				mode = 1
		use_app()
		tablet.attack_self(usr)