extends Node2D

var current_map_tiles:Array[MapTile]
var current_column_sunsetting:int = 1
var tiles_you_can_see_into_fog_of_war:int = 3
var current_tile_encounter:MapTile
@onready var maptile_spawner_parent:Node2D = $MapTileSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapEvents.combat_all_done.connect(hide_current_row_and_increment)
	MapEvents.maptile_created.connect(add_to_database)
	MapEvents.map_grid_ready.connect(hide_all_but_first_row)
	MapEvents.venture_to.connect(handle_map_transition)
	MapEvents.reward_offered.connect(fully_cleared_tile)
	
	maptile_spawner_parent.populate_tiles()

func handle_map_transition(map_tile:MapTile) -> void:
	current_tile_encounter = map_tile
	
	if map_tile.tile_data.enemy:
		MapEvents.enter_combat_in.emit(map_tile)
	else:
		MapEvents.enter_without_combat_in.emit(map_tile)

func hide_current_row_and_increment() -> void:
	hide_rows()
	current_column_sunsetting += 1

func hide_rows() -> void:
	var furthest_column:int = current_column_sunsetting + tiles_you_can_see_into_fog_of_war
	var enabled_tiles:int = 0
	
	for maptile:MapTile in current_map_tiles:
		if maptile.x_coordinate <= current_column_sunsetting:
			maptile.disable()
		elif maptile.x_coordinate > furthest_column:
			maptile.disable()
		elif maptile.x_coordinate <= furthest_column: #note this elif comes after hiding the earlier tiles
			maptile.enable()
		
		if not maptile.currently_disabled and not maptile.permanently_disabled:
			enabled_tiles += 1
	if enabled_tiles == 0: push_error("somehow disabled every tile possible")

func hide_all_but_first_row() -> void:
	for maptile:MapTile in current_map_tiles:
		if maptile.x_coordinate != 1:
			maptile.disable()

func add_to_database(new_map_tile:MapTile) -> void:
	current_map_tiles.append(new_map_tile)

func fully_cleared_tile() -> void:
	current_tile_encounter.permanently_disable()
	current_tile_encounter = null
