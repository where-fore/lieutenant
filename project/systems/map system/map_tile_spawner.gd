extends Node2D

@export_category("Map Tile Information")
@export var generic_border_data:GDScript
@export var boss_special_tile:GDScript
@export var rest_tiles:Array[GDScript]
@export var common_combat_tile:GDScript
@export var rare_combat_tile:GDScript
@export var tutorial_fetch_tile:GDScript
@export var tutorial_unique_tile:GDScript

@export_category("Map Grid Builder")
@export var mapTileBase:PackedScene
@export var rows:int = 3
@export var vertical_spacing:int = 17
@export var columns:int = 17
@export var horizontal_spacing:int = 31
@export var isometric_offset:int = 6
@export_enum("Top Left", "Bottom Left") var this_spawner_is_placed_at:int = 0
@export var columns_to_disable_at_end:int = 4
@export var columns_to_disable_at_start:int = 1

var first_rewards:Array[Item]
var tutorial_fetch_rewards:Array[Item]

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
			MapEvents.maptile_created.emit(new_tile)
	MapEvents.map_grid_ready.emit()

func populate_tile_data(tile:MapTile) -> void:
	var this_tile_power:int = tile.x_coordinate - columns_to_disable_at_start
	tile.power = this_tile_power - 1 #ignoring 1 tile, for the tutorial is the first tile
	
	#final boss stretch
	if tile.x_coordinate == columns - columns_to_disable_at_end - 1: #the last column
		if tile.y_coordinate == 0 or tile.y_coordinate == 2:
			tile.apply_data(generic_border_data.new())
			tile.permanently_disable()
		elif tile.y_coordinate == 1:
			tile.apply_data(boss_special_tile.new())
			tile.mark_as_boss()
	
	#first and last rows, the borders
	elif tile.x_coordinate == (columns_to_disable_at_start - 1) or tile.x_coordinate >= columns - columns_to_disable_at_end:
		tile.apply_data(generic_border_data.new())
		tile.permanently_disable()
	
	#tutorial: first encounter (fetch quest)
	elif tile.x_coordinate == columns_to_disable_at_start:
		tile.apply_data(tutorial_fetch_tile.new())
		tile.tile_data.item_reward = tutorial_fetch_rewards.pop_front()
	
	#tutorial: first encounter (unique)
	elif tile.x_coordinate == columns_to_disable_at_start + 1:
		tile.apply_data(tutorial_unique_tile.new())
		
		if first_rewards.size() == 0:
			push_error("reached end of items of this rarity before reached end of special tiles")
			populate_first_rewards()
		tile.tile_data.item_reward = first_rewards.pop_front()
	
	#scaling bandaid: first fight is common reward
	elif tile.x_coordinate == columns_to_disable_at_start + 2:
		tile.apply_data(common_combat_tile.new())
	
	#everything else
	else:
		tile.apply_data(choose_filler_tile())
	
	if tile.tile_data.enemy:
		tile.tile_data.enemy.scale_stats(tile.power) 

func populate_first_rewards() -> void:
	var all_of_rarity:Array[Item] = Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.MYTHIC])
	all_of_rarity.shuffle()
	first_rewards = all_of_rarity

func populate_tutorial_fetch_rewards() -> void:
	tutorial_fetch_rewards.append(Database.get_item_by_id("old_mans_ring"))
	for row:int in rows - 1: #fill rest of rows with a rock
		tutorial_fetch_rewards.append(Database.get_item_by_id("worthless_ring"))
	tutorial_fetch_rewards.shuffle()

func choose_filler_tile() -> MapTileData:
	var random_roll:int = randi_range(1, 100)
	var hut_chance:int = 40
	if random_roll <= hut_chance:
		return rest_tiles.pick_random().new() as MapTileData
	else:
		return choose_rare_or_common_combat()

func choose_rare_or_common_combat() -> MapTileData:
	var random_roll:int = randi_range(1, 100)
	var rare_chance:int = 40
	if random_roll <= rare_chance:
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
