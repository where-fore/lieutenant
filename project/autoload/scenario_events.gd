extends Node

var current_scenario:Scenario
var tutorial_first_scenario_path:String = "res://z individual pieces/scenarios/tutorial_first_scenario.gd"
var tutorial_second_scenario_path:String = "res://z individual pieces/scenarios/tutorial_second_scenario.gd"

var tutorial_stage:int = 0

@warning_ignore("unused_signal")
signal resuming_tutorial()

@warning_ignore("unused_signal")
signal updated()

@warning_ignore("unused_signal")
signal on_last_page()

@warning_ignore("unused_signal")
signal begin_combat_with(combatant:Combatant)

@warning_ignore("unused_signal")
signal present_rewards()

@warning_ignore("unused_signal")
signal completed_combat_as_victory()

@warning_ignore("unused_signal")
signal completed_combat_as_loss()

@warning_ignore("unused_signal")
signal setup_reward(reward:Variant)

func load_tutorial_first_scenario() -> void:
	current_scenario = load(tutorial_first_scenario_path).new() as Scenario
	tutorial_stage = 1
	current_scenario.start_scenario()
	updated.emit()

func load_tutorial_second_scenario() -> void:
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
