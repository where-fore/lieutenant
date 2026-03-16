extends Node2D
class_name SaveComponent

## ⚠️ BE YE WARNED! ⚠️
## This title needs to be different from every other saving title in the project,
## or the game won't save properly.
@export var save_category_title:String

var save_function_name:String = "save_data"
var load_function_name:String = "load_data"

@onready var my_parent:Node = self.get_parent()


func _ready() -> void:
	if not my_parent.has_method(save_function_name):
		push_error("save component attached to object with no proper save function")
	else:
		SaveManager.register_saver(save_category_title, self)

func save_data() -> Dictionary:
	return my_parent.call(save_function_name)

func load_data() -> void:
	my_parent.call(load_function_name, SaveManager.get_info_from_loaded_save(save_category_title))
