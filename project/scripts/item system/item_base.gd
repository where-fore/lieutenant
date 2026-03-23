extends Resource
class_name Item

var item_id:String
var item_name:String
var item_sprite:Texture2D
var extra_tooltip:String
var item_categories:Array[StringName]

enum ApplyType {ON_EQUIP, ON_COMBAT_START, SPECIAL}
var aura_application_time:ApplyType
var custom_aura_template:GDScript
var _custom_aura:Aura

var _runtime_aura:Aura
var additive_stat_dictionary:Dictionary[StringName, int] = {}
var multiplicative_stat_dictionary:Dictionary[StringName, int] = {}

func _init() -> void:
	setup_item_stats()

func restart_custom_auras() -> Aura:
	if aura_application_time == ApplyType.ON_COMBAT_START:
		if custom_aura_template:
			_custom_aura = null
			return get_custom_aura()
	return null

func get_aura() -> Aura:
	if _runtime_aura: return _runtime_aura
	else:
		initialize_my_aura()
		return _runtime_aura

func initialize_my_aura() -> void:
	setup_item_stats()
	_runtime_aura = Aura.new().create_aura(item_name, false, additive_stat_dictionary, multiplicative_stat_dictionary)

#this is copied from aura_base.gd
func get_tooltip() -> String:
	setup_item_stats()
	
	var tooltip_text:String = item_name
	for stat_change:StringName in additive_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(additive_stat_dictionary[stat_change])
		tooltip_text += "\n" + to_add
	for stat_change:StringName in multiplicative_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(multiplicative_stat_dictionary[stat_change]) + "%"
		tooltip_text += "\n" + to_add
		
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text

func get_custom_aura() -> Aura:
	if _custom_aura: return _custom_aura
	if not custom_aura_template: return null
	else:
		initialize_my_custom_aura()
		return _custom_aura

func initialize_my_custom_aura() -> void:
	_custom_aura = custom_aura_template.new().create_aura("", true)

func applies_aura_on_equip() -> bool:
	if aura_application_time == ApplyType.ON_EQUIP: return true
	else: return false


#derived subclasses hook onto and override these functions
func setup_item_stats() -> void:
	push_error("item tried to instantiate without overriding setup_item_stats()")

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass
