extends Resource
class_name ItemData

@export var item_name: String = "Generic Item"
@export var item_sprite: Texture2D
var custom_tooltip: String = ""
@export var _custom_aura_template: Aura
var _custom_aura: Aura
var _aura: Aura
var my_additive_stat_dictionary:Dictionary[StringName, int] = {}
var my_multiplicative_stat_dictionary:Dictionary[StringName, int] = {}


#derived subclasses hook onto these functions
func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " attacked with " + item_name)
	pass

#derived subclasses hook onto these functions
func setup_item_stats() -> void:
	pass

func add_custom_tooltip(custom_tooltip_text: String) -> void:
	custom_tooltip += custom_tooltip_text

func get_aura() -> Aura:
	if _aura: return _aura
	else:
		initialize_my_aura()
		return _aura

func initialize_my_aura() -> void:
	setup_item_stats()
	_aura = Aura.new()
	_aura.additive_dictionary = my_additive_stat_dictionary.duplicate() as Dictionary[StringName, int]
	_aura.multiplicative_dictionary = my_multiplicative_stat_dictionary.duplicate() as Dictionary[StringName, int]

func get_custom_aura() -> Aura:
	if _custom_aura: return _custom_aura
	if not _custom_aura_template: return null
	else:
		initialize_my_custom_aura()
		return _custom_aura

func initialize_my_custom_aura() -> void:
	_custom_aura = Aura.new()
	_custom_aura_template.setup_aura_stats()
	_custom_aura.additive_dictionary = _custom_aura_template.additive_dictionary.duplicate() as Dictionary[StringName, int]
	_custom_aura.multiplicative_dictionary = _custom_aura_template.multiplicative_dictionary.duplicate() as Dictionary[StringName, int]
	_custom_aura.unique_id = _custom_aura_template.unique_id
