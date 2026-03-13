extends Resource
class_name Aura

@export var health:int = 0
@export var attack:int = 0
@export var health_multiplier:int = 0
@export var attack_multiplier:int = 0

@export var aura_name:String
@export var aura_icon:Texture2D
var tooltip_text:String = ""
var unique_id:String
var visible:bool = false
var additive_dictionary:Dictionary[StringName, int] = {}
var multiplicative_dictionary:Dictionary[StringName, int] = {}

@export_category("Duration")
#note enum exports: enums are saved as simply integers
#so given { PERMANENT, THIS_COMBAT, TURNS, SPECIAL }
#so if an aura is export-selection as TURN, its enum is == 2 (index starts at 0)
#which means if you then change to { PERMANENT, THIS_COMBAT, ANY_TURN, TURNS, SPECIAL }
#anything export-selected as TURN before will be ANY_TURN now, since that is value 2
@export var duration_type:AuraNames.DurationType = AuraNames.DurationType.PERMANENT
@export var base_duration:int = 0
var current_duration:int = 0

func create_aura(name:String = "", should_be_visible:bool = false, additive_init:Dictionary[StringName, int] = {}, multiplicative_init:Dictionary[StringName, int] = {}) -> Aura:
	var this_aura:Aura = self.duplicate()
	
	if name: this_aura.aura_name = name
	if should_be_visible: this_aura.visible = should_be_visible
	this_aura.unique_id = str(this_aura.get_instance_id()) + "_" + str(Time.get_time_string_from_system())
	
	add_exports_to_dictionaries()
	
	if additive_init: this_aura.additive_dictionary = additive_init.duplicate()
	else: this_aura.additive_dictionary = additive_dictionary.duplicate()
	if multiplicative_init: this_aura.multiplicative_dictionary = multiplicative_init.duplicate()
	else: this_aura.multiplicative_dictionary = multiplicative_dictionary.duplicate()
	
	this_aura.current_duration = base_duration
	
	generate_tooltip_text(this_aura)

	return this_aura

func add_exports_to_dictionaries() -> void:
	if health: additive_dictionary[Stats.health] = health
	if attack: additive_dictionary[Stats.attack] = attack
	if health_multiplier: multiplicative_dictionary[Stats.health] = health_multiplier
	if attack_multiplier: multiplicative_dictionary[Stats.attack] = attack_multiplier

func update_aura() -> void:
	AuraEvents.updated_aura.emit(self)

func generate_tooltip_text(aura_to_update:Aura) -> void:
	for stat_change:StringName in additive_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(additive_dictionary[stat_change])
		aura_to_update.tooltip_text += to_add
	for stat_change:StringName in multiplicative_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(multiplicative_dictionary[stat_change]*100) + "%"
		aura_to_update.tooltip_text += to_add

func decrement_duration_counter(source:Combatant) -> void:
	if duration_type == AuraNames.DurationType.TURNS:
		current_duration -= 1
		if current_duration <= 0:
			expire_aura(source)

func check_then_remove_combat_auras(source:Combatant) -> void:
	if duration_type == AuraNames.DurationType.THIS_COMBAT:
		expire_aura(source)
	if duration_type == AuraNames.DurationType.TURNS:
		expire_aura(source)

func check_then_start_combat_aura() -> Aura:
	if duration_type == AuraNames.DurationType.TURNS:
		return create_aura()
	else: return null

func expire_aura(source:Combatant) -> void:
	AuraEvents.expired_aura.emit(source, self)
	CombatLogEvents.aura_removed.emit(source, self)
