extends Node

var all_items:Dictionary[String, Item]
const ITEMS_PATH:String = "res://items/all items/"

func _ready() -> void:
	populate_database_from_folder(ITEMS_PATH)

func get_item_by_id(item_id:String) -> Item:
	var item:Item = all_items.get(item_id)
	return item.duplicate()

func get_items_by_category(category:StringName) -> Array[Item]:
	push_error("function not setup: " + category)
	return [Item.new()]

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
	
