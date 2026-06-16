extends Resource
class_name Combatant

var resource_path_id:String
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
var current_target:Combatant
var targeting_behaviour_function:bool = false
var target_attribute:StringName = Stats.strength
var target_highest_of_attribute:bool = true
var targeting_behaviour_preset:TargetingPreset = TargetingPreset.NONE
enum TargetingPreset {
	NONE,
	RANDOM,
	#MOST_DAMAGE_DEALT,
	#LOWEST_PERCENT_HP,
}
var allies:Array[Combatant]


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

var base_rounds_can_fight:int = 150
var current_rounds_can_fight:int

func get_damaged_health() -> int:
	return current_stats[Stats.health] - damage_taken

var starting_stats:Dictionary[StringName, int] = {}
var current_stats:Dictionary[StringName, int] = {}

var starting_items:Array[Item]
var starting_auras:Array[Aura]

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
	
	CombatEvents.combatant_died.connect(on_other_combatant_dying_functions)

func unsetup() -> void:
	active = false
	CombatEvents.combatant_died.disconnect(on_other_combatant_dying_functions)

func prepare_aura_manager() -> void:
	aura_manager = AuraManager.new()
	aura_manager.setup(self)
	aura_manager.send_auras_to_parent.connect(recalculate_stats)
	
	for aura:Aura in starting_auras:
		aura_manager.apply_new_aura(aura, false)

func prepare_item_manager() -> void:
	item_manager = ItemManager.new()
	item_manager.setup(self)
	
	for item:Item in starting_items:
		item_manager.equip_item(item, false)


func take_damage(damage_to_take:int, source:Combatant) -> void:
	if dead:
		return
	
	if damage_to_take < 0:
		push_error("tried to take negative damage on: " + combatant_name)
		return
	elif damage_to_take == 0:
		return
	
	if shield:
		var shield_absorbed:int
		if shield > damage_to_take:
			shield_absorbed = damage_to_take
			damage_to_take = 0
		else:
			shield_absorbed = shield
			damage_to_take -= shield_absorbed
		
		shield -= shield_absorbed
		CombatLogEvents.shield_absorbed.emit(self, shield_absorbed)

	self.damage_taken += damage_to_take
	CombatEvents.damage_applied.emit(self, damage_to_take)
	check_if_dead_now()
	
	on_damage_taken_functions(damage_to_take, source)

func heal(amount_healed:int) -> void:
	if not dead:
		if amount_healed < 0: push_error("tried to heal for less than 0 on: " + combatant_name)
		elif amount_healed == 0: pass
		else:
			self.damage_taken -= amount_healed
			CombatEvents.healing_applied.emit(self, amount_healed)

func apply_shield(value:int) -> void:
	shield += value
	if shield < 0: shield = 0

func remove_shield(value:int) -> void:
	shield -= value
	if shield < 0: shield = 0

func reset_current_stats_to_base() -> void:
	#if not starting_stats.has(Stats.crit_multi):
		#starting_stats[Stats.crit_multi] = Stats.base_crit_multi
	
	current_stats = starting_stats.duplicate()

func check_if_dead_now() -> void:
	if get_damaged_health() <= 0 and CombatEvents.combat_ongoing:
		perish()

func perish_from_exhaustion() -> void:
	if not dead:
		CombatLogEvents.custom_message.emit(str(combatant_name, " has fought too long, and succumbs to the exhaustion of combat."))
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
		
		#if current_stats.has(Stats.crit_chance):
			#var roll:int = randi_range(1, 100)
			#if roll <= current_stats[Stats.crit_chance]:
				#var multiplier:float = float(current_stats[Stats.crit_multi]) / 100.0
				#amount_to_attack_for = int(amount_to_attack_for * multiplier)
		
		CombatEvents.attack_launched.emit(self, amount_to_attack_for, current_target)
		on_after_attack_functions(current_target)
	
	on_end_turn_functions()

func choose_target_this_turn() -> void:
	var chosen_target:Combatant
	
	if not possible_targets:
		push_error("tried to choose a target, but i have my possible targets array is null")
		return #stops the entire function here
	
	if targeting_behaviour_function:
		choose_targets_override()
	elif targeting_behaviour_preset != TargetingPreset.NONE:
		if targeting_behaviour_preset == TargetingPreset.RANDOM:
			chosen_target = choose_random_target()
		#elif targeting_behaviour_preset == TargetingPreset.OTHER_PRESET:
			#do other stuff
	elif target_attribute:
		chosen_target = choose_target_by_stat(target_attribute, target_highest_of_attribute)
	else: push_error(combatant_name, " has a targeting confusion")
	
	_choose_target(chosen_target)

func _choose_target(chosen_target:Combatant) -> void:
	if current_target == chosen_target:
		return #stop the entire function here
	
	if is_an_enemy:
		CombatLogEvents.custom_message.emit(str(combatant_name, " sets their gaze on ", chosen_target.combatant_name))
	
	current_target = chosen_target

func choose_random_target() -> Combatant:
	var choices:Array[Combatant]
	for possible_target:Combatant in possible_targets:
		if not possible_target.dead:
			choices.append(possible_target)
	return choices.pick_random()

func choose_target_by_stat(stat_to_compare:StringName, highest:bool) -> Combatant:
	var top_choice:Combatant = null
	
	for possible_target:Combatant in possible_targets:
		if possible_target.dead:
			continue #skip to next step of the for loop
		
		if not top_choice:
			top_choice = possible_target
			continue #skip to next step of the for loop
		
		var this_target_stat:int = possible_target.current_stats.get(stat_to_compare, 0)
		var top_target_stat:int = top_choice.current_stats.get(stat_to_compare, 0)
		if highest:
			if this_target_stat > top_target_stat:
				top_choice = possible_target
		elif not highest:
			if this_target_stat < top_target_stat:
				top_choice = possible_target
		#note this never displaces when equalling - if all possible targets have the same value,
		#it just targets left most / first put into the array
		
	return top_choice

func reset_for_next_combat() -> void:
	shield = 0
	self.damage_taken = 0
	unperish()
	possible_targets.clear()

func recalculate_stats(additive_aura_dictionary:Dictionary[StringName, int], multiplicative_aura_dictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()
	
	#cut primaries out, so i can work them separately
	var primary_stats:Array[StringName] = Stats.attributes
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
	
	#make sure nothing's negative
	floor_stats_to_zero()
	
	emit_stat_update()
	check_if_dead_now()

func derive_stats() -> void:
	var strength:int = current_stats.get(Stats.strength, 0)
	var agility:int = current_stats.get(Stats.agility, 0)
	#var mind:int = current_stats.get(Stats.mind, 0) #currently doesn't derive anything
	var fortitude:int = current_stats.get(Stats.fortitude, 0)
	
	var attack_to_add:int = strength/Stats.strength_per_attack + agility/Stats.agility_per_attack
	var health_to_add:int = strength/Stats.strength_per_health + agility/Stats.agility_per_health + fortitude/Stats.fortitude_per_health
	
	current_stats[Stats.attack] = current_stats.get(Stats.attack, 0) + attack_to_add
	current_stats[Stats.health] = current_stats.get(Stats.health, 0) + health_to_add

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

func floor_stats_to_zero() -> void:
	for stat:StringName in current_stats:
		if current_stats[stat] < 0: current_stats[stat] = 0

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
	var shield_to_add:int = current_stats.get(Stats.mind, 0) / Stats.mind_per_shield_per_turn
	shield += shield_to_add

#this is copied from aura_base.gd
func get_tooltip() -> String:
	var tooltip_text:Array[String] = [combatant_name]
	
	var to_add:String
	var stats_to_check:Dictionary[StringName, int]
	if not current_stats: stats_to_check = starting_stats
	else: stats_to_check = current_stats
	for stat:StringName in stats_to_check:
		if stats_to_check[stat] != 0:
			to_add = stat + ": " + str(stats_to_check[stat])
			tooltip_text.append(to_add)
	
	if is_an_enemy:
		var to_add_target:String
		if targeting_behaviour_function or targeting_behaviour_preset:
			if targeting_behaviour_preset == TargetingPreset.RANDOM:
				to_add_target = "Targets: Randomly"
			else:
				to_add_target = "Targets: Special"
		else:
			var to_add_targeting:Array[String] = ["Targets:"]
			
			if target_highest_of_attribute: to_add_targeting.append("Highest")
			else: to_add_targeting.append("Lowest")
			to_add_targeting.append(target_attribute)
			
			to_add_target = " ".join(to_add_targeting)
		tooltip_text.append(to_add_target)
	
	if extra_tooltip:
		tooltip_text.append("")
		tooltip_text.append(extra_tooltip)
	
	return "\n".join(tooltip_text)

func emit_stat_update() -> void:
	stats_updated.emit()

func scale_stats_to_day() -> void:
	#var base:float = 1.18
	#var scaling_factor:float = base ** TimeOfDay.current_day
	
	scale_starting_stats_to_factor(BalanceData.enemy_stat_scaling_per_day)

func scale_starting_stats_to_factor(scaling_factor:float) -> void:
	var stats_to_scale:Array[StringName] = Stats.attributes.duplicate()
	stats_to_scale.append(Stats.health)
	stats_to_scale.append(Stats.attack)
	
	for stat:StringName in stats_to_scale:
		if starting_stats.has(stat):
			#print(combatant_name, ": , ", stat, " was: ", starting_stats[stat])
			starting_stats[stat] = int(scaling_factor * starting_stats[stat])
			#print(combatant_name, ": , ", stat, " is now: ", starting_stats[stat])

#calling functions on other things

#specific events
func on_damage_taken_functions(amount_taken:int, source:Combatant) -> void:
	on_damage_taken(amount_taken, source)
	item_manager.on_damage_taken(amount_taken, source)
	aura_manager.on_damage_taken(amount_taken, source)
	CombatEvents.combatant_damaged.emit(self, amount_taken)

func on_other_combatant_dying_functions(newly_dead_combatant:Combatant) -> void:
	#if not dead:
	#maybe all triggers should check this? maybe not?
	if newly_dead_combatant != self:
		on_other_combatant_dying(newly_dead_combatant)
		item_manager.on_other_combatant_dying(newly_dead_combatant)
		aura_manager.on_other_combatant_dying(newly_dead_combatant)

#timing events
func on_start_combat_functions() -> void:
	current_rounds_can_fight = base_rounds_can_fight
	
	on_start_combat()
	item_manager.on_start_combat()
	aura_manager.on_start_combat()

func on_start_turn_functions() -> void:
	choose_target_this_turn()
	
	on_start_turn()
	item_manager.on_start_turn()
	aura_manager.on_start_turn()
	
	if not dead:
		get_shield_from_int()
	
	CombatEvents.combatant_turn_started.emit(self)

func on_after_attack_functions(chosen_target:Combatant) -> void:
	on_after_attack()
	item_manager.on_after_attack(chosen_target)
	aura_manager.on_after_attack(chosen_target)
	CombatEvents.combatant_finished_attack.emit(self, chosen_target)

func on_end_turn_functions() -> void:
	if current_rounds_can_fight <= 0:
		perish_from_exhaustion()
	else: current_rounds_can_fight -= 1
	
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

#specific events
func on_damage_taken(_amount_taken:int, _source:Combatant) -> void:
	pass

func on_other_combatant_dying(_newly_dead_combatant:Combatant) -> void:
	pass

func choose_targets_override() -> void:
	pass

#timing events
func on_start_combat() -> void:
	pass

func on_start_turn() -> void:
	pass

func on_after_attack() -> void:
	pass

func on_end_turn() -> void:
	pass

func on_combat_end() -> void:
	pass

#setup events
func setup_stats() -> void:
	pass
