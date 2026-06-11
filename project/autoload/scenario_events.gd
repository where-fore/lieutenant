extends Node

var current_scenario:Scenario

@warning_ignore_start("unused_signal")
signal updated
signal on_last_page
signal begin_combat_with(combatant:Combatant)
signal begin_combat_with_map_enemy
signal present_rewards
signal completed_combat_as_victory
signal completed_combat_as_loss
signal setup_reward(reward:Reward)
@warning_ignore_restore("unused_signal")

func load_scenario(new_scenario:Scenario) -> void:
	current_scenario = new_scenario
	current_scenario.start_scenario()
	updated.emit()

func finish_scenario() -> void:
	if current_scenario:
		current_scenario.on_finish_scenario()
		current_scenario = null
		MapEvents.tile_completed_new_ground.emit()
		MapEvents.tile_all_done.emit()
	else:
		pass

func finish_tile_as_victory_if_no_scenario() -> void:
	if current_scenario:
		pass
	else:
		MapEvents.tile_completed_new_ground.emit()
		MapEvents.tile_all_done.emit()

func finish_tile_as_defeat_if_no_scenario() -> void:
	if current_scenario:
		pass
	else:
		MapEvents.tile_completed_new_ground.emit()
		#MapEvents.tile_completed_no_new_ground.emit()
		MapEvents.tile_all_done.emit()

func _ready() -> void:
	MapEvents.combat_finished_as_victory.connect(finish_tile_as_victory_if_no_scenario)
	MapEvents.combat_finished_as_defeat.connect(finish_tile_as_defeat_if_no_scenario)



#vestigial hardcoded tutorial

#var tutorial_first_scenario_path:String = "res://z individual pieces/scenarios/tutorial_first_scenario.gd"
#var tutorial_second_scenario_path:String = "res://z individual pieces/scenarios/tutorial_second_scenario.gd"
#
#var tutorial_stage:int = 0
#
#func load_tutorial_first_scenario() -> void:
	#current_scenario = load(tutorial_first_scenario_path).new() as Scenario
	#tutorial_stage = 1
	#current_scenario.start_scenario()
	#updated.emit()
#
#func load_tutorial_second_scenario() -> void:
	#item_tutorial_ready.emit()
	#current_scenario = load(tutorial_second_scenario_path).new() as Scenario
	#tutorial_stage = 2
	#current_scenario.start_scenario()
	#updated.emit()
	#resuming_tutorial.emit()
#
#func finish_tutorial() -> void:
	#tutorial_stage = 0
