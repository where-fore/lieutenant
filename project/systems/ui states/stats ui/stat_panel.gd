extends TextureRect
class_name StatPanel

@onready var individual_stat_container:Control = $MarginContainer/ScrollContainer/VBoxContainer
@export var individual_stat_scene:PackedScene
var my_stats:Dictionary[Reward, StatIndividual]

func _ready() -> void:
	clear_editor_placeholders()

func clear_editor_placeholders() -> void:
	for child:Node in individual_stat_container.get_children():
		child.queue_free()

func add_stat(new_reward:Reward) -> void:
	var new_stat:StatIndividual = individual_stat_scene.instantiate()
	individual_stat_container.add_child(new_stat)
	individual_stat_container.move_child(new_stat, 0) #to top of tree ie. top of box
	
	new_stat.populate(new_reward)
	
	var new_reward_key:Reward = new_reward
	my_stats[new_reward_key] = new_stat

func remove_stat(old_reward:Reward) -> void:
	var old_reward_key:Reward = old_reward
	var old_stat:StatIndividual = my_stats.get(old_reward_key)
	if old_stat:
		old_stat.queue_free()
		my_stats.erase(old_reward_key)
	else:
		push_error("was told to remove stat, but it wasn't present in the first place: ", old_reward.reward_name)
