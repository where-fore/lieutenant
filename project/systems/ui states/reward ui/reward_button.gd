extends MarginContainer
class_name RewardButton

@export var icon:IconWithBorder
@export var tooltip_parent:Control
var reward_assigned:Reward
signal reward_button_pressed(rewardButton:RewardButton)

func assign_reward(reward:Reward) -> void:
	reward_assigned = reward
	icon.set_icon(reward.reward_sprite)
	tooltip_parent.tooltip_text = reward.get_tooltip()

func _on_reward_button_pressed() -> void:
	reward_button_pressed.emit(self)

func clean_up() -> void:
	queue_free()
