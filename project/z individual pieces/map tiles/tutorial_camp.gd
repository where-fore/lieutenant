extends MapTileData

var have_encountered_camp_already:bool = false

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	scenario = load("res://z individual pieces/scenarios/tutorial_new_combatant_empty.gd").new()
	
	MapEvents.tutorial_camp_encounter_complete.connect(toggle_spawning)

func generate_encounters() -> void:
	if TimeOfDay.current_day >= 2 and not have_encountered_camp_already:
		change_scenario_to_camp()

func change_scenario_to_camp() -> void:
	scenario = load("res://z individual pieces/scenarios/tutorial_new_combatant.gd").new()

func toggle_spawning() -> void:
	have_encountered_camp_already = true
