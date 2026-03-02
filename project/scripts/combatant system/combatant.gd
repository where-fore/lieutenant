extends Node2D

@export var baseData: CombatantData

@export var this_is_the_player = false as bool
func is_the_player() -> bool: return this_is_the_player

var base_stats = {}
var current_stats = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if baseData == null:
		push_error("no combatant data set before initalization")
		
	base_stats[Stats.health] = baseData.base_health
	base_stats[Stats.attack] = baseData.base_attack
	reset_current_stats_to_base()

func take_damage(value):
	current_stats[Stats.health] -= value
	
	if is_the_player(): HudEvents.player_health_update.emit(current_stats[Stats.health])
	else: HudEvents.enemy_health_update.emit(current_stats[Stats.health])
	
	if current_stats[Stats.health] <= 0: perish()

func reset_current_stats_to_base():
	current_stats = base_stats.duplicate()

func perish():
	CombatEvents.combatant_died.emit(self)


func take_turn():
	#attack
	CombatEvents.attack_launched.emit(self, current_stats[Stats.attack])
	
	#all done
	CombatEvents.turn_finished.emit()

func merge_aura_and_base_stats(auraDictionary:Dictionary[String,int]):
	for stat in auraDictionary:
		if base_stats.has(stat):
			current_stats[stat] = auraDictionary[stat] + base_stats[stat]
		else:
			current_stats[stat] = auraDictionary[stat]
