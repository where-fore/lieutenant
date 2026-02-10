extends CanvasLayer

@onready var player_health_label = $"Stats/Player/Stats/Health/HBoxContainer/Label" as Label
@onready var enemy_health_label = $"Stats/Enemy/Stats/Health/HBoxContainer/Label" as Label

@onready var player_damage_label = $"Stats/Player/Stats/Damage/HBoxContainer/Label" as Label
@onready var enemy_damage_label = $"Stats/Enemy/Stats/Damage/HBoxContainer/Label" as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.player_damaged.connect(update_player_health)
	HudEvents.enemy_damaged.connect(update_enemy_health)


func update_player_health(delta):
	increment_label(player_health_label, delta)

func update_enemy_health(delta):
	increment_label(enemy_health_label, delta)

func increment_label(label, delta):
	label.text = str(int(label.text) + delta)

func initialize_labels(player_combatant, enemy_combatant):
	player_health_label.text = str(int(player_combatant.get_health()))
	enemy_health_label.text = str(int(enemy_combatant.get_health()))
	
	player_damage_label.text = str(int(player_combatant.get_damage()))
	enemy_damage_label.text = str(int(enemy_combatant.get_damage()))
