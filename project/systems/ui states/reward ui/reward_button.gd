extends MarginContainer
class_name RewardButton

@export var icon:IconWithBorder
@export var icon_darkener:Control
@export var tooltip_parent:Control
var reward_assigned:Reward
signal reward_button_pressed(rewardButton:RewardButton)
signal reward_button_hovered(rewardButton:RewardButton)
signal reward_button_unhovered(rewardButton:RewardButton)

func _ready() -> void:
	icon_darkener.visible = false

func assign_reward(reward:Reward) -> void:
	reward_assigned = reward
	icon.set_icon(reward.reward_sprite)
	tooltip_parent.tooltip_text = reward.get_tooltip()

func darken() -> void:
	icon_darkener.visible = true

func undarken() -> void:
	icon_darkener.visible = false

func clean_up() -> void:
	queue_free()

func _on_reward_button_pressed() -> void:
	reward_button_pressed.emit(self)

func _on_reward_button_mouse_entered() -> void:
	reward_button_hovered.emit(self)

func _on_reward_button_mouse_exited() -> void:
	reward_button_unhovered.emit(self)
