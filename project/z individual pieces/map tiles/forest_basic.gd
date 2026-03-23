extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/forest_basic.tres")
	item_reward = Database.get_items_by_category(ItemCategories.rare_item).pick_random()
	
