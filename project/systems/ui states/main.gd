extends Node2D

@export var combat_entire_scene:PackedScene
@onready var combat_container:Control = $MainGame/MarginContainer/CombatContainer
@export var map_creation_scene:PackedScene
@onready var map_container:Control = $MainGame/MarginContainer/MapContainer
@export var text_blurb_scene:PackedScene
@onready var text_blurb_container:Control = $MainGame/MarginContainer/TextBlurbContainer

@onready var game_start_button_container:Control = $MainUI/GameStarter
@onready var pause_menu_button_container:Control = $MainUI/PauseMenuButton
@onready var pause_menu_container:Control = $MainUI/PauseMenu
@onready var scrolling_log_container:Control = $MainGame/MarginContainer/RightSideUI/EventLog
@onready var right_side_ui_container:Control = $MainGame/MarginContainer/RightSideUI


func _ready() -> void:
	HudEvents.chapter_completed.connect(_on_restart_button_pressed)
	
	game_start_button_container.visible = true
	pause_menu_button_container.visible = true
	text_blurb_container.visible = true
	pause_menu_container.visible = false
	scrolling_log_container.visible = true
	right_side_ui_container.visible = true

func start_game() -> void:
	clear_and_create_scene(map_creation_scene, map_container)
	clear_and_create_scene(combat_entire_scene, combat_container)
	clear_and_create_scene(text_blurb_scene, text_blurb_container)
	
	#wait for the above to finish
	await get_tree().process_frame
	HudEvents.chapter_started.emit()

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
	game_start_button_container.visible = false
	start_game()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_resume_button_pressed() -> void:
	close_pause_menu()

func close_pause_menu() -> void:
	if pause_menu_container.visible:
		pause_menu_container.visible = false
	
