/*
 * ATOM PROCS
 */

/atom/proc/set_labeled(var/label, var/start_text = " (", var/end_text = ")")
	if(labeled)
		remove_label()
	labeled = "[start_text][label][end_text]"
	name = "[name][labeled]"
	new/atom/proc/remove_label_verb(src)

/atom/proc/remove_label_verb()
	set name = "Remove label"
	set src in view(1)
	set category = "Object"
	if(usr.stunned || usr.restrained())
		return
	remove_label()
	to_chat(usr, "<span class='notice'>You remove the label.</span>")

/atom/proc/remove_label()
	name = replacetext(name, labeled, "")
	labeled = null
	verbs -= /atom/proc/remove_label_verb