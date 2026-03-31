extends Node2D
class_name Combatant

var baseData:CombatantData

var is_the_player:bool = false
var is_an_enemy:bool = true

var current_target:Combatant

var dead:bool = false

var damage_taken:int = 0
func get_damaged_health() -> int:
	return current_stats[Stats.health] - damage_taken

var starting_stats:Dictionary[StringName, int] = {}
var current_stats:Dictionary[StringName, int] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AuraEvents.send_auras_to_combatants.connect(recalculate_stats)

func setup(should_be_the_player:bool = false) -> void:
	if should_be_the_player:
		is_the_player = true
		is_an_enemy = false
	
	starting_stats[Stats.health] = baseData.scaled_health
	starting_stats[Stats.attack] = baseData.scaled_attack
	reset_current_stats_to_base()
	send_sprite_to_ui()
	

func take_damage(value:int) -> void:
	if not dead:
		if value < 0: push_error("tried to take negative damage on: " + baseData.name)
		else:
			damage_taken += value
		
			var current_hp:int = get_damaged_health()
			
			if is_the_player: HudEvents.player_health_update.emit(current_hp)
			else: HudEvents.enemy_health_update.emit(current_hp)
			CombatEvents.damage_applied.emit(self, value)
			check_if_dead_now()
		
		on_damage_taken_functions(value)


func heal(value:int) -> void:
	if not dead:
		if value <= 0: push_error("tried to heal for 0 or negative on: " + baseData.name)
		else:
			damage_taken -= value
			
			var current_hp:int = get_damaged_health()
			
			if is_the_player: HudEvents.player_health_update.emit(current_hp)
			else: HudEvents.enemy_health_update.emit(current_hp)
			CombatEvents.healing_applied.emit(self, value)

func reset_current_stats_to_base() -> void:
	current_stats = starting_stats.duplicate()

func check_if_dead_now() -> void:
	if get_damaged_health() <= 0: perish()

func perish() -> void:
	dead = true
	CombatEvents.combatant_died.emit(self)

func send_sprite_to_ui() -> void:
	if is_an_enemy: HudEvents.send_enemy_sprite.emit(baseData.texture)

func take_turn() -> void:	
	on_start_turn_functions()
	
	CombatEvents.attack_launched.emit(self, current_stats[Stats.attack], current_target)
	on_after_attack_functions()
	
	on_end_turn_functions()

func recalculate_stats(playerAuraAdditiveDictionary:Dictionary[StringName, int], playerAuraMultiplicativeDictionary:Dictionary[StringName, int], enemyAuraAdditiveDictionary:Dictionary[StringName, int], enemyAuraMultiplicativeDictionary:Dictionary[StringName, int]) -> void:
	reset_current_stats_to_base()

	if is_the_player:
		sum_aura_and_base_stats(playerAuraAdditiveDictionary)
		multiply_aura_and_current_stats(playerAuraMultiplicativeDictionary)
		HudEvents.player_health_update.emit(get_damaged_health())
		HudEvents.player_attack_update.emit(current_stats[Stats.attack])
	
	elif is_an_enemy:
		sum_aura_and_base_stats(enemyAuraAdditiveDictionary)
		multiply_aura_and_current_stats(enemyAuraMultiplicativeDictionary)
		HudEvents.enemy_health_update.emit(get_damaged_health())
		HudEvents.enemy_attack_update.emit(current_stats[Stats.attack])

func sum_aura_and_base_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if starting_stats.has(stat):
			current_stats[stat] = auraDictionary[stat] + starting_stats[stat]
		else:
			current_stats[stat] = auraDictionary[stat]

func multiply_aura_and_current_stats(auraDictionary:Dictionary[StringName,int]) -> void:
	for stat:String in auraDictionary:
		if current_stats.has(stat):
			var multiplier:float = (100.0 + float(auraDictionary[stat]))/100.0
			#note that int() truncates, as i want
			current_stats[stat] = int(current_stats[stat] * multiplier)

func on_start_combat_functions() -> void:
	baseData.on_start_combat()

func on_start_turn_functions() -> void:
	baseData.on_start_turn()
	CombatEvents.combatant_turn_started.emit(self)

func on_after_attack_functions() -> void:
	baseData.on_after_attack()
	CombatEvents.combatant_finished_attack.emit(self, current_target)

func on_damage_taken_functions(amount_taken:int) -> void:
	baseData.on_damage_taken(amount_taken)
	CombatEvents.combatant_damaged.emit(self, amount_taken)

func on_end_turn_functions() -> void:
	baseData.on_end_turn()
	CombatEvents.combatant_turn_ended.emit(self)

func on_end_combat_functions() -> void:
	baseData.on_combat_end()
