extends Node

@warning_ignore_start("unused_signal")
signal clear_hovered_reward
signal new_hovered_reward
@warning_ignore_restore("unused_signal")

var hovering_reward:Reward

func take_hovered_reward() -> void:
	#i probably shouldn't do this - if i notice my inventory is full, and go to the inventory
	#or even just open the main menu lmao
	#i'm taking that reward onto my cursor elsewhere - i don't want it on the main menu/inventory cursor
	
	hovering_reward = null
	clear_hovered_reward.emit()

func prep_hovered_reward(reward:Reward) -> void:
	hovering_reward = reward
	new_hovered_reward.emit(reward)
	
func _ready() -> void:
	HudEvents.reward_aiming.connect(prep_hovered_reward)
