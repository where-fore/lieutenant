extends Node

var all_items:Dictionary[String, Item]
var all_combatants:Dictionary[String, CombatantData]
const ITEMS_PATH:String = "res://z individual pieces/items/all items/"
const COMBATANTS_PATH:String = "res://z individual pieces/combatants/"

func _ready() -> void:
	populate_item_database(read_database_from_folder(ITEMS_PATH))
	populate_combatant_database(read_database_from_folder(COMBATANTS_PATH))

func get_item_by_id(item_id:String) -> Item:
	var item:Item = all_items.get(item_id)
	return item.duplicate()
	
func get_combatant_by_id(combatant_id:String) -> Item:
	var data:CombatantData = all_combatants.get(combatant_id)
	return data.duplicate()


#these could be a bit slow with 1000+ items
#if causing problems, can instead create an array of dictionaries on init, one for each category
#so calling from that array is O(1)
func get_items_by_category(category:StringName) -> Array[Item]:
	var items_to_return:Array[Item]
	for item:Item in all_items.values():
		if item.item_categories.has(category):
			items_to_return.append(item)
	return items_to_return

func get_combatants_by_category(category:StringName) -> Array[CombatantData]:
	var combatants_to_return:Array[CombatantData]
	for data:CombatantData in all_items.values():
		if data.categories.has(category):
			combatants_to_return.append(data)
	return combatants_to_return

func populate_item_database(resource_array:Array[Resource]) -> void:
	for instantiated_script:Resource in resource_array:
		var item_instance:Item = instantiated_script.new()
		all_items[item_instance.item_id] = item_instance
		#print_debug("Loaded item: ", item_instance.item_id)

func populate_combatant_database(resource_array:Array[Resource]) -> void:
	for instantiated_script:Resource in resource_array:
		var combatant_data_instance:CombatantData = instantiated_script.new()
		all_combatants[combatant_data_instance.id] = combatant_data_instance
		#print_debug("Loaded combatant: ", combatant_data_instance.id)

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
