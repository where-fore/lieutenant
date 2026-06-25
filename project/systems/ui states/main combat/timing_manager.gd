extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	MapEvents.enter_combat_in.connect(func(_unused_data) -> void: show())
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	ScenarioEvents.begin_combat_with.connect(func(_unused_data) -> void: show())
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	ScenarioEvents.present_rewards.connect(func(_unused_data) -> void: show())
	MapEvents.enter_without_combat_in.connect(show)
	MapEvents.combat_all_done.connect(hide)
	
	hide()
	
	#this gets called when this node is readied
	#and since this script is the parent to everything else, this is after all other nodes are ready
	TimingEvents.everythings_ready.emit()


func show() -> void:
	HudEvents.show_combat_screen_master.emit()

func hide() -> void:
	HudEvents.hide_combat_screen_master.emit()
