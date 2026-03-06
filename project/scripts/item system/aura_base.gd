extends Resource
class_name Aura

var unique_id: String
var additive_dictionary:Dictionary[StringName, int] = {}
var multiplicative_dictionary:Dictionary[StringName, int] = {}

#derived subclasses hook onto these functions
func setup_aura_stats() -> void:
	pass

func _init() -> void:
	unique_id = str(self.get_instance_id()) + "_" + str(Time.get_time_string_from_system())
