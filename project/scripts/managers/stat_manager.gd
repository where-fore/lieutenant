extends Node2D

var player_aura_dictionary:Dictionary[String, Aura]
var enemy_aura_dictionary:Dictionary[String, Aura]

var player_final_additive_aura:Dictionary[StringName, int]
var player_final_multiplicative_aura:Dictionary[StringName, int]
var enemy_final_additive_aura:Dictionary[StringName, int]
var enemy_final_multiplicative_aura:Dictionary[StringName, int]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatEvents.initalize_combat_stats.connect(update_precombat_stats)
	HudEvents.combat_won.connect(grow_enemies)
	StatEvents.restart_game.connect(reset_to_starting_stats)
	InventoryEvents.item_successfully_equipped.connect(interpret_new_item)
	InventoryEvents.item_successfully_unequipped.connect(interpret_removed_item)

func reset_to_starting_stats() -> void:
	StatEvents.encounters_defeated_for_scaling = 0
	player_aura_dictionary.clear()
	enemy_aura_dictionary.clear()

func grow_enemies() -> void:
	StatEvents.encounters_defeated_for_scaling += 1


func interpret_new_item(item:ItemData) -> void:
	var item_aura: Aura = item.get_aura()
	player_aura_dictionary[item_aura.unique_id] = item_aura
	
	var item_custom_aura:Aura = item.get_custom_aura()
	if item_custom_aura:
		player_aura_dictionary[item_custom_aura.unique_id] = item_custom_aura
	
	update_precombat_stats()

func interpret_removed_item(item:ItemData) -> void:
	player_aura_dictionary.erase(item.get_aura().unique_id)
	
	var item_custom_aura:Aura = item.get_custom_aura()
	if item_custom_aura: player_aura_dictionary.erase(item_custom_aura.unique_id)
	
	update_precombat_stats()

func update_precombat_stats() -> void:
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
