/datum/admins/Topic(href, href_list) //Yep, admin's topic
	..()

	if(href_list["remove"])
		var/ckeyname = href_list["remove"]
		ckeyname = ckey(ckeyname)

		bwhitelist_remove(ckeyname)
		return


	else if(href_list["addtowhitelist"])
		var/ckeyname = href_list["ckeyname"]
		ckeyname = ckey(ckeyname)

		bwhitelist_save(ckeyname)
		return

	else if(href_list["whitelistsearchckey"])
		var/playerckey = href_list["whitelistsearchckey"]

		bwhitelist_panel(playerckey)
		return


/client/proc/bwhitelist_panel_open()
	set category = "Whitelist"
	set name = "Whitelist Panel"
	set desc = "Adding and Removing"

	if(!holder)
		return

	holder.bwhitelist_panel()

/datum/admins/proc/bwhitelist_panel(var/ckeyname = null)

	if(!usr.client)
		return

	if(!check_rights(R_SERVER))	return

	establish_db_connection()
	if(!dbcon.IsConnected())
		usr << "\red Failed to establish database connection"
		return

	var/output = "<div align='center'><table width='90%'><tr>"

	ckeyname = ckey(ckeyname) //Just in case

	output += {"<td width='35%' align='center'><h1>Whitelist</h1></td>
		<td width='65%' align='center' bgcolor='#f9f9f9'>
		<form method='GET' action='?src=\ref[src]'>
		<input type='hidden' name='src' value='\ref[src]'>
		<table width='100%'><tr>
		<td><b>Ckey:</b> <input type='text' name='ckeyname'></td>
		<td><input type='submit' name='addtowhitelist' value='Add to Whitelist'></td>
		</form>
		</tr>
		</td>
		</table>
		<form method='GET' action='?src=\ref[src]'><b>Search</b>
		<input type='hidden' name='src' value='\ref[src]'>
		<b>Ckey:</b> <input type='text' name='whitelistsearchckey' value='[ckeyname]'>
		<input type='submit' value='search'>
		</form>"}

	if(ckeyname)
		output += {"<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>
				<tr>
				<th width='60%'><b>CKEY</b></th>
				<th width='40%'><b>OPTIONS</b></th>
				</tr>"}



		var/DBQuery/select_query = dbcon.NewQuery("SELECT ckey FROM bwhitelist WHERE ckey = '[ckeyname]' ORDER BY ckey ASC")
		select_query.Execute()

		while(select_query.NextRow())
			var/ckey = select_query.item[1]

			output += {"<tr bgcolor='lightgrey'>
				<td align='center'><b>[ckey]</b></td>
				<td align='center'>["<b><a href=\"byond://?src=\ref[src];remove=[ckeyname];\">Remove</a></b>"]</td>
				</tr>"}

		output += "</table></div>"

	usr << browse(output,"window=lookupbans;size=900x500")