extends TextureButton
class_name StatTab

@onready var _my_portrait_parent:TextureRect = $MarginContainer/HBoxContainer/Portrait
@onready var _my_label_parent:Label = $MarginContainer/HBoxContainer/Label

func set_portrait(new_texture:Texture2D) -> void:
	_my_portrait_parent.texture = new_texture

func set_label(new_text:String) -> void:
	_my_label_parent.text = new_text

func clear_data() -> void:
	_my_portrait_parent.texture = null
	_my_label_parent.text = ""
	visible = false

func _on_pressed() -> void:
	print_debug(name)
	pass # Replace with function body.
	#change to the panel or something
