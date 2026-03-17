extends Node2D
class_name SaveComponent

#this don't be workin yet
#good start to a save/load system though - it's basically there



## ⚠️ BE YE WARNED! ⚠️
## This title needs to be different from every other saving title in the project,
## or the game won't save properly.
@export var save_category_title:String = "Mysterious, Unnamed Data"

var save_function_name:String = "save_data"
var register_function_name:String = "register_save_component"

@onready var my_parent:Node = self.get_parent()


func _ready() -> void:
	if not my_parent.has_method(register_function_name):
		push_error("save component attached to object with no proper registration function")
		self.queue_free()
	my_parent.call(register_function_name, self)
	
	if not my_parent.has_method(save_function_name):
		push_error("save component attached to object with no proper save function")
		self.queue_free()
	
	SaveManager.register_saver(save_category_title, self)

func save_data() -> Array:
	return my_parent.call(save_function_name)

func load_data_from_manager() -> Array:
	return SaveManager.get_info_from_loaded_save(save_category_title)


# here be boilerplate for parents
#var saving_component:SaveComponent

#func save_data() -> Dictionary:
	#var data:Dictionary
	#return data

#func register_save_component(component:SaveComponent) -> void:
	#saving_component = component
