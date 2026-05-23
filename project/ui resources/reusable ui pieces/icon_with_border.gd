extends TextureRect
class_name IconWithBorder

@onready var my_icon_holder:TextureRect = $Icon
@onready var border:TextureRect = $"."
var fallback_icon:Texture2D = load("res://sprites/question.png")

func set_icon(new_icon:Texture2D) -> void:
	my_icon_holder.texture = new_icon
