extends Node2D

@onready var player_combatant = $"Combat Manager/Player Combatant" as Node2D
@onready var enemy_combatant = $"Combat Manager/Enemy Combatant" as Node2D

@onready var ui_manager = $"UI Manager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_manager.initialize_combat_labels(player_combatant, enemy_combatant)


func _on_button_pressed() -> void:
	HudEvents.combat_button_pressed.emit()


# debug stuff
@onready var label = $"UI Manager/Debug UI/Turn"
var prefix = "turn: " as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = prefix + str($"Combat Manager".turn)
