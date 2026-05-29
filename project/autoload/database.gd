extends Node

var all_rewards:Dictionary[String, Reward]
var all_combatants:Dictionary[String, Combatant]
const ITEMS_PATH:String = "res://z individual pieces/items/all items/"
const AURAS_PATH:String = "res://z individual pieces/auras/standalone auras/"
const COMBATANTS_PATH:String = "res://z individual pieces/combatants/"

func _ready() -> void:
	populate_reward_database(read_database_from_folder(ITEMS_PATH))
	populate_reward_database(read_database_from_folder(AURAS_PATH))
	populate_combatant_database(read_database_from_folder(COMBATANTS_PATH))

func get_reward_by_id(reward_id:String) -> Reward:
	var reward:Reward = all_rewards.get(reward_id)
	if not reward: push_error("no reward found with id: " + reward_id)
	return reward.duplicate()

func get_combatant_by_id(combatant_id:String) -> Combatant:
	var data:Combatant = all_combatants.get(combatant_id)
	if not data: push_error("no combatant found with id: " + combatant_id)
	return data.duplicate()


#these could be a bit slow with 1000+ items
#if causing problems, can instead create an array of dictionaries on init, one for each category
#so calling from that array is O(1)
#but then the dictionaries are static on game start, can't do something like adjusting the rarity
#on the fly when you see the oracle or something
#also, note they are creating duplicates of every item whenever you ask for any item of the same rarity
func get_rewards_by_category(category_title:StringName, category_names:Array[int]) -> Array[Reward]:
	var rewards_to_return:Array[Reward]
	for reward:Reward in all_rewards.values():
		if reward.reward_categories.has(category_title):
			for category_header:int in category_names:
				if reward.reward_categories[category_title] == category_header:
					rewards_to_return.append(reward.duplicate())
	return rewards_to_return

func get_combatants_by_category(category_title:StringName, category_names:Array[int]) -> Array[Combatant]:
	var combatants_to_return:Array[Combatant]
	for data:Combatant in all_combatants.values():
		if data.combatant_categories.has(category_title):
			for category_header:int in category_names:
				if data.combatant_categories[category_title] == category_header:
					combatants_to_return.append(data.duplicate())
	return combatants_to_return

func populate_reward_database(resource_array:Array[Resource]) -> void:
	for instantiated_script:Resource in resource_array:
		var reward_instance:Reward = instantiated_script.new()
		reward_instance.resource_path_id = instantiated_script.resource_path.get_file().get_basename()
		all_rewards[reward_instance.resource_path_id] = reward_instance

func populate_combatant_database(resource_array:Array[Resource]) -> void:
	for instantiated_script:Resource in resource_array:
		var combatant_data_instance:Combatant = instantiated_script.new()
		combatant_data_instance.resource_path_id = instantiated_script.resource_path.get_file().get_basename()
		all_combatants[combatant_data_instance.resource_path_id] = combatant_data_instance
		#print_debug("read and created combatant to database: " + combatant_data_instance.combatant_id)

func read_database_from_folder(folder_path:String) -> Array[Resource]:
	var dir:DirAccess = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
	
		var returned_resources:Array[Resource]
		while file_name != "":
			#.gdc is compressed, used in web versions (i think)
			if file_name.ends_with(".gd") or file_name.ends_with(".gdc"):
				var full_path:String = folder_path + file_name
				var loaded_script:Resource = load(full_path)
				returned_resources.append(loaded_script)
			
			file_name = dir.get_next()
		return returned_resources
	else:
		push_error("could not open items directory at: " + folder_path)
		return []
