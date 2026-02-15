extends Node2D

@export var this_is_the_player = false as bool
func is_the_player() -> bool: return this_is_the_player

var health = 1337 as int
func get_health() -> int: return health

var attack = 1337 as int
func get_attack() -> int: return attack


func take_damage(value):
	health -= value
	
	if is_the_player(): HudEvents.player_health_update.emit()
	else: HudEvents.enemy_health_update.emit()
	
	if health <= 0: perish()


func perish():
	CombatEvents.combatant_died.emit()


func take_turn():
	#attack
	CombatEvents.attack_launched.emit(self, attack)
	
	#all done
	CombatEvents.turn_finished.emit()

#this gets called by the manager
func initialize_stats(base_health, base_attack):
	health = base_health
	if is_the_player(): HudEvents.player_health_update.emit()
	else: HudEvents.enemy_health_update.emit()
	
	attack = base_attack
	if is_the_player(): HudEvents.player_attack_update.emit()
	else: HudEvents.enemy_attack_update.emit()
