extends Control

@onready var combat_button:Button = $CombatControls/VBoxContainer/CombatButton
@onready var edit_border:TextureRect = $EditBorder

@onready var turn_button_container:Container = $CombatControls/VBoxContainer/TurnButtons
@onready var pause_button:Button = $CombatControls/VBoxContainer/TurnButtons/PauseButton
@onready var step_button:Button = $CombatControls/VBoxContainer/TurnButtons/StepButton
@onready var play_button:Button = $CombatControls/VBoxContainer/TurnButtons/PlayButton
@onready var play_fast_button:Button = $CombatControls/VBoxContainer/TurnButtons/PlayFastButton

@onready var enemy1_ui_combatant:UiCombatant = $Panel/EnemyCombatants/Enemy
@onready var enemy2_ui_combatant:UiCombatant = $Panel/EnemyCombatants/Enemy2

var enemy_ui_combatants:Array[UiCombatant]

var temporary_map_tile:MapTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.send_enemy_combatants_to_ui.connect(assign_enemies_to_ui)
	MapEvents.venture_to.connect(save_potential_map_tile)
	MapEvents.enter_combat_in.connect(load_map_combat)
	ScenarioEvents.begin_combat_with.connect(load_scenario_combat)
	ScenarioEvents.begin_combat_with_map_enemy.connect(load_scenario_combat_from_tile)
	TimingEvents.everythings_ready.connect(on_scene_ready)
	
	turn_button_container.visible = false
	edit_border.visible = false
	
	enemy_ui_combatants = [enemy1_ui_combatant, enemy2_ui_combatant]

func on_scene_ready() -> void:
	pass

func assign_enemies_to_ui(enemies:Array[Combatant]) -> void:
	if enemies.size() > enemy_ui_combatants.size():
		push_error("was given ", enemies.size(), " enemies, but only have ", enemy_ui_combatants.size(), " enemy ui spots. eradicating extraneous enemies.")
		
		var extra_enemies:int = enemies.size() - enemy_ui_combatants.size()
		var to_eradicate:Array[Combatant] = enemies.slice(-1 * extra_enemies)
		
		enemies.resize(enemy_ui_combatants.size())
		
		#signal to the tile to shape up its enemies array
		#currently the map tile will continue to have ghost references in the array, and probably crash
		
		for enemy:Combatant in to_eradicate:
			if is_instance_valid(enemy):
				enemy.queue_free()
	
	var index_count:int = 0
	for enemy:Combatant in enemies:
		enemy_ui_combatants[index_count].assign_combatant(enemy)
		enemy_ui_combatants[index_count].visible = true
		index_count += 1

func load_map_combat(map_tile:MapTile) -> void:
	change_to(map_tile.tile_data.enemies)

func save_potential_map_tile(map_tile:MapTile) -> void:
	temporary_map_tile = map_tile

func load_scenario_combat_from_tile() -> void:
	if not temporary_map_tile:
		push_error("tried to load combatant from map tile because event told me to, but a combatant was never saved")
	if not temporary_map_tile.tile_data.enemies:
		push_error("tried to load a map tile combat, but there's no enemy on this tile: " + temporary_map_tile.tile_data.script_path)
	ScenarioEvents.begin_combat_with.emit(temporary_map_tile.tile_data.enemies)

func load_scenario_combat(enemies:Array[Combatant]) -> void:
	change_to(enemies)

func change_to(enemies:Array[Combatant]) -> void:
	CombatEvents.prepare_combat_with_enemy.emit(enemies)
	
	combat_button.visible = true
	turn_button_container.visible = true
	fade_buttons_out()
	
	set_last_chosen_speed()
	
	HudEvents.load_portrait_ui.emit()
	visible = true

func change_from() -> void:
	for ui_combatant:UiCombatant in enemy_ui_combatants:
		ui_combatant.clear_combatant()
	HudEvents.unload_portrait_ui.emit()
	visible = false

func set_last_chosen_speed() -> void:
	untoggle_all_buttons()
	match HudEvents.last_combat_speed_chosen:
		HudEvents.CombatSpeedNames.STEP: pause_button.set_pressed_no_signal(true)
		HudEvents.CombatSpeedNames.PLAY: play_button.set_pressed_no_signal(true)
		HudEvents.CombatSpeedNames.PLAY_FAST: play_fast_button.set_pressed_no_signal(true)
		_: push_error("not sure what last combat speed was")

func _on_combat_button_pressed() -> void:
	HudEvents.combat_button_pressed.emit()
	combat_button.visible = false
	turn_button_container.visible = true
	fade_buttons_in()

func _on_pause_button_pressed() -> void:
	untoggle_all_buttons()
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.STEP
	
	CombatEvents.pause_button_pressed.emit()

func _on_step_button_pressed() -> void:
	untoggle_all_buttons()
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.STEP
	
	CombatEvents.step_button_pressed.emit()

func _on_play_button_pressed() -> void:
	untoggle_all_buttons()
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.PLAY
	
	CombatEvents.play_button_pressed.emit()

func _on_play_fast_button_pressed() -> void:
	untoggle_all_buttons()
	HudEvents.last_combat_speed_chosen = HudEvents.CombatSpeedNames.PLAY_FAST
	
	CombatEvents.play_fast_button_pressed.emit()

func untoggle_all_buttons() -> void:
	pause_button.set_pressed_no_signal(false)
	step_button.set_pressed_no_signal(false)
	play_button.set_pressed_no_signal(false)
	play_fast_button.set_pressed_no_signal(false)

func fade_buttons_out() -> void:
	turn_button_container.modulate = Color(0.35,0.35,0.35,1)

func fade_buttons_in() -> void:
	turn_button_container.modulate = Color(1,1,1,1)
	
