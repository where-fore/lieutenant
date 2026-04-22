extends Resource
class_name Reward

var reward_name:String
var reward_sprite:Texture2D

func get_tooltip() -> String:
	push_error("reward didn't overwrite the tooltip function")
	return "MISSING TOOLTIP TEXT"
