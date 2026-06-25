extends Resource
class_name Reward

var reward_name:String
var reward_sprite:Texture2D
var reward_categories:Dictionary[StringName, int]
var resource_path_id:String

func get_tooltip() -> String:
	push_error("reward didn't overwrite the tooltip function")
	return "MISSING TOOLTIP TEXT"


#derived items/auras hook onto and override these functions
func on_other_combatant_dying(_newly_dead_combatant:Combatant) -> void:
	pass

func on_new_day() -> void:
	pass

func on_combat_start() -> void:
	pass

func on_turn_start(_source:Combatant) -> void:
	pass

func on_attack(_source:Combatant, _target:Combatant) -> void:
	pass

func on_damage_taken(_amount_taken:int, _source_of_damage:Combatant) -> void:
	pass

func on_turn_end(_source:Combatant) -> void:
	pass

func on_combat_end() -> void:
	pass

func threshold_state_changed(_threshold:ThresholdBehaviour) -> void:
	pass
