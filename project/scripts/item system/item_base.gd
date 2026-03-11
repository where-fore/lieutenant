extends Resource
class_name Item

@export var item_name:String = "Generic Item"
@export var item_sprite:Texture2D

@export_group("Custom Auras")
enum ApplyType { ON_EQUIP, ON_COMBAT_START, SPECIAL }
@export var aura_application_time:ApplyType = ApplyType.ON_EQUIP
@export var _custom_aura_template:Aura
var _custom_aura:Aura
var _runtime_aura:Aura
var my_additive_stat_dictionary:Dictionary[StringName, int] = {}
var my_multiplicative_stat_dictionary:Dictionary[StringName, int] = {}

@export_group("Custom Tooltip")
@export var custom_tooltip:String = ""

#derived subclasses hook onto these functions
func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass

#derived subclasses hook onto these functions
func on_combat_start() -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass

#derived subclasses hook onto these functions
func on_combat_end() -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass

func restart_custom_auras() -> Aura:
	if aura_application_time == ApplyType.ON_COMBAT_START:
		if _custom_aura_template:
			_custom_aura = null
			return get_custom_aura()
	return null

#derived subclasses hook onto these functions
func setup_item_stats() -> void:
	pass

func get_aura() -> Aura:
	if _runtime_aura: return _runtime_aura
	else:
		initialize_my_aura()
		return _runtime_aura

func initialize_my_aura() -> void:
	setup_item_stats()
	_runtime_aura = Aura.new().create_aura(item_name, false, my_additive_stat_dictionary, my_multiplicative_stat_dictionary)

func get_tooltip() -> String:
	setup_item_stats()
	
	var tooltip_text:String = item_name
	for stat_change:StringName in my_additive_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(my_additive_stat_dictionary[stat_change])
		tooltip_text += "\n" + to_add
	for stat_change:StringName in my_multiplicative_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(my_multiplicative_stat_dictionary[stat_change]*100) + "%"
		tooltip_text += "\n" + to_add
		
	if custom_tooltip: tooltip_text += "\n" + custom_tooltip
	return tooltip_text

func get_custom_aura() -> Aura:
	if _custom_aura: return _custom_aura
	if not _custom_aura_template: return null
	else:
		initialize_my_custom_aura()
		return _custom_aura

func initialize_my_custom_aura() -> void:
	_custom_aura = _custom_aura_template.create_aura("", true)

func applies_aura_on_equip() -> bool:
	if aura_application_time == ApplyType.ON_EQUIP: return true
	else: return false
