extends Node2D

@export var main_rpg_scene:PackedScene
@onready var level_container:Control = $MainGame/MarginContainer/CombatContainer
@onready var game_start_button_container:Control = $MainUI/GameStarter
@onready var pause_menu_button_container:Control = $MainUI/PauseMenuButton
@onready var pause_menu_container:Control = $MainUI/PauseMenu
@onready var scrolling_log_container:Control = $MainGame/MarginContainer/RightSideUI/EventLog
@onready var right_side_ui_container:Control = $MainGame/MarginContainer/RightSideUI


func _ready() -> void:
	game_start_button_container.visible = true
	pause_menu_button_container.visible = false
	pause_menu_container.visible = false
	scrolling_log_container.visible = true
	right_side_ui_container.visible = true
	
	create_combat_ui()

func open_pause_menu() -> void:
	pass

func create_combat_ui() -> void:
	for child:Node in level_container.get_children():
		child.queue_free()
	var new_level:Node = main_rpg_scene.instantiate()
	level_container.add_child(new_level)

func _on_new_game_button_pressed() -> void:
	game_start_button_container.visible = false

func _on_load_game_button_pressed() -> void:
	game_start_button_container.visible = false

func _on_pause_menu_button_pressed() -> void:
	if not pause_menu_container.visible:
		pause_menu_container.visible = true
	else:
		pause_menu_container.visible = false
