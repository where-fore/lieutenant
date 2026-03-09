extends Resource
class_name Aura

@export var health:int = 0
@export var attack:int = 0
@export var health_multiplier:int = 0
@export var attack_multiplier:int = 0

@export var aura_name:String
var unique_id:String
var additive_dictionary:Dictionary[StringName, int] = {}
var multiplicative_dictionary:Dictionary[StringName, int] = {}

@export_category("Duration")
#note enum exports: enums are saved as integers in the list
#so given { PERMANENT, THIS_COMBAT, TURNS, SPECIAL }
#so if an aura is export-selection as TURN, its enum is == 2 (index starts at 0)
#which means if you then change to { PERMANENT, THIS_COMBAT, ANY_TURN, TURNS, SPECIAL }
#anything export-selected as TURN before will be ANY_TURN now, since that is value 2
enum DurationType {PERMANENT, THIS_COMBAT, TURNS, SPECIAL}
@export var duration_type:DurationType = DurationType.PERMANENT
@export var base_duration:int = 0
var current_duration:int = 0

func create_aura(name:String = "", additive_init:Dictionary[StringName, int] = {}, multiplicative_init:Dictionary[StringName, int] = {}) -> Aura:
	var this_aura:Aura = self.duplicate()
	if name: this_aura.aura_name = name
	this_aura.unique_id = str(this_aura.get_instance_id()) + "_" + str(Time.get_time_string_from_system())
	add_exports_to_dictionaries()
	
	if additive_init: this_aura.additive_dictionary = additive_init.duplicate()
	else: this_aura.additive_dictionary = additive_dictionary.duplicate()
	if multiplicative_init: this_aura.multiplicative_dictionary = multiplicative_init.duplicate()
	else: this_aura.multiplicative_dictionary = multiplicative_dictionary.duplicate()
	
	this_aura.current_duration = base_duration

	return this_aura

func add_exports_to_dictionaries() -> void:
	if health: additive_dictionary[Stats.health] = health
	if attack: additive_dictionary[Stats.attack] = attack
	if health_multiplier: multiplicative_dictionary[Stats.health] = health_multiplier
	if attack_multiplier: multiplicative_dictionary[Stats.attack] = attack_multiplier

func update_aura() -> void:
	AuraEvents.updated_aura.emit(self)

func decrement_duration_counter() -> void:
	if duration_type == DurationType.TURNS:
		current_duration -= 1
		if current_duration <= 0:
			expire_aura()

func check_then_remove_combat_auras() -> void:
	if duration_type == DurationType.THIS_COMBAT:
		expire_aura()
	if duration_type == DurationType.TURNS:
		expire_aura()

func check_then_start_combat_aura() -> Aura:
	if duration_type == DurationType.TURNS:
		return create_aura()
	else: return null

func expire_aura() -> void:
	AuraEvents.expired_aura.emit(self)
	CombatLogEvents.aura_removed.emit(self)
