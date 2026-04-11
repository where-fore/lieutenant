extends Scenario

func _init() -> void:
	text_pages = [
		"\"Ah forget about the ring.\nYou have done well by me, and by yourself. Be proud.\"\n\n\"Go with the courage to act without hesitation, and the courage to hesitate without acting.\"",
		"\"I know you must travel light and your pack size is limited, so let me cast a spell on you.\"\n\nGather strength and defeat those cultists!",
	]
	
	aura_rewards = [ #note this is 0-indexed
		load("res://z individual pieces/auras/standalone auras/tutorial_boon.gd").new().create_aura(),
	]

#derived subclasses hook onto and overwrite these functions
func next_page() -> void:
	if current_page == 1:
		ScenarioEvents.setup_reward.emit(aura_rewards[0])
		ScenarioEvents.present_rewards.emit()
	next_page_base()

func on_finish_scenario() -> void:
	ScenarioEvents.finish_tutorial()
