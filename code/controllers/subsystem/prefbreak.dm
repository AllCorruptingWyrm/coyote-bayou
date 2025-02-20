/// A whole subsystem dedicated to breaking your prefs~
SUBSYSTEM_DEF(prefbreak) // ALL ABOARD THE S.S. PREFBREAK OFF TO **** YOUR ***************!
	name = "PrefBreaker"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_PREFBREAK
	/// An asslist of prefcheck
	var/list/prefs

/datum/controller/subsystem/prefbreak/Initialize()
	setup_prefcheck()
	return ..()

/datum/controller/subsystem/prefbreak/proc/setup_prefcheck()
	prefs = list()
	for(var/sounpref in subtypesof(/datum/prefcheck))
		var/datum/prefcheck/spref = new sounpref()
		prefs[spref.index] = spref

/datum/controller/subsystem/prefbreak/proc/get_prefs(pingvin)
	if(istype(pingvin, /datum/preferences))
		return pingvin
	if(isclient(pingvin))
		var/client/zloy = pingvin
		return zloy.prefs
	if(ismob(pingvin))
		var/mob/zloy = pingvin
		return zloy.client?.prefs

/// takes in anything, sees if it has a client/prefs/whatever, and checks those prefs
/// Allows things by default, denies it if specifically disallowed
/datum/controller/subsystem/prefbreak/proc/allowed_by_prefs(broken, index)
	if(!broken)
		return TRUE // allow by default
	if(!index)
		return TRUE
	var/datum/preferences/break_me_complitely = get_prefs(broken)
	if(!break_me_complitely)
		return TRUE // either no client, or something went fucky
	var/datum/prefcheck/ultimate_breaker = prefs[index]
	if(!ultimate_breaker)
		return TRUE
	return ultimate_breaker.allowed(break_me_complitely)

/* 
 * Preference lookup table
 * feed it someone's prefs, it spits out a yes or a no
 */
/// Most often, its just checking a flag on a mob's client's prefs
/datum/prefcheck
	var/index = "oopsie"

/datum/prefcheck/proc/allowed(datum/preferences/consumer)
	return TRUE

/// Master vore prefs
/datum/prefcheck/voreprefs
	index = "vore"

/datum/prefcheck/voreprefs/allowed(datum/preferences/consumer)
	return consumer // kinda vital here

/// Able to hear eat sounds
/datum/prefcheck/voreprefs/eat_noises
	index = VOREPREF_EAT_SOUNDS

/datum/prefcheck/voreprefs/eat_noises/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_eating_sounds

/// Able to hear digestion
/datum/prefcheck/voreprefs/digest_noises
	index = VOREPREF_DIGESTION_SOUNDS

/datum/prefcheck/voreprefs/digest_noises/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_digestion_sounds

/// Able to be digested harmfully
/datum/prefcheck/voreprefs/digest_damage
	index = VOREPREF_DIGESTION_DAMAGE

/datum/prefcheck/voreprefs/digest_damage/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_digestion_damage

/// Able to be digested to death
/datum/prefcheck/voreprefs/digest_death
	index = VOREPREF_DIGESTION_DEATH

/datum/prefcheck/voreprefs/digest_death/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_digestion_death

/// Able to be absorbed
/datum/prefcheck/voreprefs/absorbable
	index = VOREPREF_ABSORBTION

/datum/prefcheck/voreprefs/absorbable/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_absorbtion

/// Able to be healbellied
/datum/prefcheck/voreprefs/healbellyable
	index = VOREPREF_HEALBELLY

/datum/prefcheck/voreprefs/healbellyable/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_healbelly_healing

/// Able to see belly descs
/datum/prefcheck/voreprefs/examine
	index = VOREPREF_EXAMINE

/datum/prefcheck/voreprefs/examine/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_seeing_belly_descriptions

/// Able to see vorey messages
/datum/prefcheck/voreprefs/text
	index = VOREPREF_VORE_MESSAGES

/datum/prefcheck/voreprefs/text/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_vore_messages

/// Able to see vorey death messages
/datum/prefcheck/voreprefs/text_xtreme
	index = VOREPREF_DEATH_MESSAGES

/datum/prefcheck/voreprefs/text_xtreme/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_death_messages

/// Able to be vored
/datum/prefcheck/voreprefs/being_prey
	index = VOREPREF_BEING_PREY

/datum/prefcheck/voreprefs/being_prey/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_being_prey

/// Able to be fed prey by others
/datum/prefcheck/voreprefs/being_fed_prey
	index = VOREPREF_BEING_FED_PREY

/datum/prefcheck/voreprefs/being_fed_prey/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_being_fed_prey

/// Able to be fed to others
/datum/prefcheck/voreprefs/being_fed_to_others
	index = VOREPREF_BEING_FED_TO_OTHERS

/datum/prefcheck/voreprefs/being_fed_to_others/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_being_fed_to_others

/// Able to be sniffad
/datum/prefcheck/voreprefs/sniff
	index = VOREPREF_SNIFFABLE

/datum/prefcheck/voreprefs/sniff/allowed(datum/preferences/consumer)
	if(!..())
		return FALSE
	return consumer.allow_being_sniffed



