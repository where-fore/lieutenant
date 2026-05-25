extends Node2D

var current_map_tiles:Array[MapTile]
var current_column_sunsetting:int = 1
var tiles_you_can_see_into_fog_of_war:int = 4
var current_tile_encounter:MapTile
var debug_vision:bool = false
var map_should_scroll_right:bool = true
var map_should_scroll_left:bool = true
@onready var maptile_spawner_parent:Node2D = $MapTileSpawner
var scroll_animation_delay:float = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapEvents.maptile_created.connect(add_to_database)
	MapEvents.map_grid_ready.connect(hide_all_but_tutorial_row)
	MapEvents.venture_to.connect(handle_map_transition)
	MapEvents.tile_completed_new_ground.connect(set_visited_on_current_tile)
	MapEvents.tile_completed_new_ground.connect(enable_adjacent_tiles)
	MapEvents.tile_completed_new_ground.connect(fully_cleared_tile)
	MapEvents.tile_completed_no_new_ground.connect(enable_adjacent_tiles_already_visited)
	MapEvents.map_grid_right_edge_visible.connect(check_to_clamp_right_edge_scrolling)
	MapEvents.map_grid_left_edge_visible.connect(check_to_clamp_left_edge_scrolling)
	TimeOfDay.new_day.connect(refresh_tiles_for_new_day)
	
	maptile_spawner_parent.populate_tiles()

func refresh_tiles_for_new_day() -> void:
	#maybe for performance i should do a more thorough filter
	#something like only checking "active" tiles? not-permanently disabled tiles?
	#currently just iterating over every single map tile for completeness, with no performance problem atm
	for tile:MapTile in current_map_tiles:
		tile.new_day_check()

func handle_map_transition(map_tile:MapTile) -> void:
	current_tile_encounter = map_tile
	
	await scroll_map_check(current_tile_encounter)
	#probably await an animation or something
	
	map_tile.encounter_this_tile()

func scroll_map_check(map_tile:MapTile) -> void:
	var right_scroll_threshold:float = get_viewport_rect().size.x * 0.6
	var left_scroll_threshold:float = get_viewport_rect().size.x * 0.4
	var tile_pos:float = map_tile.global_position.x
		#this checks the global position, and all tiles in a column have different x positions,
		#due to isometric offset
		#could lead to map scrolling on the top row tile, but not the bottom row tile, confusingly
	
	if map_should_scroll_right:
		if tile_pos > right_scroll_threshold:
			await scroll_map(-1 * map_tile.width) #negative because i want the map to go to the left
			MapEvents.map_scrolled_right.emit()
	if map_should_scroll_left:
		if tile_pos < left_scroll_threshold:
			await scroll_map(1 * map_tile.width) #positive because i want the map to go to the right
			MapEvents.map_scrolled_left.emit()

func scroll_map(delta_to_scroll:int) -> void:
	var tween:Tween = create_tween()
	var final_position:Vector2 = Vector2(self.position.x + delta_to_scroll, self.position.y)
	tween.tween_property(self, "position", final_position, scroll_animation_delay)
	
	await get_tree().create_timer(scroll_animation_delay).timeout

func enable_adjacent_tiles(already_visited_only:bool = false) -> void:
	if current_tile_encounter:
		var all_tiles:Array[Array] = get_tiles_diagonally_around_tile(current_tile_encounter)
		var valid_tiles:Array[MapTile] = all_tiles[0]
		var invalid_tiles:Array[MapTile] = all_tiles[1]
		
		for map_tile:MapTile in valid_tiles:
			if already_visited_only and not map_tile.player_has_been_here and not map_tile == current_tile_encounter:
				invalid_tiles.append(map_tile)
			else:
				map_tile.enable()
		
		for map_tile:MapTile in invalid_tiles:
			map_tile.disable()

func enable_adjacent_tiles_already_visited() -> void:
	enable_adjacent_tiles(true)

func set_visited_on_current_tile() -> void:
	if not current_tile_encounter:
		push_warning("finished up on a tile, tried to set it to complete, but i have no tile in memory")
	else:
		current_tile_encounter.player_has_been_here = true

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

func check_to_clamp_right_edge_scrolling(saw_edge:bool) -> void:
	if saw_edge:
		map_should_scroll_right = false
	else:
		map_should_scroll_right = true

func check_to_clamp_left_edge_scrolling(saw_edge:bool) -> void:
	if saw_edge:
		map_should_scroll_left = false
	else:
		map_should_scroll_left = true

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
