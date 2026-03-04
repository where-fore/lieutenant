extends Node2D


@onready var current_player = $PlayerCombatant

var player_aura_dictionary:Dictionary[String,int]
var enemy_aura_dictionary:Dictionary[String,int]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatEvents.initalize_combat_stats.connect(update_precombat_stats)
	HudEvents.combat_won.connect(grow_enemies)
	StatEvents.health_increased.connect(increase_player_health)
	StatEvents.attack_increased.connect(increase_player_attack)
	StatEvents.restart_game.connect(reset_to_starting_stats)
	InventoryEvents.item_successfully_equipped.connect(interpret_new_item)
	InventoryEvents.item_successfully_unequipped.connect(interpret_removed_item)

func reset_to_starting_stats():
	StatEvents.encounters_defeated_for_scaling = 0
	player_aura_dictionary.clear()
	enemy_aura_dictionary.clear()

func interpret_new_item(item:ItemData):
	if item.damage:
		var to_add = item.damage
		add_to_aura_dictionary(player_aura_dictionary, Stats.attack, to_add)
	update_precombat_stats()

func interpret_removed_item(item:ItemData):
	if item.damage:
		var to_add = item.damage * -1
		add_to_aura_dictionary(player_aura_dictionary, Stats.attack, to_add)
	update_precombat_stats()

func update_precombat_stats():
	StatEvents.send_auras_to_combatants.emit(player_aura_dictionary, enemy_aura_dictionary)

func grow_enemies():
	StatEvents.encounters_defeated_for_scaling += 1

func increase_player_health(delta):
	add_to_aura_dictionary(player_aura_dictionary, Stats.health, delta)

func increase_player_attack(delta):
	add_to_aura_dictionary(player_aura_dictionary, Stats.attack, delta)

func increase_enemy_health(delta):
	add_to_aura_dictionary(enemy_aura_dictionary, Stats.health, delta)

func increase_enemy_attack(delta):
	add_to_aura_dictionary(enemy_aura_dictionary, Stats.attack, delta)

func add_to_aura_dictionary(dictionary_to_update:Dictionary[String,int], statName:String, value:int):
	if dictionary_to_update.has(statName):
		dictionary_to_update[statName] += value
	else:
		dictionary_to_update[statName] = value
