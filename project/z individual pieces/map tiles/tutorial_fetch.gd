extends MapTileData

func _init() -> void:
	internal_name = "first reward house"
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	enemies = [Database.get_combatant_by_id("tutorial_wolf")]

func generate_encounters() -> void:
	if TimeOfDay.current_day >= 2:
		enemies = [Database.get_combatant_by_id("cultist_bloodletter")]
		#enemies = [Database.get_combatant_by_id("tutorial_wolf"), Database.get_combatant_by_id("tutorial_wolf")]
