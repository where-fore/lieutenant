extends Node

var current_scenario:Scenario
var first_scenario_path:String = "res://systems/scenario system/test_scenario.gd"

@warning_ignore("unused_signal")
signal updated()

@warning_ignore("unused_signal")
signal on_last_page()

@warning_ignore("unused_signal")
signal begin_combat_with(combatant:Combatant)

@warning_ignore("unused_signal")
signal completed_combat_as_victory()

@warning_ignore("unused_signal")
signal completed_combat_as_loss()

@warning_ignore("unused_signal")
signal setup_reward(reward:Variant)

func load_first_scenario() -> void:
	current_scenario = load(first_scenario_path).new() as Scenario
	current_scenario.start_scenario()
	updated.emit()

func finish_scenario() -> void:
	current_scenario = null
