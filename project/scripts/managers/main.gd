extends Node2D

@export var main_rpg_game_scene:PackedScene
@onready var level_container:Node2D = $LevelContainer
@onready var game_start_button_container:CanvasLayer = $GameStarter

func _ready() -> void:
	game_start_button_container.visible = true

func start_rpg_game() -> void:
	game_start_button_container.visible = false
	
	clear_old_level(level_container)
	var new_level:Node = main_rpg_game_scene.instantiate()
	level_container.add_child(new_level)

func clear_old_level(parent_node:Node) -> void:
	for child:Node in parent_node.get_children():
		child.queue_free()


func _on_new_game_button_pressed() -> void:
	start_rpg_game()

func _on_load_game_button_pressed() -> void:
	start_rpg_game()
