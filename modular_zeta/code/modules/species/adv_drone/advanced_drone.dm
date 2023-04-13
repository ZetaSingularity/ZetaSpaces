/datum/species/adv_drone
	name = "\improper Advanced Drone"
	id = SPECIES_ADVDRONE
	sexes = TRUE
	species_traits = list(NOTRANSSTING,NOEYESPRITES,NO_DNA_COPY,NOBLOOD,TRAIT_EASYDISMEMBER,NOZOMBIE,MUTCOLORS,REVIVESBYHEALING,NOHUSK,NOMOUTH,NO_BONES, MUTCOLORS) //all of these + whatever we inherit from the real species
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_VIRUSIMMUNE,TRAIT_NOBREATH,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_LIMBATTACHMENT)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	mutantbrain = /obj/item/organ/brain/mmi_holder/posibrain
	mutanteyes = /obj/item/organ/eyes/robotic
	mutanttongue = /obj/item/organ/tongue/robot
	mutantliver = /obj/item/organ/liver/cybernetic/upgraded/ipc
	mutantstomach = /obj/item/organ/stomach/cell
	mutantears = /obj/item/organ/ears/robot
	mutantlungs = null
	mutantappendix = null
	mutant_organs = list(/obj/item/organ/cyberimp/arm/power_cord)
	mutant_bodyparts = list("adv_drone_chassis", "adv_drone_face", "adv_drone_hair", "ipc_brain")
	default_features = list("mcolor" = "#7D7D7D", "adv_drone_chassis" = "Worker", "adv_drone_face" = "Normal", "adv_drone_hair" = "Bald", "ipc_brain" = "Posibrain", "body_size" = "Normal")
	meat = /obj/item/stack/sheet/plasteel{amount = 5}
	skinned_type = /obj/item/stack/sheet/metal{amount = 10}
	exotic_blood = /datum/reagent/fuel/oil
	damage_overlay_type = "synth"
	burnmod = 1.25
	heatmod = 1.5
	brutemod = 1
	siemens_coeff = 1.5
	reagent_tag = PROCESS_SYNTHETIC
	species_gibs = "robotic"
	attack_sound = 'sound/items/trayhit1.ogg'
	deathsound = "sound/voice/borg_deathsound.ogg"
	wings_icons = list("Robotic")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/ipc
	loreblurb = "Advanced drones are synthetic lifeforms created for helping human with work in exo-planets, but something goes wrong and people died. Survived drones continued their work and extension."
	ass_image = 'icons/ass/assmachine.png'

	species_chest = /obj/item/bodypart/chest/adv_drone
	species_head = /obj/item/bodypart/head/adv_drone
	species_l_arm = /obj/item/bodypart/l_arm/adv_drone
	species_r_arm = /obj/item/bodypart/r_arm/adv_drone
	species_l_leg = /obj/item/bodypart/leg/left/adv_drone
	species_r_leg = /obj/item/bodypart/leg/right/adv_drone

	var/saved_screen
	var/datum/action/innate/change_screen/change_screen

/datum/species/adv_drone/random_name(unique)
	var/drone_name = "[pick(GLOB.posibrain_names)]-[rand(100, 999)]"
	return drone_name

/*
/datum/species/adv_drone/New()
	. = ..()
	offset_clothing = list(
		"[HEAD_LAYER]" = list("[NORTH]" = list("x" = 0, "y" = 2), "[EAST]" = list("x" = 0, "y" = 0), "[SOUTH]" = list("x" = 0, "y" = 0), "[WEST]" = list("x" = 0, "y" = 0)),
	)
*/

/datum/species/adv_drone/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(!change_screen)
			change_screen = new
			change_screen.Grant(H)
		if(H.dna.features["ipc_brain"] == "Man-Machine Interface")
			mutantbrain = /obj/item/organ/brain/mmi_holder
		else
			mutantbrain = /obj/item/organ/brain/mmi_holder/posibrain
	return ..()

/datum/species/adv_drone/on_species_loss(mob/living/carbon/C)
	. = ..()
	if(change_screen)
		change_screen.Remove(C)

/datum/species/adv_drone/spec_death(gibbed, mob/living/carbon/C)
	saved_screen = C.dna.features["adv_drone_face"]
	C.dna.features["adv_drone_face"] = "err"
	C.update_body()
	addtimer(CALLBACK(src, .proc/post_death, C), 5 SECONDS)

/datum/species/adv_drone/proc/post_death(mob/living/carbon/C)
	if(C.stat < DEAD)
		return
	C.dna.features["adv_drone_face"] = null
	C.update_body()

/datum/action/innate/change_screen
	name = "Change Face Display"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/change_screen/Activate()
	var/screen_choice = input(usr, "Which face do you want to display?", "Face Change") as null | anything in GLOB.adv_drone_face_list
	var/color_choice = input(usr, "Which color do you want your face to be?", "Color Change") as null | color
	if(!screen_choice)
		return
	if(!color_choice)
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.dna.features["adv_drone_face"] = screen_choice
	H.eye_color = sanitize_hexcolor(color_choice)
	H.update_body()

/obj/item/apc_powercord
	name = "power cord"
	desc = "An internal power cord hooked up to a battery. Useful if you run on electricity. Not so much otherwise."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

/obj/item/apc_powercord/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if((!istype(target, /obj/machinery/power/apc) && !isethereal(target)) || !ishuman(user) || !proximity_flag)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/stomach/cell/battery = H.getorganslot(ORGAN_SLOT_STOMACH)
	if(!battery)
		to_chat(H, "<span class='warning'>You try to siphon energy from \the [target], but your power cell is gone!</span>")
		return

	if(istype(H) && H.nutrition >= NUTRITION_LEVEL_ALMOST_FULL)
		to_chat(user, "<span class='warning'>You are already fully charged!</span>")
		return

	if(istype(target, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.cell && A.cell.charge > A.cell.maxcharge/4)
			powerdraw_loop(A, H, TRUE)
			return
		else
			to_chat(user, "<span class='warning'>There is not enough charge to draw from that APC.</span>")
			return

	if(isethereal(target))
		var/mob/living/carbon/human/target_ethereal = target
		var/obj/item/organ/stomach/ethereal/eth_stomach = target_ethereal.getorganslot(ORGAN_SLOT_STOMACH)
		if(target_ethereal.nutrition > 0 && eth_stomach)
			powerdraw_loop(eth_stomach, H, FALSE)
			return
		else
			to_chat(user, "<span class='warning'>There is not enough charge to draw from that being!</span>")
			return

/datum/species/adv_drone/spec_life(mob/living/carbon/human/H)
	. = ..()
	if(H.health <= HEALTH_THRESHOLD_CRIT && H.stat != DEAD)
		H.adjustFireLoss(6)
		if(prob(5))
			to_chat(H, "<span class='warning'>Alert: Internal temperature regulation systems offline; thermal damage sustained. Shutdown imminent.</span>")
			H.visible_message("[H]'s cooling system fans stutter and stall. There is a faint, yet rapid beeping coming from inside their chassis.")


/datum/species/adv_drone/spec_revival(mob/living/carbon/human/H)
	H.dna.features["adv_drone_face"] = "err"
	H.update_body()
	H.say("Reactivating [pick("core systems", "central subroutines", "key functions")]...")
	addtimer(CALLBACK(src, .proc/post_revival, H), 6 SECONDS)

/datum/species/adv_drone/proc/post_revival(mob/living/carbon/human/H)
	if(H.stat < DEAD)
		return
	H.say("Unit [H.real_name] is fully functional. Have a nice day.")
	H.dna.features["adv_drone_face"] = saved_screen
	H.update_body()

/datum/species/adv_drone/replace_body(mob/living/carbon/C, datum/species/new_species)
	..()

	var/datum/sprite_accessory/adv_drone_chassis/chassis_of_choice = GLOB.adv_drone_chassis_list[C.dna.features["adv_drone_chassis"]]

	for(var/obj/item/bodypart/BP as anything in C.bodyparts)
		if(BP.limb_id=="adv_drone")
			BP.uses_mutcolor = chassis_of_choice.color_src ? TRUE : FALSE
			if(BP.uses_mutcolor)
				BP.should_draw_greyscale = TRUE
				BP.species_color = C.dna?.features["mcolor"]

			BP.limb_id = chassis_of_choice.limbs_id
			BP.name = "\improper[chassis_of_choice.name] [parse_zone(BP.body_zone)]"
			BP.update_limb()

/mob/living/carbon/human/species/adv_drone
	race = /datum/species/adv_drone
