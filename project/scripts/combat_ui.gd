extends CanvasLayer

@onready var player_health_label = $"Stats/Player/Stats/Health/HBoxContainer/Label" as Label
@onready var enemy_health_label = $"Stats/Enemy/Stats/Health/HBoxContainer/Label" as Label

@onready var player_attack_label = $"Stats/Player/Stats/Attack/HBoxContainer/Label" as Label
@onready var enemy_attack_label = $"Stats/Enemy/Stats/Attack/HBoxContainer/Label" as Label

var current_player = null
var current_enemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.player_damaged.connect(update_player_health)
	HudEvents.enemy_damaged.connect(update_enemy_health)


func update_player_health():
	player_health_label.text = str(int(current_player.get_health()))

func update_enemy_health():
	enemy_health_label.text = str(int(current_enemy.get_health()))

#func increment_label(label, delta):
	#label.text = str(int(label.text) + delta)

func initialize_labels(player_combatant, enemy_combatant):
	#this is called in the main manager
	
	#save these combatant objects for future reference
	current_player = player_combatant
	current_enemy = enemy_combatant
	
	player_health_label.text = str(int(player_combatant.get_health()))
	enemy_health_label.text = str(int(enemy_combatant.get_health()))
	
	player_attack_label.text = str(int(player_combatant.get_attack()))
	enemy_attack_label.text = str(int(enemy_combatant.get_attack()))
