extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimingEvents.restart_the_game.connect(on_game_loss)

	#this gets called when this node is readied
	#and since this script is the parent to evertyhing else, this is after all other nodes are ready
	TimingEvents.everythings_ready.emit()

func on_game_loss() -> void:
	InventoryEvents.clear_all_to_restart.emit()
	AuraEvents.restart_game.emit()
	InventoryEvents.rebuild_all_to_restart.emit()
