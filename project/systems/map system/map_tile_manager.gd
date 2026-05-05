extends Node2D

var current_map_tiles:Array[MapTile]
var current_column_sunsetting:int = 1
var tiles_you_can_see_into_fog_of_war:int = 4
var current_tile_encounter:MapTile
var debug_vision:bool = false
var camera_has_met_right_edge:bool = false
@onready var maptile_spawner_parent:Node2D = $MapTileSpawner
var scroll_animation_delay:float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapEvents.maptile_created.connect(add_to_database)
	MapEvents.map_grid_ready.connect(hide_all_but_tutorial_row)
	MapEvents.venture_to.connect(handle_map_transition)
	MapEvents.point_of_no_return.connect(enable_adjacent_tiles)
	MapEvents.point_of_no_return.connect(fully_cleared_tile)
	HudEvents.rout_chosen.connect(fully_cleared_tile)
	MapEvents.map_grid_right_edge_reached.connect(clamp_right_edge_scrolling)
	
	maptile_spawner_parent.populate_tiles()

func handle_map_transition(map_tile:MapTile) -> void:
	current_tile_encounter = map_tile
	
	await scroll_camera_check(current_tile_encounter)
	#probably await an animation or something
	
	if map_tile.tile_data.scenario:
		MapEvents.enter_scenario_in.emit(map_tile)
	elif map_tile.tile_data.enemy:
		MapEvents.enter_combat_in.emit(map_tile)
	else:
		MapEvents.enter_without_combat_in.emit(map_tile)

func scroll_camera_check(map_tile:MapTile) -> void:
	var center_of_screen:float = get_viewport_rect().size.x / 8
	var tile_pos:float = map_tile.global_position.x
		#this checks the global position, and all tiles in a column have different x positions
		#due to isometric offset
		#could lead to map scrolling on the top row tile, but not the bottom row tile, confusingly
	if not camera_has_met_right_edge:
		if tile_pos > center_of_screen:
			await scroll_camera(-1 * map_tile.width) #negative because i want the map to go to the left

func scroll_camera(delta_to_scroll:int) -> void:
	var tween:Tween = create_tween()
	var final_position:Vector2 = Vector2(self.position.x + delta_to_scroll, self.position.y)
	tween.tween_property(self, "position", final_position, scroll_animation_delay)
	
	await get_tree().create_timer(scroll_animation_delay).timeout

func enable_adjacent_tiles() -> void:
	if current_tile_encounter:
		var all_tiles:Array[Array] = get_tiles_diagonally_around_tile(current_tile_encounter)
		var valid_tiles:Array[MapTile] = all_tiles[0]
		var invalid_tiles:Array[MapTile] = all_tiles[1]
		
		for map_tile:MapTile in valid_tiles:
			map_tile.enable()
		
		for map_tile:MapTile in invalid_tiles:
			map_tile.disable()

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
		current_tile_encounter.clear_objects_of_interest()
		current_tile_encounter = null

func get_tiles_diagonally_around_tile(tile_to_check:MapTile, range_to_check:int = 1) -> Array[Array]:
	var max_x:int = tile_to_check.x_coordinate + range_to_check
	var min_x:int = tile_to_check.x_coordinate - range_to_check
	var max_y:int = tile_to_check.y_coordinate + range_to_check
	var min_y:int = tile_to_check.y_coordinate - range_to_check
	var valid_tiles:Array[MapTile]
	var invalid_tiles:Array[MapTile]
	
	for map_tile:MapTile in current_map_tiles:
		if map_tile.x_coordinate <= max_x and map_tile.x_coordinate >= min_x:
			if map_tile.y_coordinate <= max_y and map_tile.y_coordinate >= min_y:
				valid_tiles.append(map_tile)
			else: invalid_tiles.append(map_tile)
		else: invalid_tiles.append(map_tile)
	
	return [valid_tiles,invalid_tiles]

func clamp_right_edge_scrolling() -> void:
	camera_has_met_right_edge = true

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
