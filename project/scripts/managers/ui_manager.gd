extends Control

@onready var combat_ui_manager:Node = $Control/MainUI/CombatUI
@onready var reward_ui_manager:Node = $Control/MainUI/RewardUI
@onready var inventory_manager:Node = $Control/MainUI/InventoryManager
@onready var inventory_slot_grid_container:GridContainer = $Control/SideUI/SideMain/Inventory
@onready var death_ui:Node = $Control/MainUI/DeathUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reward_ui_manager.visible = false
	combat_ui_manager.visible = true
	death_ui.visible = false
	
	inventory_manager.set_inventory_slot_parent(inventory_slot_grid_container)
	
	HudEvents.combat_won.connect(end_combat_as_victory)
	HudEvents.combat_lost.connect(end_combat_as_failure)
	HudEvents.reward_chosen.connect(end_rewards_screen)

func end_combat_as_victory() -> void:
	reward_ui_manager.change_to()
	combat_ui_manager.change_from()

func end_combat_as_failure() -> void:
	death_ui.visible = true
	combat_ui_manager.change_from()

func end_rewards_screen() -> void:
	reward_ui_manager.change_from()
	death_ui.visible = false
	HudEvents.combat_all_done.emit()

func _on_restart_button_pressed() -> void:
	end_rewards_screen()
	#TimingEvents.restart_the_game.emit()
	#death_ui.visible = false
	#combat_ui_manager.change_to()
