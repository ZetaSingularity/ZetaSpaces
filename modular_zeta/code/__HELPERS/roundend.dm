/datum/controller/subsystem/ticker/gather_roundend_feedback()
	. = ..()
	var/discordmsg = "--------------ROUND END--------------\n"
	discordmsg += "Round Number: [GLOB.round_id]\n"
	discordmsg += "Duration:     [DisplayTimeText(world.time - SSticker.round_start_time)]\n"
	var/list/ded = SSblackbox.first_death
	if(ded)
		discordmsg += "First Death:     [ded["name"]], [ded["role"]], at [ded["area"]]\n"
		discordmsg += "Damage taken:    [ded["damage"]]\n"
		var/last_words = ded["last_words"] ? "Their last words were: \"[ded["last_words"]]\"" : "They had no last words."
		discordmsg += "[last_words]\n"
	else
		discordmsg += "Nobody died!"
	discordmsg += "--------------------------------------\n"
	discordmsg += "New round will start soon!"
	discordsendmsg("round", discordmsg)
