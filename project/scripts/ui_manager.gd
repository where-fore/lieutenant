extends Node2D

@onready var combat_ui_manager = $"Combat UI"
@onready var reward_ui_manager = $"Reward UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward_ui_manager.visible = false
	combat_ui_manager.visible = true
	
	HudEvents.combat_won.connect(end_combat_as_victory)


func end_combat_as_victory():
	reward_ui_manager.visible = true
	combat_ui_manager.visible = false


func initialize_combat_labels(player_combatant, enemy_combatant):
	combat_ui_manager.initialize_labels(player_combatant, enemy_combatant)
