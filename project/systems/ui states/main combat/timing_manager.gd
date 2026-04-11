extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimingEvents.restart_the_game.connect(on_game_loss)
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	MapEvents.enter_combat_in.connect(func(_unused_data) -> void: show())
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	ScenarioEvents.begin_combat_with.connect(func(_unused_data) -> void: show())
	ScenarioEvents.present_rewards.connect(show)
	MapEvents.enter_without_combat_in.connect(show)
	MapEvents.combat_all_done.connect(hide)
	
	hide()
	
	#this gets called when this node is readied
	#and since this script is the parent to everything else, this is after all other nodes are ready
	TimingEvents.everythings_ready.emit()


func show() -> void:
	self.visible = true

func hide() -> void:
	self.visible = false

func on_game_loss() -> void:
	InventoryEvents.clear_all_to_restart.emit()
	AuraEvents.restart_game.emit()
	InventoryEvents.rebuild_all_to_restart.emit()
