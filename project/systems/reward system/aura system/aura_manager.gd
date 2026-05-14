extends Node2D
class_name AuraManager

var aura_dictionary:Dictionary[String, Aura]

var final_additive_aura:Dictionary[StringName, int]
var final_multiplicative_aura:Dictionary[StringName, int]

var parent_combatant:Combatant

signal send_auras_to_parent(additive_aura_dictionary:Dictionary[StringName, int], multiplicative_aura_dictionary:Dictionary[StringName, int])

func setup(new_parent:Combatant) -> void:
	parent_combatant = new_parent
	update_stats()

func apply_new_aura(new_aura:Aura) -> void:
	if new_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		#then instance a new aura
		new_aura = new_aura.create_aura()
	
	if new_aura.get_id() in aura_dictionary.keys():
		push_warning("overwriting aura: " + new_aura.reward_name + ", on " + parent_combatant.combatant_name)
	
	aura_dictionary[new_aura.get_id()] = new_aura
	update_stats()
	
	if new_aura.visible:
		CombatLogEvents.aura_applied.emit(new_aura, parent_combatant)
		if parent_combatant.is_a_player: HudEvents.reward_added.emit(parent_combatant, new_aura)
	
	new_aura.expired.connect(remove_aura, CONNECT_ONE_SHOT)
	new_aura.updated.connect(update_aura)

func remove_aura(old_aura:Aura) -> void:
	if old_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		push_error("trying to remove an aura that is a template")
	
	if old_aura.get_id() not in aura_dictionary.keys():
		push_warning("tried to remove aura: " + old_aura.reward_name + ", but it wasn't there in the first place. on " + parent_combatant.combatant_name)
	
	aura_dictionary.erase(old_aura.get_id())
	update_stats()
	
	if old_aura.visible:
		CombatLogEvents.aura_removed.emit(old_aura, parent_combatant)
		if parent_combatant.is_a_player: HudEvents.reward_removed.emit(parent_combatant, old_aura)

func get_all_auras() -> Array[Aura]:
	return aura_dictionary.values()

func update_aura() -> void:
	#i don't think i actually do anything? the aura should have already updated before signalling?
	#maybe this should only update one aura? but i have to recalculate it all anyways incase they interact
	update_stats()

func update_stats() -> void:
	merge_auras()
	send_auras_to_parent.emit(final_additive_aura, final_multiplicative_aura)

func merge_auras() -> void:
	final_additive_aura.clear()
	final_multiplicative_aura.clear()
	
	for aura:Aura in aura_dictionary.values():
		for stat:StringName in aura.additive_stat_dictionary:
			add_to_aura_dictionary(final_additive_aura, stat, aura.additive_stat_dictionary[stat])
		
		for stat:StringName in aura.multiplicative_stat_dictionary:
			add_to_aura_dictionary(final_multiplicative_aura, stat, aura.multiplicative_stat_dictionary[stat])

func add_to_aura_dictionary(dictionary_to_update:Dictionary[StringName,int], statName:StringName, value:int) -> void:
	if dictionary_to_update.has(statName):
		dictionary_to_update[statName] += value
	else:
		dictionary_to_update[statName] = value

func on_start_combat() -> void:
	for aura:Aura in aura_dictionary.values(): 
		aura.on_combat_start()

func on_start_turn() -> void:
	for aura:Aura in aura_dictionary.values(): 
		aura.on_combat_start()

func on_after_attack(target:Combatant) -> void:
	for aura:Aura in aura_dictionary.values(): 
		aura.on_attack(parent_combatant, target)

func on_damage_taken(_damage_taken:int) -> void:
	pass #maybe do something here later

func on_end_turn() -> void:
	for aura:Aura in aura_dictionary.values():
		aura.decrement_duration_counter()

func on_combat_end() -> void:
	for aura:Aura in aura_dictionary.values():
		aura.check_if_aura_expired_at_end_of_combat()
