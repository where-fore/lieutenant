extends Control

var current_encounter_is_lethal:bool = false

func _ready() -> void:
	MapEvents.venture_to.connect(check_if_lethal_encounter)

func check_if_lethal_encounter(map_tile:MapTile) -> void:
	current_encounter_is_lethal = map_tile.lethal_encounter

func change_to() -> void:
	visible = true
	if current_encounter_is_lethal:
		HudEvents.chapter_lost.emit()
		change_from()

func change_from() -> void:
	visible = false

func _on_restart_button_pressed() -> void:
	change_from()
	HudEvents.rout_chosen.emit()
