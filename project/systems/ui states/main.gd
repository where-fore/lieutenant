extends Node2D


@export var combat_entire_scene:PackedScene
@onready var combat_container:Control = $MainGame/MarginContainer/CombatContainer
@export var map_creation_scene:PackedScene
@onready var map_container:Control = $MainGame/MarginContainer/MapContainer
@export var text_blurb_scene:PackedScene
@onready var text_blurb_container:Control = $MainGame/MarginContainer/TextBlurbContainer
@onready var combat_log_container:Control = $MainGame/MarginContainer/CombatLogContainer
@onready var combat_log_object:Control = $MainGame/MarginContainer/CombatLogContainer/Frame/MarginContainer/VBoxContainer/EventLog

@onready var crt_filter_container:CanvasLayer = $CRTFilter
@onready var game_start_button_container:Control = $MainUI/GameStarter
@onready var pause_menu_button:Control = $MainUI/TopButtons/PauseMenuButton
@onready var inventory_menu_button:Control = $MainUI/TopButtons/InventoryMenuButton
@onready var time_button:Control = $MainUI/TopButtons/TimeButton
@onready var pause_menu_container:Control = $MainUI/PauseMenu
@onready var right_side_ui_container:Control = $MainGame/MarginContainer/RightSideUI
@onready var stats_ui_container:Control = $MainGame/MarginContainer/StatsUIContainer

@onready var volume_slider:HSlider = $MainUI/PauseMenu/MenuButtonCanvas/MenuButtons/VolumeSlider/HBoxContainer/VolumeSlider


func _ready() -> void:
	HudEvents.chapter_completed.connect(_on_restart_button_pressed)
	TimeOfDay.time_moved_forward.connect(update_time_of_day_ui)
	
	game_start_button_container.visible = true
	pause_menu_button.visible = true
	inventory_menu_button.visible = false
	time_button.visible = false
	
	text_blurb_container.visible = true
	pause_menu_container.visible = false
	
	right_side_ui_container.visible = true
	stats_ui_container.visible = false
	combat_log_container.visible = false
	
	volume_slider.value = BackgroundMusicPlayer.get_current_volume() * 100

func start_game() -> void:
	clear_and_create_scene(map_creation_scene, map_container)
	clear_and_create_scene(combat_entire_scene, combat_container)
	clear_and_create_scene(text_blurb_scene, text_blurb_container)
	
	#wait for the above to finish
	await get_tree().process_frame
	HudEvents.chapter_started.emit()
	show_inventory_button()

func clear_scene(node_parent:Control) -> void:
	for child:Node in node_parent.get_children():
		child.queue_free()

func clear_and_create_scene(node_base_scene:PackedScene, node_parent:Control) -> void:
	for child:Node in node_parent.get_children():
		child.queue_free()
	#note the above is queue_free, not free(), which means it queues up deleting the scene till end of frame
	#so i probably want to until this frame is done, the child is deleted, before continuing
	await get_tree().process_frame
	
	var new_level:Node = node_base_scene.instantiate()
	node_parent.add_child(new_level)

func _on_pause_menu_button_pressed() -> void:
	if not pause_menu_container.visible:
		pause_menu_container.visible = true
	else:
		pause_menu_container.visible = false
	HudEvents.game_paused.emit()

func _on_new_game_button_pressed() -> void:
	BackgroundMusicPlayer.begin_music.call_deferred()
	
	game_start_button_container.visible = false
	start_game()

func _on_restart_button_pressed() -> void:
	TimingEvents.restarting_game.emit()
	get_tree().reload_current_scene()

func _on_resume_button_pressed() -> void:
	close_pause_menu()

func show_inventory_button() -> void:
	inventory_menu_button.visible = true

func close_pause_menu() -> void:
	if pause_menu_container.visible:
		pause_menu_container.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F11:
			crt_filter_container.visible = !crt_filter_container.visible

func _on_volume_slider_value_changed(new_slider_value: float) -> void:
	BackgroundMusicPlayer.change_volume(new_slider_value/100)

func _on_volume_icon_pressed() -> void:
	BackgroundMusicPlayer.flip_genre()
	#volume_slider.value = 0
	#should mute music, but atm using it to flip genre
	#probably should make flipping genre its own button

func _on_shuffle_icon_pressed() -> void:
	BackgroundMusicPlayer.shuffle_playlist()

func _on_inventory_menu_button_pressed() -> void:
	stats_ui_container.visible = !stats_ui_container.visible

func _on_combat_log_button_pressed() -> void:
	combat_log_container.visible = !combat_log_container.visible

func _on_full_log_button_pressed() -> void:
	combat_log_object.show_full_log()

func update_time_of_day_ui() -> void:
	if time_button.visible == false:
		time_button.visible = true
	var day:String = "Day " + str(TimeOfDay.current_day)
	var time:String = str(TimeOfDay.current_time_step * 4) + "h"
	time_button.tooltip_text = day + " " + time

func _on_time_button_pressed() -> void:
	if not CombatEvents.combat_ongoing and not ScenarioEvents.current_scenario:
		TimeOfDay.step_time_forward()
