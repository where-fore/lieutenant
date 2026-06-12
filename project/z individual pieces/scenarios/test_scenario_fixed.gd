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
		Database.get_reward_by_id("iron_sword"),
	]
	
	#display_blurb = "testing"
	#display_sprite = load("res://sprites/hook_sword.png")

func next_page() -> void:
	if current_page == 2:
		var enemies_to_send:Array[Combatant] = [enemies[0]]
		ScenarioEvents.setup_reward.emit(rewards.pick_random())
		ScenarioEvents.begin_combat_with.emit(enemies_to_send)
	else: next_page_base()

func scale_scenario_to_time() -> void:
	if TimeOfDay.current_day >= 3:
		enemies[0] = Database.get_combatant_by_id("cultist_hemomancer")
	
	basic_scale_enemy_stats_by_day()
