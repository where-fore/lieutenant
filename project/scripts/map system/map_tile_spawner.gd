extends Node2D

@export var mapTileBase:PackedScene
@export var rows:int = 3
@export var vertical_spacing:int = 16
@export var columns:int = 15
@export var horizontal_spacing:int = 29
@export var isometric_offset:int = 6
@export_enum("Top Left", "Bottom Left") var start_at:int = 0

var built_tiles:Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_tiles()

func populate_tiles() -> void:
	for x:int in columns:
		for y:int in rows:
			var new_tile:Node = mapTileBase.instantiate()
			add_child(new_tile)
			if start_at == 0: #this an enum index, 0 being the first option
				new_tile.position = Vector2(x * horizontal_spacing - y * isometric_offset, y * vertical_spacing)
			elif start_at == 1:
				new_tile.position = Vector2(x * horizontal_spacing + y * isometric_offset, rows-y * vertical_spacing)
			built_tiles.append(new_tile)
