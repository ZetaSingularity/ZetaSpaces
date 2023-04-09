/datum/controller/subsystem/ticker/setup()
	. = ..()
	var/discordmsg = "--------------NEW ROUND STARTING--------------\n"
	discordmsg += "Round Number: [GLOB.round_id]\n"
	discordsendmsg("round", discordmsg)
