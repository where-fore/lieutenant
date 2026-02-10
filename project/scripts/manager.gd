extends Node2D

@onready var player_combatant = $"Combat Manager/Player Combatant" as Node2D
@onready var enemy_combatant = $"Combat Manager/Enemy Combatant" as Node2D

@onready var ui_manager = $"Combat UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_manager.initialize_labels(player_combatant, enemy_combatant)


func _on_button_pressed() -> void:
	HudEvents.turn_button_pressed.emit()
