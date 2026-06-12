extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_house1.tres")
	scenario = load("res://z individual pieces/scenarios/tutorial_house.gd").new()
	
