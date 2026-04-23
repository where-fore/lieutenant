extends Node

@warning_ignore_start("unused_signal")
signal clear_hovered_reward
signal new_hovered_reward
@warning_ignore_restore("unused_signal")

var hovering_a_reward:bool
var hovering_reward:Reward

func take_hovered_reward() -> void:
	hovering_a_reward = false
	hovering_reward = null
	clear_hovered_reward.emit()

func prep_hovered_reward(reward:Reward) -> void:
	hovering_a_reward = true
	hovering_reward = reward
	new_hovered_reward.emit(reward)
	
func _ready() -> void:
	HudEvents.reward_aiming.connect(prep_hovered_reward)
