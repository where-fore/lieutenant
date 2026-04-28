extends TextureButton
class_name StatTab

@onready var _my_portrait_parent:TextureRect = $MarginContainer/HBoxContainer/Portrait
@onready var _my_label_parent:Label = $MarginContainer/HBoxContainer/Label

func set_portrait(new_texture:Texture2D) -> void:
	_my_portrait_parent.texture = new_texture

func set_label(new_text:String) -> void:
	_my_label_parent.text = new_text
