extends Resource
class_name Aura

var aura_id:String
var aura_name:String
var aura_sprite:Texture2D
var extra_tooltip:String
var aura_categories:Array[StringName]
var visible:bool = false

signal expired(aura_instance:Aura)
signal updated(aura_instance:Aura)

var duration_type:AuraNames.DurationType = AuraNames.DurationType.PERMANENT
var base_duration:int:
	set(value):
		current_duration = value
var current_duration:int

var unique_id:String

var additive_stat_dictionary:Dictionary[StringName, int] = {}
var multiplicative_stat_dictionary:Dictionary[StringName, int] = {}

func _init() -> void:
	setup_aura_stats()

func create_aura(name:String = "", should_be_visible:bool = false, additive_init:Dictionary[StringName, int] = {}, multiplicative_init:Dictionary[StringName, int] = {}) -> Aura:
	var this_aura:Aura = self.duplicate()
	
	if name: this_aura.aura_name = name
	if should_be_visible: this_aura.visible = should_be_visible
	
	if additive_init: this_aura.additive_stat_dictionary = additive_init.duplicate()
	else: this_aura.additive_stat_dictionary = additive_stat_dictionary.duplicate()
	if multiplicative_init: this_aura.multiplicative_stat_dictionary = multiplicative_init.duplicate()
	else: this_aura.multiplicative_stat_dictionary = multiplicative_stat_dictionary.duplicate()
	
	if base_duration: this_aura.current_duration = base_duration
	
	return this_aura

func update_aura() -> void:
	#this should probably be in a setter somewhere
	updated.emit(self)

func get_id() -> String:
	if not unique_id: unique_id = str(ResourceUID.create_id())
	return unique_id

#this is copied from item_base.gd
func get_tooltip() -> String:
	setup_aura_stats()
	
	var to_add:String
	
	var tooltip_text:String = aura_name
	
	if duration_type == AuraNames.DurationType.TURNS:
		to_add = "\n" + "Aura: " + str(current_duration) + AuraNames.DurationType_Labels.keys()[duration_type]
	else:
		to_add = "\n" + "Aura: " + AuraNames.DurationType_Labels[duration_type]
	tooltip_text += to_add
	to_add = ""
	
	for stat_change:StringName in additive_stat_dictionary:
		to_add = str(stat_change) + " increased by " + str(additive_stat_dictionary[stat_change])
		tooltip_text += "\n" + to_add
	for stat_change:StringName in multiplicative_stat_dictionary:
		to_add = str(stat_change) + " increased by " + str(multiplicative_stat_dictionary[stat_change]) + "%"
		tooltip_text += "\n" + to_add
		
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text

func decrement_duration_counter() -> void:
	if duration_type == AuraNames.DurationType.TURNS:
		current_duration -= 1
		if current_duration <= 0:
			expire_aura()

func check_if_aura_expired_at_end_of_combat() -> void:
	if duration_type == AuraNames.DurationType.THIS_COMBAT:
		expire_aura()
	elif duration_type == AuraNames.DurationType.TURNS:
		expire_aura()

func check_then_start_combat_aura() -> Aura:
	if duration_type == AuraNames.DurationType.TURNS:
		return create_aura()
	else: return null

func expire_aura() -> void:
	expired.emit(self)

#derived subclasses hook onto and override these functions
func setup_aura_stats() -> void:
	pass

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass
