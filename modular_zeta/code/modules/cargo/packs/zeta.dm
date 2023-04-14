/datum/supply_pack/zeta
	group = "Local Retailers"
	crate_type = /obj/structure/closet/crate/zeta

/obj/structure/closet/crate/zeta
	name = "Zeta goods"
	desc = "Protected with space-stabilizers."
	icon = 'modular_zeta/icons/obj/crates.dmi'
	icon_state = "zeta"

/datum/supply_pack/zeta/rnd_circuits
	name = "R&D circuit pack"
	desc = "Base research machinery circuits for mobile exploration ships."
	cost = 3500
	contains = list(
		/obj/item/circuitboard/machine/protolathe,
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/circuitboard/machine/circuit_imprinter,
		/obj/item/circuitboard/computer/rdconsole,
		/obj/item/circuitboard/machine/rdserver
	)
	crate_name = "R&D circuit pack"

/datum/supply_pack/zeta/mining_kit
	name = "Mining kit"
	desc = "Necessary items to start mining industry. Contains basic equipment and ore redemption."
	cost = 1500
	contains = list(
		/obj/item/flashlight,
		/obj/item/pickaxe/drill,
		/obj/machinery/mineral/ore_redemption,
		/obj/item/storage/bag/ore,
		/obj/item/mining_scanner
	)
	crate_name = "mining kit"

/datum/supply_pack/zeta/boombox
	name = "Boombox"
	desc = "Provides a boost in morale and a friendly atmosphere. Party code not included."
	cost = 2000
	contains = list(
		/obj/machinery/jukebox/boombox
	)
	crate_name = "boombox"
