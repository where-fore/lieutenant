extends Reward
class_name Aura

var aura_id:String
var extra_tooltip:String
var aura_categories:Array[StringName]
var visible:bool

signal expired(aura_instance:Aura)
signal updated(aura_instance:Aura)

var duration_type:AuraNames.DurationType
var base_duration:int:
	set(value):
		current_duration = value
var current_duration:int

var unique_id:String

var additive_stat_dictionary:Dictionary[StringName, int] = {}
var multiplicative_stat_dictionary:Dictionary[StringName, int] = {}

func _init() -> void:
	setup_aura_stats()

func change_additive_aura(stat:StringName, value:int, add_to_existing:bool = false) -> void:
	change_aura(additive_stat_dictionary, stat, value, add_to_existing)

func change_multiplicative_aura(stat:StringName, value:int, add_to_existing:bool = false) -> void:
	change_aura(multiplicative_stat_dictionary, stat, value, add_to_existing)

func change_aura(aura_dict:Dictionary[StringName, int], stat:StringName, value:int, add_to_existing:bool = false) -> void:
	if add_to_existing:
		aura_dict[stat] = aura_dict.get(stat, 0) + value
	else:
		aura_dict[stat] = value
	updated.emit()

func create_aura(name:String = "", should_be_visible:bool = true, additive_init:Dictionary[StringName, int] = {}, multiplicative_init:Dictionary[StringName, int] = {}) -> Aura:
	var this_aura:Aura = self.duplicate(true)
	
	if name: this_aura.reward_name = name
	if should_be_visible: this_aura.visible = should_be_visible
	
	if additive_init: this_aura.additive_stat_dictionary = additive_init.duplicate()
	else: this_aura.additive_stat_dictionary = additive_stat_dictionary.duplicate()
	if multiplicative_init: this_aura.multiplicative_stat_dictionary = multiplicative_init.duplicate()
	else: this_aura.multiplicative_stat_dictionary = multiplicative_stat_dictionary.duplicate()
	
	if not duration_type: this_aura.duration_type = AuraNames.DurationType.PERMANENT
	if base_duration: this_aura.current_duration = base_duration
	
	return this_aura

func get_id() -> String:
	if not unique_id: unique_id = str(ResourceUID.create_id())
	return unique_id

#this is copied from item_base.gd
func get_tooltip() -> String:
	var to_add:String
	
	var tooltip_text:String = reward_name
	
	if duration_type == AuraNames.DurationType.TURNS:
		to_add = "\n" + "Duration: " + str(current_duration) + " " + AuraNames.DurationType_Labels[duration_type]
	else:
		to_add = "\n" + "Duration: " + AuraNames.DurationType_Labels[duration_type]
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
func on_other_combatant_dying(_newly_dead_combatant:Combatant) -> void:
	pass

func on_damage_taken(_damage_taken:int) -> void:
	pass

func on_attack(_source:Combatant, _target:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

func setup_aura_stats() -> void:
	pass
