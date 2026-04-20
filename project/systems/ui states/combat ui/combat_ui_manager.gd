extends Control

@onready var combat_button:TextureButton = $Panel/CombatButton
@onready var edit_border:TextureRect = $EditBorder

@onready var turn_button_container:Container = $TurnButtons
@onready var pause_button_border:TextureRect = $TurnButtons/PauseButton/TextureRect
@onready var step_button_border:TextureRect = $TurnButtons/StepButton/TextureRect
@onready var play_button_border:TextureRect = $TurnButtons/PlayButton/TextureRect
@onready var play_fast_button_border:TextureRect = $TurnButtons/PlayFastButton/TextureRect

@onready var player1_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player1
@onready var player2_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player2
@onready var player3_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player3
@onready var player4_ui_combatant:UiCombatant = $Panel/PlayerCombatants/Player4

@onready var enemy1_ui_combatant:UiCombatant = $Panel/EnemyCombatants/Enemy
@onready var enemy2_ui_combatant:UiCombatant = $Panel/EnemyCombatants/Enemy2

var player_ui_combatants:Array[UiCombatant]
var enemy_ui_combatants:Array[UiCombatant]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.send_player_combatants_to_ui.connect(assign_players_to_ui)
	HudEvents.send_enemy_combatants_to_ui.connect(assign_enemies_to_ui)
	HudEvents.combat_button_pressed.connect(set_first_turn_indicator)
	MapEvents.enter_combat_in.connect(load_map_combat)
	ScenarioEvents.begin_combat_with.connect(load_scenario_combat)
	TimingEvents.everythings_ready.connect(on_scene_ready)
	
	turn_button_container.visible = false
	edit_border.visible = false
	
	player_ui_combatants = [player1_ui_combatant, player2_ui_combatant, player3_ui_combatant, player4_ui_combatant]
	enemy_ui_combatants = [enemy1_ui_combatant, enemy2_ui_combatant]

func on_scene_ready() -> void:
	pass

func set_first_turn_indicator() -> void:
	player1_ui_combatant.force_show_turn_indicator()

func assign_players_to_ui(players:Array[Combatant]) -> void:
	var index_count:int = 0
	for player:Combatant in players:
		player_ui_combatants[index_count].assign_combatant(player)
		player_ui_combatants[index_count].visible = true
		index_count += 1

func assign_enemies_to_ui(enemies:Array[Combatant]) -> void:
	var index_count:int = 0
	for enemy:Combatant in enemies:
		enemy_ui_combatants[index_count].assign_combatant(enemy)
		enemy_ui_combatants[index_count].visible = true
		index_count += 1

func load_map_combat(map_tile:MapTile) -> void:
	change_to(map_tile.tile_data.enemy)

func load_scenario_combat(enemy:Combatant) -> void:
	change_to(enemy)

func change_to(enemy:Combatant) -> void:
	CombatEvents.prepare_combat_with_enemy.emit(enemy)
	
	combat_button.visible = true
	turn_button_container.visible = true
	fade_buttons_out()
	
	hide_all_button_borders()
	set_last_chosen_speed_border()
	
	visible = true

func change_from() -> void:
	for ui_combatant:UiCombatant in player_ui_combatants + enemy_ui_combatants:
		ui_combatant.clear_combatant()
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
	fade_buttons_in()

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

func fade_buttons_out() -> void:
	turn_button_container.modulate = Color(0.35,0.35,0.35,1)

func fade_buttons_in() -> void:
	turn_button_container.modulate = Color(1,1,1,1)
	
