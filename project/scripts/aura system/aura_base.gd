extends Resource
class_name Aura

@export var health: int = 0
@export var attack: int = 0
@export var health_multiplier: int = 0

var unique_id: String
var additive_dictionary:Dictionary[StringName, int] = {}
var multiplicative_dictionary:Dictionary[StringName, int] = {}

#derived subclasses hook onto these functions
func setup_aura_stats() -> void:
	pass

func create_aura(additive_init:Dictionary[StringName, int] = {}, multiplicative_init:Dictionary[StringName, int] = {}) -> Aura:
	var this_aura:Aura = Aura.new()
	this_aura.unique_id = str(self.get_instance_id()) + "_" + str(Time.get_time_string_from_system())
	add_exports_to_dictionaries()
	
	if not additive_init: this_aura.additive_dictionary = additive_dictionary.duplicate()
	else: this_aura.additive_dictionary = additive_init.duplicate()
	if not multiplicative_init: this_aura.multiplicative_dictionary = multiplicative_dictionary.duplicate()
	else: this_aura.multiplicative_dictionary = multiplicative_init.duplicate()
	
	return this_aura

func add_exports_to_dictionaries() -> void:
	if health: additive_dictionary[Stats.health] = health
	if attack: additive_dictionary[Stats.attack] = attack
	if health_multiplier: multiplicative_dictionary[Stats.health] = health_multiplier
