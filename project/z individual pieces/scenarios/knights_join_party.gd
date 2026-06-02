extends Scenario

var new_companion1:Combatant = Database.get_combatant_by_id("basic_knight_1")
var new_companion2:Combatant = Database.get_combatant_by_id("basic_knight_2")

func _init() -> void:
	text_pages = [
		"You come upon a waterfall and its basin, and you realize not all the sounds you are hearing are water smashing rock - there's bone smashing metal.\n\nYou navigate through the underbrush and come upon a skeleton behemoth brutally impale the back of an overextended knight.",
		"A twin knight in identical armor screams in fury and crashes into the impaled arm, making quick work of the dusty joints.\nSuccessive pommel strikes into its ribcage leave the beast stunned enough for gauntleted hands to grab and crush the monsters skull.",
		"You finally cross the water and come upon the exhausted combatant.\n\nQuick words and flashes from your amulet bring the fallen back to this land - and both now-concious knights are impressed both by your powers and your quest.",
		"\"We swear to serve you with the courage to act without hesitation, and the courage to hesitate without acting.\"\n\nWith oaths from your knights, Arlaeus and Aribald bring up the flanks of your party as you travel onwards.",
	]
	
	display_blurb = "Waterfall Basin"
	display_sprite = load("res://sprites/question.png")

func on_finish_scenario() -> void:
	CombatEvents.party_member_added.emit(new_companion1)
	CombatEvents.party_member_added.emit(new_companion2)
