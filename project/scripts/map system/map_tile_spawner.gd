extends Node2D

@export_category("Map Tile Information")
@export var map_data:Array[GDScript]

@export_category("Map Grid Builder")
@export var mapTileBase:PackedScene
@export var rows:int = 3
@export var vertical_spacing:int = 16
@export var columns:int = 15
@export var horizontal_spacing:int = 31
@export var isometric_offset:int = 6
@export_enum("Top Left", "Bottom Left") var this_spawner_is_placed_at:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_tiles()

#note that this does do not do any z-indexing, and defaults to godot tree hierarchy z-indexing
#the first tiles created here will be drawn to screen last
#and thus if you start spawning from the top left of your final grid:
#the bottom rows will draw over the top rows
#the right-hand rows will draw over the left-hand rows
func populate_tiles() -> void:
	for x:int in columns:
		for y:int in rows:
			var new_tile:Node = mapTileBase.instantiate()
			add_child(new_tile)
			
			if this_spawner_is_placed_at == 0: #this an enum index, 0 being the first option
				new_tile.position = Vector2(x * horizontal_spacing - y * isometric_offset, y * vertical_spacing)
			elif this_spawner_is_placed_at == 1:
				new_tile.position = Vector2(x * horizontal_spacing + y * isometric_offset, rows-y * vertical_spacing)
			
			new_tile.apply_data(map_data.pick_random().new())

func populate_tile_data() -> void:
	pass
