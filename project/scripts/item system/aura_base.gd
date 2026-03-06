extends Resource
class_name Aura

@export var health: int = 0
@export var attack: int = 0
@export var health_multiplier: int = 0

var unique_id: String
var additive_dictionary:Dictionary[StringName, int] = {}
var multiplicative_dictionary:Dictionary[StringName, int] = {}

#this is currently a hacky implementation, awaiting json conversion
#this setup_aura_stats gets called externally by item_data
#overriding this with a custom aura would make it so it ignores the export variables
#derived subclasses hook onto these functions
func setup_aura_stats() -> void:
	add_exports_to_dictionaries()
	pass

func add_exports_to_dictionaries() -> void:
	if health: additive_dictionary[Stats.health] = health
	if attack: additive_dictionary[Stats.attack] = attack
	if health_multiplier: multiplicative_dictionary[Stats.health] = health_multiplier

func _init() -> void:
	unique_id = str(self.get_instance_id()) + "_" + str(Time.get_time_string_from_system())
