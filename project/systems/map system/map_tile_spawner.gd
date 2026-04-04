extends Node2D

@export_category("Map Tile Information")
@export var generic_border_data:GDScript
@export var first_special_tile:GDScript
@export var boss_special_tile:GDScript
@export var rest_tiles:Array[GDScript]
@export var common_combat_tile:GDScript
@export var rare_combat_tile:GDScript

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_if_tile_export_set_correctly()
	choose_first_rewards()

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
	tile.power = this_tile_power
	
	#final boss stretch
	if tile.x_coordinate == columns - columns_to_disable_at_end - 1: #the last column
		if tile.y_coordinate == 0 or tile.y_coordinate == 2:
			tile.apply_data(generic_border_data.new())
			tile.permanently_disable()
		elif tile.y_coordinate == 1:
			tile.apply_data(boss_special_tile.new())
			tile.mark_as_boss()
	
	#first and last rows
	elif tile.x_coordinate == (columns_to_disable_at_start - 1) or tile.x_coordinate >= columns - columns_to_disable_at_end:
		tile.apply_data(generic_border_data.new())
		tile.permanently_disable()
	
	#special "first" row of gameplay
	elif tile.x_coordinate == columns_to_disable_at_start:
		tile.apply_data(first_special_tile.new())
		
		if first_rewards.size() == 0:
			push_error("reached end of items of this rarity before reached end of special tiles")
			choose_first_rewards()
		tile.tile_data.item_reward = first_rewards.pop_front()
	
	#everything else
	else:
		tile.apply_data(choose_filler_tile())
	
	if tile.tile_data.enemy:
		tile.tile_data.enemy.scale_stats(tile.power) 

func check_if_tile_export_set_correctly() -> void:
	var arrays_to_check:Array[Array] = [rest_tiles]
	var individual_scripts_to_check:Array[GDScript] = [generic_border_data, first_special_tile, boss_special_tile, common_combat_tile, rare_combat_tile]
	for array:Array[GDScript] in arrays_to_check:
		if array.has(null) or array.is_empty():
			push_error("map tile data not set correctly on spawner")
	for script:GDScript in individual_scripts_to_check:
		if script == null:
			push_error("map tile data not set correctly on spawner")

func choose_first_rewards() -> void:
	var all_of_rarity:Array[Item] = Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.MYTHIC])
	all_of_rarity.shuffle()
	first_rewards = all_of_rarity

func choose_filler_tile() -> MapTileData:
	var random_roll:int = randi_range(1, 100)
	var hut_chance:int = 30
	if random_roll <= hut_chance:
		return rest_tiles.pick_random().new() as MapTileData
	else:
		return choose_rare_or_common_combat()

func choose_rare_or_common_combat() -> MapTileData:
	var random_roll:int = randi_range(1, 100)
	var rare_chance:int = 30
	if random_roll <= rare_chance:
		return rare_combat_tile.new() as MapTileData
	else:
		return common_combat_tile.new() as MapTileData
