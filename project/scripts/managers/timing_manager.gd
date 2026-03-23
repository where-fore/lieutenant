extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimingEvents.restart_the_game.connect(on_game_loss)

	#this gets called when this node is readied
	#and since this script is the parent to everything else, this is after all other nodes are ready
	TimingEvents.everythings_ready.emit()
	HudEvents.venture_to.connect(show)
	HudEvents.combat_all_done.connect(hide)

func show(_maptile:MapTile) -> void:
	self.visible = true

func hide() -> void:
	self.visible = false

func on_game_loss() -> void:
	InventoryEvents.clear_all_to_restart.emit()
	AuraEvents.restart_game.emit()
	InventoryEvents.rebuild_all_to_restart.emit()
