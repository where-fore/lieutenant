extends Scenario

func _init() -> void:
	text_pages = [
		"Home sweet home.\n\nYou wish you could stay.",
		"You gather your mother's amulet from the mantel,\nknowing you'll need her powers for the journey ahead.",
	]
	
	rewards = [Database.get_reward_by_id("starting_artifact")]
	
	display_blurb = "Home Sweet Home"

func on_finish_scenario() -> void:
	ScenarioEvents.setup_reward.emit(rewards[0])
	ScenarioEvents.present_rewards.emit(true)
