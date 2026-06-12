extends Panel
class_name StatIndividual

@onready var my_image_holder:IconWithBorder = $HBoxContainer/IconBorder
@onready var my_text_holder:Label = $HBoxContainer/Label
var saved_reward:Reward

func populate(new_reward:Reward) -> void:
	my_image_holder.set_icon(new_reward.reward_sprite)
	my_text_holder.text = new_reward.reward_name
	saved_reward = new_reward

func _on_gui_input(_event: InputEvent) -> void:
	#delete item? move to other character?
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	tooltip_text = saved_reward.get_tooltip()
