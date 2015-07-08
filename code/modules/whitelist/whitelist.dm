
var/list/bwhitelist

/proc/load_bwhitelist()
	log_admin("Loading whitelist")
	bwhitelist = list()
	var/DBConnection/dbcon1 = new()
	dbcon1.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(!dbcon1.IsConnected())
		log_admin("Failed to load bwhitelist. Error: [dbcon1.ErrorMsg()]")
		return
	var/DBQuery/query = dbcon1.NewQuery("SELECT ckey FROM bwhitelist ORDER BY ckey ASC")
	query.Execute()
	while(query.NextRow())
		bwhitelist += "[query.item[1]]"
	if (bwhitelist==list(  ))
		log_admin("Failed to load bwhitelist or its empty")
		return
	dbcon1.Disconnect()

/proc/check_bwhitelist(var/K)
	if (!bwhitelist)
		load_bwhitelist()
		if (!bwhitelist)
			return 0
	if (K in bwhitelist)
		return 1
	return 0

/proc/bwhitelist_save(var/ckeyname)
	if (!bwhitelist)
		load_bwhitelist()
		if (!bwhitelist)
			return
	var/sql = "INSERT INTO bwhitelist (`ckey`) VALUES ('[ckeyname]')"
	var/DBQuery/query_insert = dbcon.NewQuery(sql)
	query_insert.Execute()
	usr << "\blue Ckey saved to database."
	message_admins("[key_name_admin(usr)] has added [ckeyname] to the whitelist.",1)


/proc/bwhitelist_remove(var/ckeyname)
	if (!bwhitelist)
		load_bwhitelist()
		if (!bwhitelist)
			return
	var/sql = "DELETE FROM bwhitelist WHERE ckey='[ckeyname]'"
	var/DBQuery/query_insert = dbcon.NewQuery(sql)
	query_insert.Execute()
	usr << "\blue Ckey removed from database."
	message_admins("[key_name_admin(usr)] has removed [ckeyname] from the whitelist.",1)

