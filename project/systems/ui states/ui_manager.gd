extends Control

@onready var combat_ui_manager:Node = $Control/MainUI/CombatUI
@onready var reward_ui_manager:Node = $Control/MainUI/RewardUI
@onready var portrait_ui_manager:Node = $Control/MainUI/PortraitUI
@onready var death_ui:Node = $Control/MainUI/DeathUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward_ui_manager.visible = false
	combat_ui_manager.visible = false
	portrait_ui_manager.visible = false
	death_ui.visible = false
	
	HudEvents.combat_won.connect(end_combat_as_victory)
	HudEvents.combat_lost.connect(end_combat_as_failure)
	HudEvents.reward_choosing_complete.connect(end_rewards_screen)
	HudEvents.rout_chosen.connect(_on_restart_button_pressed)
	@warning_ignore("untyped_declaration")
	MapEvents.enter_without_combat_in.connect(func(_unused_data) -> void: end_combat_as_victory())

func end_combat_as_victory() -> void:	
	combat_ui_manager.change_from()
	reward_ui_manager.change_to()

func end_combat_as_failure() -> void:
	combat_ui_manager.change_from()
	death_ui.change_to()

func end_rewards_screen() -> void:
	reward_ui_manager.change_from()
	if ScenarioEvents.current_scenario:
		ScenarioEvents.completed_combat_as_victory.emit()
	if ScenarioEvents.tutorial_stage:
		ScenarioEvents.load_tutorial_second_scenario()
	MapEvents.combat_finished_as_victory.emit()
	MapEvents.combat_all_done.emit()

func _on_restart_button_pressed() -> void:
	if ScenarioEvents.current_scenario:
		ScenarioEvents.completed_combat_as_loss.emit()
	MapEvents.combat_finished_as_defeat.emit()
	MapEvents.combat_all_done.emit()
