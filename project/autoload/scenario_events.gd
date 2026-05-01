extends Node

var current_scenario:Scenario
var tutorial_first_scenario_path:String = "res://z individual pieces/scenarios/tutorial_first_scenario.gd"
var tutorial_second_scenario_path:String = "res://z individual pieces/scenarios/tutorial_second_scenario.gd"

var tutorial_stage:int = 0

@warning_ignore_start("unused_signal")
signal resuming_tutorial()
signal item_tutorial_ready()
signal updated()
signal on_last_page()
signal begin_combat_with(combatant:Combatant)
signal present_rewards()
signal completed_combat_as_victory()
signal completed_combat_as_loss()
signal setup_reward(reward:Reward)
@warning_ignore_restore("unused_signal")

func load_scenario(new_scenario:Scenario) -> void:
	current_scenario = new_scenario
	current_scenario.start_scenario()
	updated.emit()

func load_tutorial_first_scenario() -> void:
	current_scenario = load(tutorial_first_scenario_path).new() as Scenario
	tutorial_stage = 1
	current_scenario.start_scenario()
	updated.emit()

func load_tutorial_second_scenario() -> void:
	item_tutorial_ready.emit()
	current_scenario = load(tutorial_second_scenario_path).new() as Scenario
	tutorial_stage = 2
	current_scenario.start_scenario()
	updated.emit()
	resuming_tutorial.emit()

func finish_tutorial() -> void:
	tutorial_stage = 0

func finish_scenario() -> void:
	current_scenario.on_finish_scenario()
	current_scenario = null
