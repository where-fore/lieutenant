extends Node2D

@export var main_rpg_scene:PackedScene
@onready var level_container:Control = $MainGame/Panel/CombatContainer
@onready var game_start_button_container:Control = $MainUI/GameStarter
@onready var pause_menu_button_container:Control = $MainUI/PauseMenuButton
@onready var pause_menu_container:Control = $MainUI/PauseMenu



func _ready() -> void:
	game_start_button_container.visible = true
	pause_menu_button_container.visible = false
	pause_menu_container.visible = false
	
	#can add this back when i want a main menu
	#game_start_button_container.visible = true
	#pause_menu_button_container.visible = true
	#pause_menu_container.visible = false
	

func open_pause_menu() -> void:
	pass

func start_rpg() -> void:
	game_start_button_container.visible = false
	
	for child:Node in level_container.get_children():
		child.queue_free()
	var new_level:Node = main_rpg_scene.instantiate()
	level_container.add_child(new_level)

func _on_new_game_button_pressed() -> void:
	start_rpg()

func _on_load_game_button_pressed() -> void:
	start_rpg()

func _on_pause_menu_button_pressed() -> void:
	if not pause_menu_container.visible:
		pause_menu_container.visible = true
	else:
		pause_menu_container.visible = false
