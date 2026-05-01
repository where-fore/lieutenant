extends Scenario

func _init() -> void:
	text_pages = [
		"you're travelling peacefully in the woods...",
		"but then a skeleton appears!",
		"you dust yourself off, and venture on your merry way",
	]
	
	enemies = [ #note this is 0-indexed
		Database.get_combatant_by_id("basic_skeleton"),
	]
	
	rewards = [ #note this is 0-indexed
		load("res://z individual pieces/auras/standalone auras/sharpen.gd").new().create_aura(),
		load("res://z individual pieces/auras/standalone auras/rested.gd").new().create_aura(),
		Database.get_item_by_id("iron_sword"),
	]

func next_page() -> void:
	if current_page == 2:
		#ScenarioEvents.setup_reward.emit(rewards[0])
		#ScenarioEvents.begin_combat_with.emit(enemies[0])
		end_combat()
	else: next_page_base()

func end_combat() -> void:
	next_page_base()
