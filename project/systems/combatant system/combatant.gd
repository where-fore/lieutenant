extends Node2D
class_name Combatant

var combatant_id:String
var combatant_name:String
var combatant_texture:Texture2D
var combatant_categories:Dictionary[StringName, int]
var extra_tooltip:String

signal stats_updated
signal perished
signal revived

var is_a_player:bool = false
var is_an_enemy:bool = true

var possible_targets:Array[Combatant]
var current_target:Combatant:
	get:
		if not current_target:
			choose_target_this_turn()
			return current_target
		else: return current_target

var active:bool = false
var dead:bool = false

var damage_taken:int = 0:
	set(value):
		damage_taken = value
		emit_stat_update()

var shield:int = 0:
	set(value):
		shield = value
		emit_stat_update()

func get_damaged_health() -> int:
	return current_stats[Stats.health] - damage_taken

var starting_stats:Dictionary[StringName, int] = {}
var current_stats:Dictionary[StringName, int] = {}

var aura_manager:AuraManager
var item_manager:ItemManager

func setup(should_be_a_player:bool = false) -> void:
	reset_current_stats_to_base()
	derive_stats()
	
	active = true
	
	prepare_aura_manager()
	prepare_item_manager()
	
	if should_be_a_player:
		is_a_player = true
		HudEvents.send_player_combatant_to_ui.emit(self)
		
		is_an_enemy = false

func prepare_aura_manager() -> void:
	aura_manager = AuraManager.new()
	add_child(aura_manager)
	aura_manager.setup(self)
	aura_manager.send_auras_to_parent.connect(recalculate_stats)

func prepare_item_manager() -> void:
	item_manager = ItemManager.new()
	add_child(item_manager)
	item_manager.setup(self)

func unsetup() -> void:
	active = false

func take_damage(value:int) -> void:
	if not dead:
		if value < 0: push_error("tried to take negative damage on: " + name)
		elif value == 0: pass
		else:
			if shield:
				shield -= value
				if shield < 0: #ie. shield was overpierced
					var damage_to_take:int = shield * -1 #take damage equal to the overkill
					shield = 0 #remove vestigial negative shield
					self.damage_taken += damage_to_take
			else:
				self.damage_taken += value
			
			CombatEvents.damage_applied.emit(self, value)
			check_if_dead_now()
		
		on_damage_taken_functions(value)

func heal(value:int) -> void:
	if not dead:
		if value < 0: push_error("tried to heal for less than 0 on: " + name)
		elif value == 0: pass
		else:
			self.damage_taken -= value
			CombatEvents.healing_applied.emit(self, value)

func apply_shield(value:int) -> void:
	shield += value
	if shield < 0: shield = 0

func remove_shield(value:int) -> void:
	shield -= value
	if shield < 0: shield = 0

func reset_current_stats_to_base() -> void:
	if not starting_stats.has(Stats.crit_multi):
		starting_stats[Stats.crit_multi] = Stats.base_crit_multi
		
	current_stats = starting_stats.duplicate()

func check_if_dead_now() -> void:
	if get_damaged_health() <= 0 and CombatEvents.combat_ongoing:
		perish()

func perish() -> void:
	dead = true
	CombatEvents.combatant_died.emit(self)
	perished.emit()

func unperish() -> void:
	dead = false
	revived.emit()

func take_turn() -> void:
	on_start_turn_functions()
	
	if not dead:
		var amount_to_attack_for:int = current_stats[Stats.attack]
		
		if current_stats.has(Stats.crit_chance):
			var roll:int = randi_range(1, 100)
			if roll <= current_stats[Stats.crit_chance]:
				var multiplier:float = float(current_stats[Stats.crit_multi]) / 100.0
				amount_to_attack_for = int(amount_to_attack_for * multiplier)
		
		CombatEvents.attack_launched.emit(self, amount_to_attack_for, current_target)
		on_after_attack_functions(current_target)
	
	on_end_turn_functions()

func choose_target_this_turn() -> void:
	if not possible_targets:
		push_error("tried to choose a target, but i have my possible targets array is null")
	else:
		var choices:Array[Combatant]
		for possible_target:Combatant in possible_targets:
			if not possible_target.dead:
				choices.append(possible_target)
		current_target = choices.pick_random()

func reset_for_next_combat() -> void:
	shield = 0
	self.damage_taken = 0
	unperish()
	possible_targets.clear()

func recalculate_stats(additive_aura_dictionary:Dictionary[StringName, int], multiplicative_aura_dictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()
	
	#cut primaries out, so i can work them separately
	var primary_stats:Array[StringName] = [Stats.strength, Stats.dexterity, Stats.intelligence]
	var primary_stat_additive_dictionary:Dictionary[StringName, int]
	var primary_stat_multiplicative_dictionary:Dictionary[StringName, int]
	for stat:StringName in additive_aura_dictionary.keys():
		if stat in primary_stats:
			primary_stat_additive_dictionary[stat] = additive_aura_dictionary[stat]
			additive_aura_dictionary.erase(stat)
	for stat:StringName in multiplicative_aura_dictionary.keys():
		if stat in primary_stats:
			primary_stat_multiplicative_dictionary[stat] = multiplicative_aura_dictionary[stat]
			multiplicative_aura_dictionary.erase(stat)
	
	#figure out primaries first
	sum_aura_and_current_stats(primary_stat_additive_dictionary)
	multiply_aura_and_current_stats(primary_stat_multiplicative_dictionary)
	derive_stats()
	
	#figure out derived next
	sum_aura_and_current_stats(additive_aura_dictionary)
	multiply_aura_and_current_stats(multiplicative_aura_dictionary)
	
	emit_stat_update()
	check_if_dead_now()

func derive_stats() -> void:
	var strength:int = current_stats.get(Stats.strength, 0)
	var dexterity:int = current_stats.get(Stats.dexterity, 0)
	#var intelligence:int = current_stats.get(Stats.intelligence, 0)
	
	var attack_to_add:int = strength/Stats.strength_per_attack + dexterity/Stats.dexterity_per_attack
	var health_to_add:int = strength/Stats.strength_per_health
	var crit_to_add:int = dexterity/Stats.dexterity_per_crit_percent
	
	current_stats[Stats.attack] = current_stats.get(Stats.attack, 0) + attack_to_add
	current_stats[Stats.health] = current_stats.get(Stats.health, 0) + health_to_add
	current_stats[Stats.crit_chance] = current_stats.get(Stats.crit_chance, 0) + crit_to_add

func sum_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if not current_stats.has(stat):
			current_stats[stat] = auraDictionary[stat]
		else:
			current_stats[stat] += auraDictionary[stat]

func multiply_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if current_stats.has(stat):
			var multiplier:float = (100.0 + float(auraDictionary[stat]))/100.0
				#note that int() truncates, as i want
			current_stats[stat] = int(current_stats[stat] * multiplier)
		#else do nothing, no stat to multiply so all good

func apply_aura_or_item(reward:Reward) -> void:
	if reward is Item: item_manager.equip_item(reward)
	elif reward is Aura: aura_manager.apply_new_aura(reward)
	else: push_error("tried to apply a non-item/aura reward \"", reward.reward_name, "\" to combatant: ", combatant_name)

func remove_aura_or_item(reward:Reward) -> void:
	if reward is Item: item_manager.unequip_item(reward)
	elif reward is Aura: aura_manager.remove_aura(reward)
	else: push_error("tried to apply a non-item/aura reward \"", reward.reward_name, "\" to combatant: ", combatant_name)

func get_all_items() -> Array[Item]:
	return item_manager.get_all_equipped_items()

func get_all_auras() -> Array[Aura]:
	return aura_manager.get_all_auras()

func get_shield_from_int() -> void:
	var shield_to_add:int = current_stats.get(Stats.intelligence, 0) / Stats.intelligence_per_shield_per_turn
	shield += shield_to_add

#this is copied from aura_base.gd
func get_tooltip() -> String:
	var tooltip_text:String = name
	
	var to_add:String
	to_add = "Health:" + str(starting_stats[Stats.health])
	tooltip_text += "\n" + to_add
	to_add = "Attack:" + str(starting_stats[Stats.attack])
	tooltip_text += "\n" + to_add
	
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text

func emit_stat_update() -> void:
	stats_updated.emit()

func scale_stats_basic_exponential(tile_scaling_factor:int) -> void:
	var base:float = 1.18
	var scaling_factor:float = base ** tile_scaling_factor
	var stats_to_scale:Array[StringName] = [
		Stats.strength,
		Stats.dexterity,
		Stats.intelligence,
		Stats.health,
		Stats.attack,
	]
	for stat:StringName in stats_to_scale:
		if starting_stats.has(stat):
			#print("stat ", stat, " was ", starting_stats[stat])
			starting_stats[stat] = int(scaling_factor * starting_stats[stat])
			#print("stat ", stat, " is now ", starting_stats[stat])
	
	#starting_stats[Stats.health] = starting_stats[Stats.health] * BalanceData.enemy_beginning_health_scaling / 100 + (power * starting_stats[Stats.health] * BalanceData.enemy_health_scaling_per_power)/100
	#starting_stats[Stats.attack] = starting_stats[Stats.attack] + (power * starting_stats[Stats.attack] * BalanceData.enemy_attack_scaling_per_power)/100


#calling functions on other things
func on_start_combat_functions() -> void:
	on_start_combat()
	item_manager.on_start_combat()
	aura_manager.on_start_combat()

func on_start_turn_functions() -> void:
	choose_target_this_turn()
	
	on_start_turn()
	item_manager.on_start_turn()
	aura_manager.on_start_turn()
	
	get_shield_from_int()
	
	CombatEvents.combatant_turn_started.emit(self)

func on_after_attack_functions(chosen_target:Combatant) -> void:
	on_after_attack()
	item_manager.on_after_attack(chosen_target)
	aura_manager.on_after_attack(chosen_target)
	CombatEvents.combatant_finished_attack.emit(self, chosen_target)

func on_damage_taken_functions(amount_taken:int) -> void:
	on_damage_taken(amount_taken)
	item_manager.on_damage_taken(amount_taken)
	aura_manager.on_damage_taken(amount_taken)
	CombatEvents.combatant_damaged.emit(self, amount_taken)

func on_end_turn_functions() -> void:
	on_end_turn()
	item_manager.on_end_turn()
	aura_manager.on_end_turn()
	CombatEvents.combatant_turn_ended.emit(self)

func on_end_combat_functions() -> void:
	on_combat_end()
	item_manager.on_combat_end()
	aura_manager.on_combat_end()
	reset_for_next_combat()


#derived subclasses hook onto these functions
func on_start_combat() -> void:
	pass

func on_start_turn() -> void:
	pass

func on_after_attack() -> void:
	pass

func on_damage_taken(_amount_taken:int) -> void:
	pass

func on_end_turn() -> void:
	pass

func on_combat_end() -> void:
	pass

func setup_stats() -> void:
	pass
