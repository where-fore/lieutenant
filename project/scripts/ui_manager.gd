extends Node2D

@onready var combat_ui_manager = $"Combat UI"
@onready var reward_ui_manager = $"Reward UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward_ui_manager.visible = false
	combat_ui_manager.visible = true
	
	HudEvents.combat_won.connect(end_combat_as_victory)
	HudEvents.reward_chosen.connect(end_rewards_screen)


func end_combat_as_victory():
	reward_ui_manager.change_to()
	combat_ui_manager.change_from()


func end_rewards_screen():
	reward_ui_manager.change_from()
	combat_ui_manager.change_to()


func initialize_combat_labels(player_combatant, enemy_combatant):
	combat_ui_manager.initialize_labels(player_combatant, enemy_combatant)
