extends Control

@onready var edit_border:TextureRect = $EditBorder
var current_encounter_is_lethal:bool = false

func _ready() -> void:
	MapEvents.venture_to.connect(check_if_lethal_encounter)
	
	edit_border.visible = false

func check_if_lethal_encounter(map_tile:MapTile) -> void:
	current_encounter_is_lethal = map_tile.lethal_encounter

func change_to() -> void:
	HudEvents.load_portrait_ui.emit()
	visible = true
	if current_encounter_is_lethal:
		HudEvents.chapter_lost.emit()
		change_from()

func change_from() -> void:
	HudEvents.unload_portrait_ui.emit()
	visible = false

func _on_restart_button_pressed() -> void:
	change_from()
	HudEvents.rout_chosen.emit()
