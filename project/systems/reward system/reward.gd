extends Resource
class_name Reward

var reward_name:String
var reward_sprite:Texture2D
var reward_categories:Dictionary[StringName, int]
var resource_path_id:String

func get_tooltip() -> String:
	push_error("reward didn't overwrite the tooltip function")
	return "MISSING TOOLTIP TEXT"
