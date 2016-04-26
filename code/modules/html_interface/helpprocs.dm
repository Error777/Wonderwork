#define ASSET_CACHE_SEND_TIMEOUT 2.5 SECONDS // Amount of time MAX to send an asset, if this get exceeded we cancel the sleeping.

//List of ALL assets for the above, format is list(filename = asset).
/var/list/asset_cache      = list()
/var/asset_cache_populated = FALSE

/client
	var/list/cache = list() // List of all assets sent to this client by the asset cache.
	var/list/completed_asset_jobs = list() // List of all completed jobs, awaiting acknowledgement.
	var/list/sending = list()
	var/last_asset_job = 0 // Last job done.

//This proc sends the asset to the client, but only if it needs it.
/proc/send_asset(var/client/client, var/asset_name, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	while(!global.asset_cache_populated)
		sleep(5)

	if(!asset_cache.Find(asset_name))
		CRASH("Attempted to send nonexistant asset [asset_name] to [client.key]!")

	if(client.cache.Find(asset_name) || client.sending.Find(asset_name))
		return 0

	client << browse_rsc(asset_cache[asset_name], asset_name)
	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if(!client) // winexist() waits for a response from the client, so we need to make sure the client still exists.
			return 0

		client.cache += asset_name
		return 1

	if(!client) // winexist() waits for a response from the client, so we need to make sure the client still exists.
		return 0

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= asset_name
		client.cache |= asset_name
		client.completed_asset_jobs -= job

	return 1

/proc/send_asset_list(var/client/client, var/list/asset_list, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	var/list/unreceived = asset_list - (client.cache + client.sending)
	if(!unreceived || !unreceived.len)
		return 0

	for(var/asset in unreceived)
		client << browse_rsc(asset_cache[asset], asset)

	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if(!client) // winexist() waits for a response from the client, so we need to make sure the client still exists.
			return 0

		client.cache += unreceived
		return 1

	if(!client) // winexist() waits for a response from the client, so we need to make sure the client still exists.
		return 0

	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= unreceived
		client.cache |= unreceived
		client.completed_asset_jobs -= job

	return 1

//This proc "registers" an asset, it adds it to the cache for further use, you cannot touch it from this point on or you'll fuck things up.
//if it's an icon or something be careful, you'll have to copy it before further use.
/proc/register_asset(var/asset_name, var/asset)
	asset_cache |= asset_name
	asset_cache[asset_name] = asset


//From here on out it's populating the asset cache.

/proc/populate_asset_cache()
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()

		A.register()

	global.asset_cache_populated = TRUE

//These datums are used to populate the asset cache, the proc "register()" does this.
/datum/asset/proc/register()
	return

//If you don't need anything complicated.
/datum/asset/simple
	var/assets = list()

/datum/asset/simple/register()
	for(var/asset_name in assets)
		register_asset(asset_name, assets[asset_name])

//Registers HTML I assets.
/datum/asset/HTML_interface/register()
	for(var/path in typesof(/datum/html_interface))
		var/datum/html_interface/hi = new path()
		hi.registerResources()

