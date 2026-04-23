extends Node2D
class_name Combatant

var combatant_id:String
var combatant_name:String
var combatant_texture:Texture2D
var combatant_categories:Dictionary[StringName, int]
var extra_tooltip:String

signal stats_updated
signal perished

var base_health:int
var base_attack:int

var scaled_health:int:
	get:
		if not scaled_health: return base_health
		else: return scaled_health
var scaled_attack:int:
	get:
		if not scaled_attack: return base_attack
		else: return scaled_attack

var is_a_player:bool = false
var is_an_enemy:bool = true

var possible_targets:Array[Combatant]
var current_target:Combatant

var active:bool = false
var dead:bool = false

var damage_taken:int = 0:
	set(value):
		damage_taken = value
		emit_stat_update()

func get_damaged_health() -> int:
	return current_stats[Stats.health] - damage_taken

var starting_stats:Dictionary[StringName, int] = {}
var current_stats:Dictionary[StringName, int] = {}

var aura_manager:AuraManager
var item_manager:ItemManager



func setup(should_be_a_player:bool = false) -> void:
	if should_be_a_player:
		is_a_player = true
		is_an_enemy = false
	
	starting_stats[Stats.health] = scaled_health
	starting_stats[Stats.attack] = scaled_attack
	reset_current_stats_to_base()
	
	active = true
	
	prepare_aura_manager()
	prepare_item_manager()

func prepare_aura_manager() -> void:
	aura_manager = AuraManager.new()
	add_child(aura_manager)
	aura_manager.send_auras_to_parent.connect(recalculate_stats)

func prepare_item_manager() -> void:
	item_manager = ItemManager.new()
	add_child(item_manager)

func unsetup() -> void:
	active = false

func take_damage(value:int) -> void:
	if not dead:
		if value < 0: push_error("tried to take negative damage on: " + name)
		elif value == 0: pass
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

func reset_current_stats_to_base() -> void:
	current_stats = starting_stats.duplicate()

func check_if_dead_now() -> void:
	if get_damaged_health() <= 0 and CombatEvents.combat_ongoing:
		perish()

func perish() -> void:
	dead = true
	CombatEvents.combatant_died.emit(self)
	perished.emit()

func take_turn() -> void:
	on_start_turn_functions()
	
	if not dead:
		CombatEvents.attack_launched.emit(self, current_stats[Stats.attack], current_target)
		on_after_attack_functions(current_target)
	
	on_end_turn_functions()

func choose_target_this_turn() -> void:
	var choices:Array[Combatant]
	for possible_target:Combatant in possible_targets:
		if not possible_target.dead:
			choices.append(possible_target)
	current_target = choices.pick_random()

func reset_for_next_combat() -> void:
	self.damage_taken = 0
	dead = false
	possible_targets.clear()

func recalculate_stats(additive_aura_dictionary:Dictionary[StringName, int], multiplicative_aura_dictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()

	sum_aura_and_base_stats(additive_aura_dictionary)
	multiply_aura_and_current_stats(multiplicative_aura_dictionary)
	
	emit_stat_update()
	check_if_dead_now()

func sum_aura_and_base_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if starting_stats.has(stat):
			current_stats[stat] = auraDictionary[stat] + starting_stats[stat]
		else:
			current_stats[stat] = auraDictionary[stat]
		if current_stats[stat] < 0:
			current_stats[stat] = 0
			#print_debug("raising stat from negative to 0: " + stat)

func multiply_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if current_stats.has(stat):
			var multiplier:float = (100.0 + float(auraDictionary[stat]))/100.0
			#note that int() truncates, as i want
			current_stats[stat] = int(current_stats[stat] * multiplier)

func apply_aura_or_item(reward:Reward) -> void:
	if reward is Item: item_manager.equip_item(reward)
	elif reward is Aura: aura_manager.apply_new_aura(reward)
	else: push_error("tried to apply a non-item/aura reward \"", reward.reward_name, "\" to combatant: ", combatant_name)

func remove_aura_or_item(reward:Reward) -> void:
	if reward is Item: item_manager.unequip_item(reward)
	elif reward is Aura: aura_manager.remove_aura(reward)
	else: push_error("tried to apply a non-item/aura reward \"", reward.reward_name, "\" to combatant: ", combatant_name)

#this is copied from aura_base.gd
func get_tooltip() -> String:
	var tooltip_text:String = name
	
	var to_add:String
	to_add = "Health:" + str(scaled_health)
	tooltip_text += "\n" + to_add
	to_add = "Attack:" + str(scaled_attack)
	tooltip_text += "\n" + to_add
	
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text

func emit_stat_update() -> void:
	stats_updated.emit()

func on_start_combat_functions() -> void:
	on_start_combat()
	item_manager.on_start_combat()
	aura_manager.on_start_combat()

func on_start_turn_functions() -> void:
	choose_target_this_turn()
	
	on_start_turn()
	item_manager.on_start_turn()
	aura_manager.on_start_turn()
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

func scale_stats(power:int) -> void:
	scaled_health = base_health * BalanceData.enemy_beginning_health_scaling / 100 + (power * base_health * BalanceData.enemy_health_scaling_per_power)/100
	scaled_attack = base_attack + (power * base_attack * BalanceData.enemy_attack_scaling_per_power)/100
