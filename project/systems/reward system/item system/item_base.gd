extends Reward
class_name Item

var resource_path_id:String
var extra_tooltip:String
var item_categories:Dictionary[StringName, int]

var parent_combatant:Combatant

var custom_aura_templates:Array[GDScript]
var _custom_auras:Array[Aura]
signal custom_aura_added(new_aura:Aura)
signal custom_aura_removed(old_aura:Aura)

var _runtime_aura:Aura
var additive_stat_dictionary:Dictionary[StringName, int] = {}
var multiplicative_stat_dictionary:Dictionary[StringName, int] = {}

func _init() -> void:
	setup_item_stats()

func setup(new_parent_combatant:Combatant) -> void:
	parent_combatant = new_parent_combatant

func get_aura() -> Aura:
	if _runtime_aura: return _runtime_aura
	else:
		initialize_my_aura()
		return _runtime_aura

func initialize_my_aura() -> void:
	setup_item_stats()
	_runtime_aura = Aura.new().create_aura(reward_name, false, additive_stat_dictionary, multiplicative_stat_dictionary)

#this is copied from aura_base.gd
func get_tooltip() -> String:
	setup_item_stats()
	
	var tooltip_text:String = reward_name
	for stat_change:StringName in additive_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(additive_stat_dictionary[stat_change])
		tooltip_text += "\n" + to_add
	for stat_change:StringName in multiplicative_stat_dictionary:
		var to_add:String = str(stat_change) + " increased by " + str(multiplicative_stat_dictionary[stat_change]) + "%"
		tooltip_text += "\n" + to_add
		
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text

func create_new_threshold(thresholds_to_check:Dictionary[StringName, int], percent_of_max_hp:int = 0) -> ThresholdBehaviour:
	var new_threshold_behaviour:ThresholdBehaviour = ThresholdBehaviour.new()
	new_threshold_behaviour.state_changed.connect(threshold_state_changed)
	new_threshold_behaviour.setup(parent_combatant, thresholds_to_check, percent_of_max_hp)
	
	return new_threshold_behaviour

func create_new_custom_aura(duration_type:AuraNames.DurationType, aura_name:String = "", aura_icon:Texture2D = null, duration_length:int = 0) -> Aura:
	var new_aura_name:String
	if aura_name: new_aura_name = aura_name
	else: new_aura_name = reward_name
	
	var new_aura_icon:Texture2D
	if aura_icon: new_aura_icon = aura_icon
	else: new_aura_icon = reward_sprite
	
	var new_aura:Aura = Aura.new().create_aura(new_aura_name)
	
	new_aura.duration_type = duration_type
	if duration_type == AuraNames.DurationType.TURNS:
		if duration_length:
			new_aura.base_duration = duration_length
		else:
			push_error("was told to make a custom aura for X turns, but was not supplied an X, for item: ", reward_name)
	
	new_aura.reward_sprite = new_aura_icon
	
	add_to_custom_auras(new_aura)
	return new_aura

func get_custom_auras() -> Array[Aura]:
	if _custom_auras: return _custom_auras
	if not custom_aura_templates: return []
	else:
		initialize_my_custom_auras()
		return _custom_auras

func initialize_my_custom_auras() -> void:
	for template:GDScript in custom_aura_templates:
		_custom_auras.append(template.new().create_aura("", true))

func add_to_custom_auras(new_aura:Aura) -> void:
	if new_aura:
		_custom_auras.append(new_aura)
		custom_aura_added.emit(new_aura)
	else:
		push_error("somehow tried to add a null aura")

func remove_from_custom_auras(old_aura:Aura) -> void:
	if old_aura:
		_custom_auras.erase(old_aura)
		custom_aura_removed.emit(old_aura)
	else:
		push_error("somehow tried to remove a null aura")

#derived subclasses hook onto and override these functions
func setup_item_stats() -> void:
	push_error("item tried to instantiate without overriding setup_item_stats(): ", get_script().resource_path)

func on_equip() -> void:
	pass

func on_combat_start() -> void:
	pass

func on_turn_start(_source:Combatant) -> void:
	pass

func on_attack(_source:Combatant, _target:Combatant) -> void:
	pass

func on_damage_taken(_source:Combatant, _amount_taken:int) -> void:
	pass

func on_turn_end(_source:Combatant) -> void:
	pass

func on_combat_end() -> void:
	pass

func threshold_state_changed(_threshold:ThresholdBehaviour) -> void:
	pass
