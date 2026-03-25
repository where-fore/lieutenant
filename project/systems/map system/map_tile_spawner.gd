extends Node2D

@export_category("Map Tile Information")
@export var map_data:Array[GDScript]
@export var boss_tile_data:Array[GDScript]
@export var generic_border_data:GDScript

@export_category("Map Grid Builder")
@export var mapTileBase:PackedScene
@export var rows:int = 3
@export var vertical_spacing:int = 17
@export var columns:int = 17
@export var horizontal_spacing:int = 31
@export var isometric_offset:int = 6
@export_enum("Top Left", "Bottom Left") var this_spawner_is_placed_at:int = 0
@export var columns_to_disable_at_end:int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_if_tile_export_set_correctly()
	populate_tiles()

#note that this does do not do any z-indexing, and defaults to godot tree hierarchy z-indexing
#the first tiles created here will be drawn to screen last
#and thus if you start spawning from the top left of your final grid:
#the bottom rows will draw over the top rows
#the right-hand rows will draw over the left-hand rows
func populate_tiles() -> void:
	for x:int in columns:
		for y:int in rows:
			var new_tile:MapTile = mapTileBase.instantiate()
			add_child(new_tile)
			
			if this_spawner_is_placed_at == 0: #this an enum index, 0 being the first option
				new_tile.position = Vector2(x * horizontal_spacing - y * isometric_offset, y * vertical_spacing)
			elif this_spawner_is_placed_at == 1:
				new_tile.position = Vector2(x * horizontal_spacing + y * isometric_offset, rows-y * vertical_spacing)
			
			new_tile.x_coordinate = x
			new_tile.y_coordinate = y
			populate_tile_data(new_tile)

func populate_tile_data(tile:MapTile) -> void:
	#final boss stretch
	if tile.x_coordinate == columns - columns_to_disable_at_end - 1: #the last column
		if tile.y_coordinate == 0 or tile.y_coordinate == 2:
			tile.apply_data(generic_border_data.new())
			tile.disable()
		elif tile.y_coordinate == 1:
			tile.apply_data(boss_tile_data.pick_random().new())
	#first and last rows
	elif tile.x_coordinate == 0 or tile.x_coordinate >= columns - columns_to_disable_at_end:
		tile.apply_data(generic_border_data.new())
		tile.disable()
	
	else:
		tile.apply_data(map_data.pick_random().new())

func check_if_tile_export_set_correctly() -> void:
	if map_data.has(null) or map_data.is_empty():
		push_error("general map tile data not set correctly on spawner")
	if boss_tile_data.has(null) or boss_tile_data.is_empty():
		push_error("boss tile data not set correctly on spawner")
	if generic_border_data == null:
		push_error("border tile data not set correctly on spawner")
