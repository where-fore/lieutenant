extends Node2D

var current_map_tiles:Array[MapTile]
var current_column_sunsetting:int = 1
var tiles_you_can_see_into_fog_of_war:int = 4
var current_tile_encounter:MapTile
var debug_vision:bool = false
@onready var maptile_spawner_parent:Node2D = $MapTileSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#only checking this on victory, for now
	MapEvents.reward_offered.connect(hide_current_row_and_increment)
	#MapEvents.combat_all_done.connect(hide_current_row_and_increment)
	
	MapEvents.maptile_created.connect(add_to_database)
	MapEvents.map_grid_ready.connect(hide_all_but_tutorial_row)
	MapEvents.venture_to.connect(handle_map_transition)
	MapEvents.reward_offered.connect(fully_cleared_tile)
	HudEvents.rout_chosen.connect(fully_cleared_tile)
	
	maptile_spawner_parent.populate_tiles()

func handle_map_transition(map_tile:MapTile) -> void:
	current_tile_encounter = map_tile
	
	if map_tile.tile_data.enemy:
		MapEvents.enter_combat_in.emit(map_tile)
	else:
		MapEvents.enter_without_combat_in.emit(map_tile)

func hide_current_row_and_increment() -> void:
	if current_tile_encounter.x_coordinate == 1: #tutorial
		hide_first_tutorial_row()
	elif current_tile_encounter.x_coordinate == 2:
		hide_second_tutorial_row()
	else:
		hide_rows()
		current_column_sunsetting += 1

func hide_rows() -> void:
	var furthest_column:int = current_column_sunsetting + tiles_you_can_see_into_fog_of_war
	var enabled_tiles:int = 0
	var disallowed_y_coordinates:Array[int]
	
	for maptile:MapTile in current_map_tiles:
		if maptile.y_coordinate in disallowed_y_coordinates:
			#print_debug("stopping tile: " + str(maptile.x_coordinate) + ", " + str(maptile.y_coordinate))
			continue #skip this tile
		
		if maptile.x_coordinate <= current_column_sunsetting: #permanently disable already past tiles
			maptile.permanently_disable()
		elif maptile.x_coordinate > furthest_column: #disable beyond vision
			maptile.disable()
		elif maptile.x_coordinate <= furthest_column: #note this elif comes after hiding the earlier tiles
			maptile.enable()
		
		if maptile.tile_data.stops_vision and not maptile.currently_disabled:
			disallowed_y_coordinates.append(maptile.y_coordinate)
		
		if not maptile.currently_disabled and not maptile.permanently_disabled:
			enabled_tiles += 1
	
	if enabled_tiles == 0:
		pass
		#push_error("somehow disabled every tile possible")
		#well i know how that happened - you won the chapter
		#but this probably should be a failsafe for otherwise
		#although you can "get into locks" before exhausting all your options
		#eg. delete your items and know you'll lose every fight

func show_rows() -> void:
	for maptile:MapTile in current_map_tiles:
		print_debug(maptile.tile_data.internal_name)
		maptile.permanently_disabled = false
		maptile.enable()

func hide_all_but_tutorial_row() -> void:
	for maptile:MapTile in current_map_tiles:
		maptile.disable()
		if maptile.x_coordinate == 1:
			maptile.enable()

func hide_first_tutorial_row() -> void:
	for maptile:MapTile in current_map_tiles:
		if maptile.x_coordinate == 1:
			maptile.permanently_disable()
		if maptile.x_coordinate == 2:
			maptile.enable()

func hide_second_tutorial_row() -> void:
	current_column_sunsetting = 2
	hide_rows()
	current_column_sunsetting += 1

func add_to_database(new_map_tile:MapTile) -> void:
	current_map_tiles.append(new_map_tile)

func fully_cleared_tile() -> void:
	if current_tile_encounter:
		current_tile_encounter.permanently_disable()
		current_tile_encounter = null

#debug command catcher
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F12:
			if debug_vision:
				debug_vision = false
				hide_rows()
			elif not debug_vision:
				debug_vision = true
				show_rows()
			else: push_error("got confused trying to show/hide rows")
