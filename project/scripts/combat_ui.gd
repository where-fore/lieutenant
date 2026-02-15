extends CanvasLayer

@onready var player_health_label = $"Stats/Player/Stats/Health/HBoxContainer/Label" as Label
@onready var enemy_health_label = $"Stats/Enemy/Stats/Health/HBoxContainer/Label" as Label

@onready var player_attack_label = $"Stats/Player/Stats/Attack/HBoxContainer/Label" as Label
@onready var enemy_attack_label = $"Stats/Enemy/Stats/Attack/HBoxContainer/Label" as Label

var current_player = null
var current_enemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.player_health_update.connect(update_player_health)
	HudEvents.player_attack_update.connect(update_player_attack)
	HudEvents.enemy_health_update.connect(update_enemy_health)
	HudEvents.enemy_attack_update.connect(update_enemy_attack)


func update_player_health():
	player_health_label.text = str(int(current_player.get_health()))

func update_enemy_health():
	enemy_health_label.text = str(int(current_enemy.get_health()))

func update_player_attack():
	player_attack_label.text = str(int(current_player.get_attack()))

func update_enemy_attack():
	enemy_attack_label.text = str(int(current_enemy.get_attack()))


func change_to():
	HudEvents.change_to_combat_screen.emit()
	visible = true

func change_from():
	visible = false

#this is called in the main manager
func initialize_labels(player_combatant, enemy_combatant):
	
	#save these combatant objects for future reference
	current_player = player_combatant
	current_enemy = enemy_combatant
	
	update_player_health()
	update_enemy_health()
	update_player_attack()
	update_enemy_attack()
