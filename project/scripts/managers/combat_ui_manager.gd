extends CanvasLayer

@onready var player_health_label:Label = $Control/Combatants/Player/Stats/Health/HBoxContainer/Label
@onready var enemy_health_label:Label  = $Control/Combatants/Enemy/Stats/Health/HBoxContainer/Label

@onready var player_attack_label:Label  = $Control/Combatants/Player/Stats/Attack/HBoxContainer/Label
@onready var enemy_attack_label:Label  = $Control/Combatants/Enemy/Stats/Attack/HBoxContainer/Label

@onready var combat_button:Button = $Control/CombatButton

@onready var turn_button_container:Container = $Control/TurnButtons
@onready var pause_button_border:TextureRect = $Control/TurnButtons/PauseButton/TextureRect
#i removed the texture here from the step border, cause i realized turns are basically instant and this doesn't do anything
#could add button pressed feedback instead of this border stuff
@onready var step_button_border:TextureRect = $Control/TurnButtons/StepButton/TextureRect
@onready var play_button_border:TextureRect = $Control/TurnButtons/PlayButton/TextureRect

@onready var player_sprite_display:TextureRect = $Control/Combatants/Player/MarginContainer/Sprite
@onready var enemy_sprite_display:TextureRect = $Control/Combatants/Enemy/MarginContainer/Sprite
@onready var player_turn_sprite:TextureRect = $Control/Combatants/Player/MarginContainer/Sprite/TurnIndicator
@onready var enemy_turn_sprite:TextureRect = $Control/Combatants/Enemy/MarginContainer/Sprite/TurnIndicator

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
	
	turn_button_container.visible = false
	player_turn_sprite.visible = false
	enemy_turn_sprite.visible = false

func on_scene_ready() -> void:
	pass

func set_first_turn_indicator() -> void:
	player_turn_sprite.visible = true
	enemy_turn_sprite.visible = false

func clear_turn_indicator() -> void:
	player_turn_sprite.visible = false
	enemy_turn_sprite.visible = false

func update_turn_indicator(source:Combatant) -> void:
	if source.is_the_player:
		player_turn_sprite.visible = false
		enemy_turn_sprite.visible = true
	elif not source.is_the_player:
		player_turn_sprite.visible = true
		enemy_turn_sprite.visible = false
	
	step_button_border.visible = false

func update_enemy_sprite(new_sprite:Texture2D) -> void:
	enemy_sprite_display.texture = new_sprite

func update_player_health(value:int) -> void:
	player_health_label.text = str(int(value))

func update_enemy_health(value:int) -> void:
	enemy_health_label.text = str(int(value))

func update_player_attack(value:int) -> void:
	player_attack_label.text = str(int(value))

func update_enemy_attack(value:int) -> void:
	enemy_attack_label.text = str(int(value))


func change_to() -> void:
	HudEvents.change_to_combat_screen.emit()
	clear_turn_indicator()
	combat_button.visible = true
	pause_button_border.visible = false
	step_button_border.visible = false
	play_button_border.visible = false
	turn_button_container.visible = false
	visible = true

func change_from() -> void:
	clear_turn_indicator()
	visible = false

func _on_combat_button_pressed() -> void:
	HudEvents.combat_button_pressed.emit()
	combat_button.visible = false
	turn_button_container.visible = true

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
