extends Control

@onready var player_health_label:Label = $Panel/Combatants/Player/Stats/Health/HBoxContainer/Label
@onready var enemy_health_label:Label  = $Panel/Combatants/Enemy/Stats/Health/HBoxContainer/Label

@onready var player_attack_label:Label  = $Panel/Combatants/Player/Stats/Attack/HBoxContainer/Label
@onready var enemy_attack_label:Label  = $Panel/Combatants/Enemy/Stats/Attack/HBoxContainer/Label

@onready var combat_button:TextureButton = $Panel/CombatButton

@onready var turn_button_container:Container = $TurnButtons
@onready var pause_button_border:TextureRect = $TurnButtons/PauseButton/TextureRect
@onready var step_button_border:TextureRect = $TurnButtons/StepButton/TextureRect
@onready var play_button_border:TextureRect = $TurnButtons/PlayButton/TextureRect
@onready var play_fast_button_border:TextureRect = $TurnButtons/PlayFastButton/TextureRect


@onready var player_sprite_display:TextureRect = $Panel/Combatants/Player/MarginContainer/Sprite
@onready var enemy_sprite_display:TextureRect = $Panel/Combatants/Enemy/MarginContainer/Sprite
@onready var player_turn_sprite:TextureRect = $Panel/Combatants/Player/MarginContainer/Sprite/TurnIndicator
@onready var enemy_turn_sprite:TextureRect = $Panel/Combatants/Enemy/MarginContainer/Sprite/TurnIndicator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.player_health_update.connect(update_player_health)
	HudEvents.player_attack_update.connect(update_player_attack)
	HudEvents.enemy_health_update.connect(update_enemy_health)
	HudEvents.enemy_attack_update.connect(update_enemy_attack)
	CombatEvents.combatant_turn_ended.connect(update_turn_indicator)
	HudEvents.combat_button_pressed.connect(set_first_turn_indicator)
	HudEvents.send_enemy_sprite.connect(update_enemy_sprite)
	MapEvents.enter_combat_in.connect(change_to)
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


func change_to(_map_tile:MapTile) -> void:
	clear_turn_indicator()
	combat_button.visible = true
	turn_button_container.visible = true
	
	hide_all_button_borders()
	set_last_chosen_speed_border()
	
	visible = true

func change_from() -> void:
	clear_turn_indicator()
	visible = false

func set_last_chosen_speed_border() -> void:
	match HudEvents.last_combat_speed_chosen:
		HudEvents.CombatSpeedNames.STEP: pause_button_border.visible = true
		HudEvents.CombatSpeedNames.PLAY: play_button_border.visible = true
		HudEvents.CombatSpeedNames.PLAY_FAST: play_fast_button_border.visible = true
		_: push_error("not sure what last combat speed was")

func _on_combat_button_pressed() -> void:
	HudEvents.combat_button_pressed.emit()
	combat_button.visible = false
	turn_button_container.visible = true

func _on_pause_button_pressed() -> void:
	hide_all_button_borders()
	pause_button_border.visible = true
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.STEP
	
	CombatEvents.pause_button_pressed.emit()

func _on_step_button_pressed() -> void:
	hide_all_button_borders()
	#step_button_border.visible = true
	#i don't like the step button lighting up, i want it to feel like a one shot button
	pause_button_border.visible = true
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.STEP
	
	CombatEvents.step_button_pressed.emit()

func _on_play_button_pressed() -> void:
	hide_all_button_borders()
	play_button_border.visible = true
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.PLAY
	
	CombatEvents.play_button_pressed.emit()

func _on_play_fast_button_pressed() -> void:
	hide_all_button_borders()
	play_fast_button_border.visible = true
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.PLAY_FAST
	
	CombatEvents.play_fast_button_pressed.emit()

func hide_all_button_borders() -> void:
	step_button_border.visible = false
	pause_button_border.visible = false
	play_button_border.visible = false
	play_fast_button_border.visible = false
	
