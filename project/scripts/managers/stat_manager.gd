extends Node2D

var player_aura_dictionary:Dictionary[String, Aura]
var enemy_aura_dictionary:Dictionary[String, Aura]

var player_final_additive_aura:Dictionary[StringName, int]
var player_final_multiplicative_aura:Dictionary[StringName, int]
var enemy_final_additive_aura:Dictionary[StringName, int]
var enemy_final_multiplicative_aura:Dictionary[StringName, int]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatEvents.initalize_combat_stats.connect(update_stats)
	StatEvents.updated_aura.connect(update_aura)
	HudEvents.combat_won.connect(grow_enemies)
	StatEvents.restart_game.connect(reset_to_starting_stats)
	StatEvents.give_aura_to_player.connect(apply_new_aura_to_player)
	StatEvents.remove_aura_from_player.connect(remove_aura_from_player)

func reset_to_starting_stats() -> void:
	StatEvents.encounters_defeated_for_scaling = 0
	player_aura_dictionary.clear()
	enemy_aura_dictionary.clear()

func grow_enemies() -> void:
	StatEvents.encounters_defeated_for_scaling += 1

func apply_new_aura_to_player(new_aura:Aura) -> void:
	if new_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		#then instance a new aura
		new_aura = new_aura.create_aura()
	player_aura_dictionary[new_aura.unique_id] = new_aura
	update_stats()
	
func remove_aura_from_player(old_aura:Aura) -> void:
	if old_aura.resource_path != "":
		#if the aura sent in is a file on the disk (ie. is a template, not an already instanced aura)
		push_error("trying to remove an aura that is a template")
	player_aura_dictionary.erase(old_aura.unique_id)
	update_stats()

func update_aura(_aura:Aura) -> void:
	#i don't think i actually do anything? the aura should dynamically update?
	#maybe this should only update one aura? but i have to recalculate it all anyways
	update_stats()

func update_stats() -> void:
	merge_auras()
	StatEvents.send_auras_to_combatants.emit(player_final_additive_aura, player_final_multiplicative_aura, enemy_final_additive_aura, enemy_final_multiplicative_aura)

func merge_auras() -> void:
	player_final_additive_aura.clear()
	player_final_multiplicative_aura.clear()
	enemy_final_additive_aura.clear()
	enemy_final_multiplicative_aura.clear()

	for aura_id:String in player_aura_dictionary:
		for stat:StringName in player_aura_dictionary[aura_id].additive_dictionary:
			add_to_aura_dictionary(player_final_additive_aura, stat, player_aura_dictionary[aura_id].additive_dictionary[stat])
		
		for stat:StringName in player_aura_dictionary[aura_id].multiplicative_dictionary:
			add_to_aura_dictionary(player_final_multiplicative_aura, stat, player_aura_dictionary[aura_id].multiplicative_dictionary[stat])
		
	for aura_id:String in enemy_aura_dictionary:
		for stat:StringName in enemy_aura_dictionary[aura_id].additive_dictionary:
			add_to_aura_dictionary(enemy_final_additive_aura, stat, enemy_aura_dictionary[aura_id].additive_dictionary[stat])
		
		for stat:StringName in enemy_aura_dictionary[aura_id].multiplicative_dictionary:
			add_to_aura_dictionary(enemy_final_multiplicative_aura, stat, enemy_aura_dictionary[aura_id].multiplicative_dictionary[stat])

func add_to_aura_dictionary(dictionary_to_update:Dictionary[StringName,int], statName:StringName, value:int) -> void:
	if dictionary_to_update.has(statName):
		dictionary_to_update[statName] += value
	else:
		dictionary_to_update[statName] = value
