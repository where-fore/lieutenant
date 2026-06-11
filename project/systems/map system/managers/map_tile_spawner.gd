extends Node2D

@export_category("Map Tile Information")
@export var generic_border_data:GDScript
@export var boss_special_tile:GDScript
@export var common_combat_tile:GDScript
@export var uncommon_combat_tile:GDScript
@export var rare_combat_tile:GDScript
@export var tutorial_first_common_tile:GDScript
@export var tutorial_first_combat_tile:GDScript
@export var tutorial_second_combat_tile:GDScript
@export var tutorial_camp_tile:GDScript
@export var knight_join_tile:GDScript
@export var tutorial_unique_tile:GDScript
@export var developer_testing_ground:GDScript

@export_category("Map Grid Builder")
@export var mapTileBase:PackedScene
@export var rows:int = 3
@export var vertical_spacing:int = 17
@export var columns:int = 25
@export var horizontal_spacing:int = 31
@export var isometric_offset:int = 6
@export_enum("Top Left", "Bottom Left") var this_spawner_is_placed_at:int = 0
@export var columns_to_disable_at_end:int = 1
@export var columns_to_disable_at_start:int = 1

@export_category("Other")
@export var map_edge_notifier:PackedScene

var first_rewards:Array[Reward]
var tutorial_fetch_rewards:Array[Reward]

var rare_roll_entropy:int

var current_chunk:Array[MapTileData]

var spawn_developer_target_dummy:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	validate_exports()
	populate_first_rewards()
	populate_tutorial_fetch_rewards()

#note that this does do not do any z-indexing, and defaults to godot tree hierarchy z-indexing
#the first tiles created here will be drawn to screen last
#and thus if you start spawning from the top left of your final grid:
#the bottom rows will draw over the top rows
#the right-hand rows will draw over the left-hand rows
func populate_tiles() -> void:
	create_edge_notifier(true)
	
	for x:int in columns:
		for y:int in rows:
			var new_tile:MapTile = mapTileBase.instantiate()
			add_child(new_tile)
			
			if this_spawner_is_placed_at == 0: #this an enum index, 0 being the first option
				new_tile.position = Vector2(x * horizontal_spacing - y * isometric_offset, y * vertical_spacing)
			elif this_spawner_is_placed_at == 1:
				new_tile.position = Vector2(x * horizontal_spacing + y * isometric_offset, rows-y * vertical_spacing)
			
			new_tile.width = horizontal_spacing
			new_tile.x_coordinate = x
			new_tile.y_coordinate = y
			populate_tile_data(new_tile)
			MapEvents.maptile_created.emit(new_tile)
	
	create_edge_notifier(false)
	
	MapEvents.map_grid_ready.emit()

func populate_tile_data(tile:MapTile) -> void:
	#var this_tile_power:int = tile.x_coordinate - columns_to_disable_at_start
	#tile.power = this_tile_power - 1 #ignoring 1 tile, for the tutorial is the first tile
	
	#final boss stretch
	if tile.x_coordinate == columns - columns_to_disable_at_end - 1: #the last column
		if tile.y_coordinate == 0 or tile.y_coordinate == 2:
			tile.apply_data(generic_border_data.new())
		elif tile.y_coordinate == 1:
			tile.apply_data(boss_special_tile.new())
	
	#first and last rows, the borders
	elif tile.x_coordinate == (columns_to_disable_at_start - 1) or tile.x_coordinate >= columns - columns_to_disable_at_end:
		tile.apply_data(generic_border_data.new())
	
	#tutorial: first encounter (first combat)
	elif tile.x_coordinate == columns_to_disable_at_start:
		if tile.y_coordinate == 0 or tile.y_coordinate == 2:
			tile.apply_data(generic_border_data.new())
		elif tile.y_coordinate == 1:
			tile.apply_data(tutorial_first_combat_tile.new())
	
	#tutorial: second row (wolves, camp)
	elif tile.x_coordinate == columns_to_disable_at_start + 1:
		if tile.y_coordinate == 0:
			tile.apply_data(knight_join_tile.new())
		elif tile.y_coordinate == 1:
			tile.apply_data(tutorial_second_combat_tile.new())
		elif tile.y_coordinate == 2:
			tile.apply_data(tutorial_camp_tile.new())
	
	#tutorial: first encounter (first loss)
	elif tile.x_coordinate == columns_to_disable_at_start + 2:
		tile.apply_data(tutorial_unique_tile.new())
		
		if first_rewards.size() == 0:
			push_error("reached end of items of this rarity before reached end of special tiles")
			populate_first_rewards()
		tile.tile_data.rewards = [first_rewards.pop_front()]
	
	#everything else
	else:
		tile.apply_data(choose_filler_tile())
	
	#maybe spawn a testing tile
	if spawn_developer_target_dummy and tile.x_coordinate == columns_to_disable_at_start and tile.y_coordinate == 0:
		tile.apply_data(developer_testing_ground.new())
		tile.permanently_enable()
		spawn_developer_target_dummy = false

func create_edge_notifier(is_left_edge:bool) -> void:
	var new_map_edge_notifier:MapEdgeNotifier = map_edge_notifier.instantiate() as MapEdgeNotifier
	
	if is_left_edge:
		new_map_edge_notifier.is_left_side_edge = true
	else:
		new_map_edge_notifier.is_right_side_edge = true
			#change position to after the last tile
			#not sure how to get the position of the last tile column
			#just going to guess for now
		new_map_edge_notifier.position.x = (columns-2) * horizontal_spacing
			#2 steps earlier, since
			#i want it to notify on before the last tile, not on the last tile
			#and the first tile is at 0, not at 1*horizontal spacing, and column*spacing starts at 1*spacing
	
	add_child(new_map_edge_notifier)

func populate_first_rewards() -> void:
	var all_of_rarity:Array[Reward] = Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.RARE])
	all_of_rarity.shuffle()
	first_rewards = all_of_rarity

func populate_tutorial_fetch_rewards() -> void:
	var choice:int = randi_range(1,2)
	
	var possible_big_reward:Array[Item] = [Database.get_reward_by_id("iron_sword"), Database.get_reward_by_id("iron_axe")]
	var big_reward:Item
	if choice == 1:
		big_reward = possible_big_reward[0]
	if choice == 2:
		big_reward = possible_big_reward[1]
		
	tutorial_fetch_rewards.append(big_reward)
	
	var possible_small_reward:Array[Item] = [Database.get_reward_by_id("iron_dirk"), Database.get_reward_by_id("iron_handaxe")]
	var small_reward:Item
	if choice == 1:
		small_reward = possible_small_reward[0]
	if choice == 2:
		small_reward = possible_small_reward[1]
	
	for row:int in rows - 1: #fill rest of rows with a rock
		tutorial_fetch_rewards.append(small_reward.duplicate())
	
	
	tutorial_fetch_rewards.shuffle()


func choose_filler_tile() -> MapTileData:
	return choose_randomly()

func choose_randomly() -> MapTileData:
	var common_chance:int = 40
	var uncommon_chance:int = 20
	var rare_chance:int = 40
	
	if common_chance + uncommon_chance + rare_chance != 100:
		push_error("map tile chances not summing to 100% chance!")
	
	var chosen_blueprint:GDScript
	var roll:int = randi_range(1, 100)
	if roll > 100 - rare_chance:
		chosen_blueprint = rare_combat_tile
	elif roll > 100 - rare_chance - uncommon_chance:
		chosen_blueprint = uncommon_combat_tile
	elif roll > 100 - rare_chance - uncommon_chance - common_chance:
		chosen_blueprint = common_combat_tile
	else:
		push_error("rolled ", roll, " and not sure what to do with it")
	
	return chosen_blueprint.new() as MapTileData

func choose_from_chunk() -> MapTileData:
	if not current_chunk:
		current_chunk = create_chunk()
	var this_tile:MapTileData = current_chunk.pop_front()
	return this_tile

func create_chunk() -> Array[MapTileData]:
	var this_chunk:Array[MapTileData]
	var current_row:int = 1
	var rows_in_chunk:int = rows
	var current_column:int = 1
	var columns_in_chunk:int = 4
	while current_column <= columns_in_chunk:
		while current_row <= rows_in_chunk:
			#first row
			if current_column == 1:
				this_chunk.append(common_combat_tile.new())
			#rest of non-first non-last rows
			elif current_column < columns_in_chunk and not current_column == columns_in_chunk:
				this_chunk.append(uncommon_combat_tile.new())
			#last row
			elif current_column == columns_in_chunk:
				this_chunk.append(rare_combat_tile.new())
			current_row += 1
		current_column += 1
		current_row = 1
	
	return this_chunk

func choose_rare_or_common_combat() -> MapTileData:
	var rare_chance:int = 15
	rare_roll_entropy += rare_chance
	var random_roll:int = randi_range(1, 100)
	if random_roll <= rare_roll_entropy:
		rare_roll_entropy = 0
		return rare_combat_tile.new() as MapTileData
	else:
		return common_combat_tile.new() as MapTileData

func validate_exports() -> void:
	var properties:Array[Dictionary] = get_property_list()
	
	for property:Dictionary in properties:
		# PROPERTY_USAGE_EDITOR means it shows up in the inspector (is an export)
		# PROPERTY_USAGE_SCRIPT_VARIABLE means it's part of this script, not the base node
		if property.usage & PROPERTY_USAGE_EDITOR and property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var property_name:String = property["name"]
			var actual_exported:Variant = self.get(property_name)
			var my_name:String = self.name
			var error_message:String = "Export \"%s\" is not set in editor on node %s" % [property.name, my_name]
			match typeof(actual_exported):
				TYPE_OBJECT:
					if actual_exported == null or not is_instance_valid(actual_exported):
						push_error(error_message)
				TYPE_STRING, TYPE_ARRAY, TYPE_DICTIONARY, TYPE_NODE_PATH:
					if actual_exported.is_empty():
						push_error(error_message)
				TYPE_NIL:
					push_error(error_message)
