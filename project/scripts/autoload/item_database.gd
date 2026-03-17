extends Node

var all_items:Dictionary[String, Item]
const ITEMS_PATH:String = "res://items/all items/"

func _ready() -> void:
	populate_database_from_folder(ITEMS_PATH)

func get_item_by_id(item_id:String) -> Item:
	var item:Item = all_items.get(item_id)
	return item.duplicate()


#this is a bit slow with 1000+ items
#if causing problems, can instead create an array of dictionaries on init, one for each category
#so calling from that array is O(1)
func get_items_by_category(category:StringName) -> Array[Item]:
	var items_to_return:Array[Item]
	for item:Item in all_items.values():
		if item.item_categories.has(category):
			items_to_return.append(item)
	return items_to_return

func populate_database_from_folder(path:String) -> void:
	var dir:DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()

		while file_name != "":
			if file_name.ends_with(".gd"):
				var full_path:String = path + file_name
				var item_script:Resource = load(full_path)
				
				if item_script:
					var item_instance:Item = item_script.new()
					all_items[item_instance.item_id] = item_instance
					#print_debug("Loaded item: ", item_instance.item_id)
			
			file_name = dir.get_next()
	else:
		push_error("could not open items directory at: " + path)
	
