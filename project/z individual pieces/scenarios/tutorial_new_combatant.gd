extends Scenario

var new_companion:Combatant = Database.get_combatant_by_id("basic_rogue")

func _init() -> void:
	text_pages = [
		"You approach a camp in a clearing, scattered embers lie dormant in the campfire, assorted dried foods overflow from a small sack...\n\nYou note no recent footprints, or other evidence, of an owner or a struggle.",
		"You turn to look over your shoulder before you realize the source of instinct.",
		"You parry the grab at your neck but miss the dagger now a threat pressed against your kidney.\n\nYou lock a serious gaze with someone who looks as exhausted as you feel.\nBoth of you can't trust anyone in this wilderness.",
		"Before either of you can speak, the shrill cry of a familiar skeleton beast erupts from the trees behind this stranger!\n\nYour kidneys are free from their threat as you both turn to face the creature.",
		"\"Better together then?\"\n\nAs you lick your wounds, you look forward to having someone to watch your back, so no more rogues sneak up behind you while investigating camps.",
	]
	
	enemies = [ #note this is 0-indexed
		Database.get_combatant_by_id("tutorial_skeleton"),
	]
	
	rewards = [ #note this is 0-indexed
	]
	
	display_blurb = "Abandoned Campsite"
	display_sprite = load("res://sprites/fire.png")

func next_page() -> void:
	if current_page == 4:
		CombatEvents.party_member_added.emit(new_companion)
		
		var enemies_to_send:Array[Combatant] = [enemies[0]]
		ScenarioEvents.begin_combat_with.emit(enemies_to_send)
	else: next_page_base()

func on_finish_scenario() -> void:
	MapEvents.tutorial_camp_encounter_complete.emit()
