extends Node

var current_scenario:Scenario
var first_scenario:Scenario = load("res://systems/scenario system/test_scenario.gd").new() as Scenario

@warning_ignore("unused_signal")
signal updated()

@warning_ignore("unused_signal")
signal on_last_page()

func load_first_scenario() -> void:
	current_scenario = first_scenario
	current_scenario.start_scenario()
	updated.emit()

func finish_scenario() -> void:
	current_scenario = null
