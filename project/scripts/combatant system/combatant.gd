extends Node2D
class_name Combatant

@export var baseData: CombatantData

@export var _this_is_the_player: bool = false
func is_the_player() -> bool: return _this_is_the_player

var base_stats: Dictionary = {}
var current_stats: Dictionary = {}

#controls global scaling - can set to 0 for no scaling, 5 for hyper scaling etc
#this currently has to be an int, but i'd expect to be able to half the scaling factor ie. 0.5
#can refactor some other things to round - but i haven't decided how i want to round things yet
var scaling_coefficient: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatEvents.send_auras_to_combatants.connect(recalculate_stats)
	
	setup()

func setup(should_be_the_player:bool = false) -> void:
	if should_be_the_player: _this_is_the_player = true
	
	base_stats[Stats.health] = baseData.base_health
	base_stats[Stats.attack] = baseData.base_attack
	reset_current_stats_to_base()
	send_sprite_to_ui()
	CombatEvents.enemy_ready.emit()
	

func take_damage(value: int) -> void:
	current_stats[Stats.health] -= value
	
	if is_the_player(): HudEvents.player_health_update.emit(current_stats[Stats.health])
	else: HudEvents.enemy_health_update.emit(current_stats[Stats.health])
	
	if current_stats[Stats.health] <= 0: perish()

func reset_current_stats_to_base() -> void:
	scale_stats_to_combats()
	current_stats = base_stats.duplicate()

func scale_stats_to_combats() -> void:
	if baseData.health_scaling:
		var health_scaling_factor: int = StatEvents.encounters_defeated_for_scaling * scaling_coefficient
		base_stats[Stats.health] = baseData.base_health + (baseData.health_scaling * health_scaling_factor)
	if baseData.attack_scaling:
		var attack_scaling_factor: int = StatEvents.encounters_defeated_for_scaling * scaling_coefficient
		base_stats[Stats.attack] = baseData.base_attack + (baseData.attack_scaling * attack_scaling_factor)

func perish() -> void:
	CombatEvents.combatant_died.emit(self)

func send_sprite_to_ui() -> void:
	if not is_the_player(): HudEvents.send_enemy_sprite.emit(baseData.texture)

func take_turn() -> void:
	#attack
	CombatEvents.attack_launched.emit(self, current_stats[Stats.attack])
	
	#all done
	CombatEvents.turn_finished.emit()

func recalculate_stats(playerAuraAdditiveDictionary:Dictionary[StringName, int], playerAuraMultiplicativeDictionary:Dictionary[StringName, int], enemyAuraAdditiveDictionary:Dictionary[StringName, int], enemyAuraMultiplicativeDictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()
	
	if _this_is_the_player:
		sum_aura_and_base_stats(playerAuraAdditiveDictionary)
		multiply_aura_and_current_stats(playerAuraMultiplicativeDictionary)
		HudEvents.player_health_update.emit(current_stats[Stats.health])
		HudEvents.player_attack_update.emit(current_stats[Stats.attack])
	
	elif not _this_is_the_player:
		sum_aura_and_base_stats(enemyAuraAdditiveDictionary)
		multiply_aura_and_current_stats(enemyAuraMultiplicativeDictionary)
		HudEvents.enemy_health_update.emit(current_stats[Stats.health])
		HudEvents.enemy_attack_update.emit(current_stats[Stats.attack])

func sum_aura_and_base_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat: String in auraDictionary:
		if base_stats.has(stat):
			current_stats[stat] = auraDictionary[stat] + base_stats[stat]
		else:
			current_stats[stat] = auraDictionary[stat]

func multiply_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat: String in auraDictionary:
		if base_stats.has(stat):
			current_stats[stat] *= (1+ auraDictionary[stat])
