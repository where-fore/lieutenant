extends TextureRect
class_name StatPanel

@onready var individual_stat_container:Control = $MarginContainer/ScrollContainer/VBoxContainer
@export var individual_stat_scene:PackedScene
var my_stats:Dictionary[String, StatIndividual]

func _ready() -> void:
	clear_editor_placeholders()

func clear_editor_placeholders() -> void:
	for child:Node in individual_stat_container.get_children():
		child.queue_free()

func add_stat(new_reward:Reward) -> void:
	var new_stat:StatIndividual = individual_stat_scene.instantiate()
	individual_stat_container.add_child(new_stat)
	
	new_stat.populate(new_reward)
	
	var new_reward_key:String = new_reward.resource_scene_unique_id
	my_stats[new_reward_key] = new_stat

func remove_stat(old_reward:Reward) -> void:
	var old_reward_key:String = old_reward.resource_scene_unique_id
	var old_stat:StatIndividual = my_stats.get(old_reward_key)
	if old_stat:
		old_stat.queue_free()
		my_stats.erase(old_reward_key)
	else:
		push_error("was told to remove stat, but it wasn't present in the first place: ", old_reward.reward_name)
