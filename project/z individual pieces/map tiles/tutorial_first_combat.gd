extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemies = [Database.get_combatant_by_id("tutorial_wolf")]
	reward = Database.get_reward_by_id("small_shield")
