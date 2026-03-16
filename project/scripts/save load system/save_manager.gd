extends Node2D

var all_savers:Dictionary[String, SaveComponent]
var master_save_dictionary:Dictionary[String, Dictionary]
var current_loaded_save_dictionary:Dictionary[String, Dictionary]

func register_saver(header:String, node:SaveComponent) -> void:
	while all_savers.has(header):
		push_error("save category naming collision: " + header + " is already taken")
		header += "_failsafe-orphan"
	all_savers[header] = node

func load_game() -> void:
	#take in a load file argument
	#populate the current_loaded_save with that load file
	pass

func save_game() -> void:
	for saver:SaveComponent in all_savers.values():
		master_save_dictionary[saver.save_category_title] = saver.save_data()
	#jsonify: master_dict to temp.json (to prevent overwriting save until ready)
	#file.overwrite(current.json, with temp.json)
	print_debug(master_save_dictionary)

func get_info_from_loaded_save(save_category:String) -> Dictionary:
	if current_loaded_save_dictionary.has(save_category):
		return current_loaded_save_dictionary[save_category]
	else: return {} #blank dictionary, "null"
