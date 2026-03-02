extends CanvasLayer

@onready var player_health_label = $"Control/Player/Stats/Health/HBoxContainer/Label" as Label
@onready var enemy_health_label = $"Control/Enemy/Stats/Health/HBoxContainer/Label" as Label

@onready var player_attack_label = $"Control/Player/Stats/Attack/HBoxContainer/Label" as Label
@onready var enemy_attack_label = $"Control/Enemy/Stats/Attack/HBoxContainer/Label" as Label

@onready var combat_button = $"Control/Combat Button"

@onready var turn_buttons = $"Control/Turn Buttons"
@onready var pause_button_border = $"Control/Turn Buttons/Pause Button/TextureRect"
#i removed the texture here from the step border, cause i realized turns are basically instant and this doesn't do anything
#could add button pressed feedback instead of this border stuff
@onready var step_button_border = $"Control/Turn Buttons/Step Button/TextureRect"
@onready var play_button_border = $"Control/Turn Buttons/Play Button/TextureRect"

@onready var player_sprite_display = $"Control/Player/Sprite"
@onready var enemy_sprite_display = $"Control/Enemy/Sprite"
@export var turn_sprite: Texture2D
@onready var original_player_sprite = player_sprite_display.texture
@onready var original_enemy_sprite = enemy_sprite_display.texture

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
	HudEvents.send_enemy_sprite.connect(update_enemy_sprite)
	TimingEvents.everythings_ready.connect(on_scene_ready)
	
	turn_buttons.visible = false

func on_scene_ready():
	HudEvents.ask_for_enemy_sprite.emit()

func set_first_turn_indicator():
	player_sprite_display.texture = turn_sprite
	enemy_sprite_display.texture = original_enemy_sprite

func clear_turn_indicator():
	player_sprite_display.texture = original_player_sprite
	enemy_sprite_display.texture = original_enemy_sprite

func update_turn_indicator():
	if player_sprite_display.texture == turn_sprite: player_sprite_display.texture = original_player_sprite
	elif player_sprite_display.texture == original_player_sprite: player_sprite_display.texture = turn_sprite
	
	if enemy_sprite_display.texture == turn_sprite: enemy_sprite_display.texture = original_enemy_sprite
	elif enemy_sprite_display.texture == original_enemy_sprite: enemy_sprite_display.texture = turn_sprite
	
	step_button_border.visible = false


func update_player_health(value):
	player_health_label.text = str(int(value))

func update_enemy_health(value):
	enemy_health_label.text = str(int(value))

func update_player_attack(value):
	player_attack_label.text = str(int(value))

func update_enemy_attack(value):
	enemy_attack_label.text = str(int(value))
	
func update_enemy_sprite(new_texture):
	original_enemy_sprite = new_texture
	enemy_sprite_display.texture = original_enemy_sprite


func change_to():
	HudEvents.change_to_combat_screen.emit()
	clear_turn_indicator()
	combat_button.visible = true
	pause_button_border.visible = false
	step_button_border.visible = false
	play_button_border.visible = false
	turn_buttons.visible = false
	visible = true

func change_from():
	clear_turn_indicator()
	visible = false

func _on_combat_button_pressed() -> void:
	HudEvents.combat_button_pressed.emit()
	combat_button.visible = false
	turn_buttons.visible = true

func _on_pause_button_pressed() -> void:
	step_button_border.visible = false
	pause_button_border.visible = true
	play_button_border.visible = false
	CombatEvents.pause_button_pressed.emit()

func _on_step_button_pressed() -> void:
	step_button_border.visible = true
	pause_button_border.visible = false
	play_button_border.visible = false
	CombatEvents.step_button_pressed.emit()

func _on_play_button_pressed() -> void:
	step_button_border.visible = false
	pause_button_border.visible = false
	play_button_border.visible = true
	CombatEvents.play_button_pressed.emit()
