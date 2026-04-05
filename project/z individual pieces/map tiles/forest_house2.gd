extends MapTileData

func _init() -> void:
	internal_name = "basic house 2"
	tile_animation = load("res://z individual pieces/map tiles/forest_house2.tres")
	aura_reward = load("res://z individual pieces/auras/standalone auras/sharpen.gd").new().create_aura()
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.RARE]).pick_random()
