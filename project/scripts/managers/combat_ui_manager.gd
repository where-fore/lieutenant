extends CanvasLayer

@onready var player_health_label = $"Control/Player/Stats/Health/HBoxContainer/Label" as Label
@onready var enemy_health_label = $"Control/Enemy/Stats/Health/HBoxContainer/Label" as Label

@onready var player_attack_label = $"Control/Player/Stats/Attack/HBoxContainer/Label" as Label
@onready var enemy_attack_label = $"Control/Enemy/Stats/Attack/HBoxContainer/Label" as Label

@onready var player_sprite = $"Control/Player/Sprite"
@onready var enemy_sprite = $"Control/Enemy/Sprite"
@export var turn_sprite: Texture2D
@onready var original_player_sprite = player_sprite.texture
@onready var original_enemy_sprite = enemy_sprite.texture

var current_player = null
var current_enemy = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.player_health_update.connect(update_player_health)
	HudEvents.player_attack_update.connect(update_player_attack)
	HudEvents.enemy_health_update.connect(update_enemy_health)
	HudEvents.enemy_attack_update.connect(update_enemy_attack)
	CombatEvents.turn_finished.connect(update_turn_indicator)
	HudEvents.combat_button_pressed.connect(set_first_turn_indicator)
	

func set_first_turn_indicator():
	player_sprite.texture = turn_sprite
	enemy_sprite.texture = original_enemy_sprite

func clear_turn_indicator():
	player_sprite.texture = original_player_sprite
	enemy_sprite.texture = original_enemy_sprite

func update_turn_indicator():
	if player_sprite.texture == turn_sprite: player_sprite.texture = original_player_sprite
	elif player_sprite.texture == original_player_sprite: player_sprite.texture = turn_sprite
	
	if enemy_sprite.texture == turn_sprite: enemy_sprite.texture = original_enemy_sprite
	elif enemy_sprite.texture == original_enemy_sprite: enemy_sprite.texture = turn_sprite


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
	clear_turn_indicator()
	visible = true

func change_from():
	clear_turn_indicator()
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
