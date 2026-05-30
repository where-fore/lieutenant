extends Scenario

func _init() -> void:
	text_pages = [
		"developer testing!",
		"", #this is the reward page
		"now fight!",
		"", #this is the combat page
		"testing complete.",
	]
	
	enemies = [ #note this is 0-indexed
		Database.get_combatant_by_id("developer_target_dummy"),
	]
	
	rewards = [ #note this is 0-indexed
		Database.get_reward_by_id("enrage_sword"),
	]
	
	display_blurb = "developer testing dummy"
	display_sprite = load("res://sprites/cross_swords.png")

func next_page() -> void:
	if current_page == 1:
		ScenarioEvents.setup_reward.emit(rewards[0])
		ScenarioEvents.present_rewards.emit()
	if current_page == 3:
		ScenarioEvents.begin_combat_with.emit(enemies)
	else: next_page_base()
