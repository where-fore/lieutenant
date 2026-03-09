extends Node2D
class_name Combatant

@export var baseData:CombatantData

var is_the_player:bool = false
var is_an_enemy:bool = true

var damage_taken:int = 0

var base_stats:Dictionary = {}
var current_stats:Dictionary = {}

#controls global scaling - can set to 0 for no scaling, 5 for hyper scaling etc
#this currently has to be an int, but i'd expect to be able to half the scaling factor ie. 0.5
#can refactor some other things to round - but i haven't decided how i want to round things yet
var scaling_coefficient:int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AuraEvents.send_auras_to_combatants.connect(recalculate_stats)
	
	setup()

func setup(should_be_the_player:bool = false) -> void:
	if should_be_the_player:
		is_the_player = true
		is_an_enemy = false
	
	base_stats[Stats.health] = baseData.base_health
	base_stats[Stats.attack] = baseData.base_attack
	reset_current_stats_to_base()
	send_sprite_to_ui()
	CombatEvents.enemy_ready.emit()
	

func take_damage(value:int) -> void:
	damage_taken += value
	var current_hp:int = current_stats[Stats.health] - damage_taken
	
	if is_the_player: HudEvents.player_health_update.emit(current_hp)
	else: HudEvents.enemy_health_update.emit(current_hp)
	
	if current_hp <= 0: perish()

func reset_current_stats_to_base() -> void:
	scale_stats_to_combats()
	current_stats = base_stats.duplicate()

func scale_stats_to_combats() -> void:
	if baseData.health_scaling:
		var health_scaling_factor:int = AuraEvents.encounters_defeated_for_scaling * scaling_coefficient
		base_stats[Stats.health] = baseData.base_health + (baseData.health_scaling * health_scaling_factor)
	if baseData.attack_scaling:
		var attack_scaling_factor:int = AuraEvents.encounters_defeated_for_scaling * scaling_coefficient
		base_stats[Stats.attack] = baseData.base_attack + (baseData.attack_scaling * attack_scaling_factor)

func perish() -> void:
	CombatEvents.combatant_died.emit(self)

func send_sprite_to_ui() -> void:
	if is_an_enemy: HudEvents.send_enemy_sprite.emit(baseData.texture)

func take_turn() -> void:
	#attack
	CombatEvents.attack_launched.emit(self, current_stats[Stats.attack])
	
	#all done
	CombatEvents.turn_finished.emit(self)

func recalculate_stats(playerAuraAdditiveDictionary:Dictionary[StringName, int], playerAuraMultiplicativeDictionary:Dictionary[StringName, int], enemyAuraAdditiveDictionary:Dictionary[StringName, int], enemyAuraMultiplicativeDictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()

	if is_the_player:
		sum_aura_and_base_stats(playerAuraAdditiveDictionary)
		multiply_aura_and_current_stats(playerAuraMultiplicativeDictionary)
		HudEvents.player_health_update.emit(current_stats[Stats.health] - damage_taken)
		HudEvents.player_attack_update.emit(current_stats[Stats.attack])
	
	elif is_an_enemy:
		sum_aura_and_base_stats(enemyAuraAdditiveDictionary)
		multiply_aura_and_current_stats(enemyAuraMultiplicativeDictionary)
		HudEvents.enemy_health_update.emit(current_stats[Stats.health] - damage_taken)
		HudEvents.enemy_attack_update.emit(current_stats[Stats.attack])

func sum_aura_and_base_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if base_stats.has(stat):
			current_stats[stat] = auraDictionary[stat] + base_stats[stat]
		else:
			current_stats[stat] = auraDictionary[stat]

func multiply_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if base_stats.has(stat):
			current_stats[stat] *= (1+ auraDictionary[stat])
