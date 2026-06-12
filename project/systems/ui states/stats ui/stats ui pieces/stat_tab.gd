extends Button
class_name StatTab

@onready var _my_portrait_parent:TextureRect = $MarginContainer/HBoxContainer/Portrait
@onready var _my_label_parent:Label = $MarginContainer/HBoxContainer/Label
var my_info_panel:InfoPanel
signal tab_pressed(tab:StatTab)

func set_info_panel(new_panel:InfoPanel) -> void:
	my_info_panel = new_panel

func setup_from_combatant(combatant:Combatant) -> void:
	set_portrait(combatant.combatant_texture)
	set_label(combatant.combatant_name)

func set_portrait(new_texture:Texture2D) -> void:
	_my_portrait_parent.texture = new_texture

func set_label(new_text:String) -> void:
	_my_label_parent.text = new_text

func clear_data() -> void:
	_my_portrait_parent.texture = null
	_my_label_parent.text = ""
	visible = false

func _on_pressed() -> void:
	tab_pressed.emit(self)
