extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	scenario = load("res://z individual pieces/scenarios/item_test_scenario.gd").new()
