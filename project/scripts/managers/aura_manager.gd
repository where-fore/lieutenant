extends Node2D

var player_aura_dictionary:Dictionary[String, Aura]
var enemy_aura_dictionary:Dictionary[String, Aura]

var player_final_additive_aura:Dictionary[StringName, int]
var player_final_multiplicative_aura:Dictionary[StringName, int]
var enemy_final_additive_aura:Dictionary[StringName, int]
var enemy_final_multiplicative_aura:Dictionary[StringName, int]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AuraEvents.initalize_combat_stats.connect(update_stats)
	AuraEvents.updated_aura.connect(update_aura)
	HudEvents.combat_won.connect(grow_enemies)
	AuraEvents.restart_game.connect(reset_to_starting_stats)
	AuraEvents.give_aura_to_player.connect(apply_new_aura_to_player)
	AuraEvents.remove_aura_from_player.connect(remove_aura_from_player)
	AuraEvents.give_aura_to_enemy.connect(apply_new_aura_to_enemy)
	AuraEvents.remove_aura_from_enemy.connect(remove_aura_from_enemy)
	CombatEvents.turn_finished.connect(turn_end_duration_check)
	AuraEvents.expired_aura.connect(remove_expired_aura)
	CombatEvents.combat_finished.connect(remove_end_of_combat_auras)
	CombatEvents.combat_finished.connect(on_combat_end)
	CombatEvents.combat_started.connect(on_combat_start)
	#this is unreadable programmer shorthand for "throw away all arguments but the one i care about, "attacker"
	@warning_ignore("untyped_declaration")
	CombatEvents.attack_launched.connect(func(attacker:Combatant, _other_arg): on_attack(attacker))


func reset_to_starting_stats() -> void:
	AuraEvents.encounters_defeated_for_scaling = 0
	player_aura_dictionary.clear()
	enemy_aura_dictionary.clear()

func grow_enemies() -> void:
	AuraEvents.encounters_defeated_for_scaling += 1

func apply_new_aura_to_player(new_aura:Aura) -> void:
	if new_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		#then instance a new aura
		new_aura = new_aura.create_aura()
	if new_aura.unique_id in player_aura_dictionary.keys(): push_warning("overwriting aura: " + new_aura.aura_name)
	if new_aura.visible: CombatLogEvents.aura_applied.emit(new_aura)
	player_aura_dictionary[new_aura.unique_id] = new_aura
	update_stats()
	
func remove_aura_from_player(old_aura:Aura) -> void:
	if old_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		push_error("trying to remove an aura that is a template")
	player_aura_dictionary.erase(old_aura.unique_id)
	update_stats()

func apply_new_aura_to_enemy(new_aura:Aura) -> void:
	if new_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		#then instance a new aura
		new_aura = new_aura.create_aura()
	if new_aura.unique_id in enemy_aura_dictionary.keys(): push_warning("overwriting aura: " + new_aura.aura_name)
	if new_aura.visible: CombatLogEvents.aura_applied.emit(new_aura)
	enemy_aura_dictionary[new_aura.unique_id] = new_aura
	update_stats()
	
func remove_aura_from_enemy(old_aura:Aura) -> void:
	if old_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		push_error("trying to remove an aura that is a template")
	enemy_aura_dictionary.erase(old_aura.unique_id)
	update_stats()

func update_aura(_aura:Aura) -> void:
	#i don't think i actually do anything? the aura should have already dynamically updated?
	#maybe this should only update one aura? but i have to recalculate it all anyways incase they interact
	update_stats()

func update_stats() -> void:
	merge_auras()
	AuraEvents.send_auras_to_combatants.emit(player_final_additive_aura, player_final_multiplicative_aura, enemy_final_additive_aura, enemy_final_multiplicative_aura)

func merge_auras() -> void:
	player_final_additive_aura.clear()
	player_final_multiplicative_aura.clear()
	enemy_final_additive_aura.clear()
	enemy_final_multiplicative_aura.clear()

	for aura_id:String in player_aura_dictionary:
		for stat:StringName in player_aura_dictionary[aura_id].additive_stat_dictionary:
			add_to_aura_dictionary(player_final_additive_aura, stat, player_aura_dictionary[aura_id].additive_stat_dictionary[stat])
		
		for stat:StringName in player_aura_dictionary[aura_id].multiplicative_stat_dictionary:
			add_to_aura_dictionary(player_final_multiplicative_aura, stat, player_aura_dictionary[aura_id].multiplicative_stat_dictionary[stat])
		
	for aura_id:String in enemy_aura_dictionary:
		for stat:StringName in enemy_aura_dictionary[aura_id].additive_stat_dictionary:
			add_to_aura_dictionary(enemy_final_additive_aura, stat, enemy_aura_dictionary[aura_id].additive_stat_dictionary[stat])
		
		for stat:StringName in enemy_aura_dictionary[aura_id].multiplicative_stat_dictionary:
			add_to_aura_dictionary(enemy_final_multiplicative_aura, stat, enemy_aura_dictionary[aura_id].multiplicative_stat_dictionary[stat])

func add_to_aura_dictionary(dictionary_to_update:Dictionary[StringName,int], statName:StringName, value:int) -> void:
	if dictionary_to_update.has(statName):
		dictionary_to_update[statName] += value
	else:
		dictionary_to_update[statName] = value

func turn_end_duration_check(whose_turn_just_ended:Combatant) -> void:
	if whose_turn_just_ended.is_the_player:
		for aura:Aura in player_aura_dictionary.values():
			aura.decrement_duration_counter(whose_turn_just_ended)
	
	if whose_turn_just_ended.is_an_enemy:
		for aura:Aura in enemy_aura_dictionary.values():
			aura.decrement_duration_counter(whose_turn_just_ended)

func remove_end_of_combat_auras(all_combatants:Array[Combatant]) -> void:
	var player:Combatant
	var enemy:Combatant
	for combatant:Combatant in all_combatants:
		if combatant.is_the_player: player = combatant
		if not combatant.is_the_player: enemy = combatant

	if player:
		for aura:Aura in player_aura_dictionary.values():
			aura.check_then_remove_combat_auras(player)
		
	if enemy:
		for aura:Aura in enemy_aura_dictionary.values():
			aura.check_then_remove_combat_auras(enemy)

func remove_expired_aura(source:Combatant, expired_aura:Aura) -> void:
	if source.is_the_player:
		remove_aura_by_id(expired_aura.unique_id, player_aura_dictionary)
		CombatLogEvents.aura_removed.emit(source, expired_aura)
	else:
		remove_aura_by_id(expired_aura.unique_id, enemy_aura_dictionary)

func remove_aura_by_id(aura_id:String, aura_dictionary:Dictionary[String, Aura]) -> void:
	if aura_id in aura_dictionary.keys():
		aura_dictionary.erase(aura_id)
		update_stats()

func on_attack(source:Combatant) -> void:
	if source.is_the_player:
		for aura:Aura in player_aura_dictionary.values(): 
			aura.on_attack(source)
	else:
		for aura:Aura in enemy_aura_dictionary.values(): 
			aura.on_attack(source)

func on_combat_start(_all_combatants:Array[Combatant]) -> void:
	for aura:Aura in player_aura_dictionary.values(): 
		aura.on_combat_start()
	for aura:Aura in enemy_aura_dictionary.values(): 
		aura.on_combat_start()

func on_combat_end(_all_combatants:Array[Combatant]) -> void:
	for aura:Aura in player_aura_dictionary.values(): 
		aura.on_combat_end()
	for aura:Aura in enemy_aura_dictionary.values(): 
		aura.on_combat_end()
