extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimingEvents.restart_the_game.connect(on_game_loss)

func on_game_loss() -> void:
	InventoryEvents.clear_all_to_restart.emit()
	StatEvents.restart_game.emit()
	InventoryEvents.rebuild_all_to_restart.emit()
