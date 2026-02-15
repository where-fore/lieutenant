extends Node2D

@onready var current_player = $"Player Combatant"
@onready var current_enemy = $"Enemy Combatant"

var player_turn = "Player"
var enemy_turn = "Enemy"
var precombat = "Precombat"
var turn = precombat

var combat_ongoing = false as bool
var can_start_combat = true as bool

var artifical_delay_between_turns = 0.6


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.turn_finished.connect(pass_turn)
	HudEvents.combat_button_pressed.connect(get_combatant_stats)
	HudEvents.send_combatant_base_stats.connect(pre_combat)
	CombatEvents.combatant_died.connect(stop_combat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func handle_attack(attacker, amount):
	if attacker.is_the_player():
		current_enemy.take_damage(amount)
	else:
		current_player.take_damage(amount)


func pass_turn():
	#swap turns
	if turn == player_turn: turn = enemy_turn
	elif turn == enemy_turn: turn = player_turn
	
	
	if combat_ongoing:
		await get_tree().create_timer(artifical_delay_between_turns).timeout
		
		start_turn()


func stop_combat():
	combat_ongoing = false
	HudEvents.combat_won.emit()


func get_combatant_stats():
	HudEvents.ask_for_combatant_base_stats.emit()


func pre_combat(player_stat_array, enemy_stat_array):
	current_player.initialize_stats(player_stat_array[0], player_stat_array[1])
	current_enemy.initialize_stats(enemy_stat_array[0], enemy_stat_array[1])
	start_combat()


func start_combat():
	if not combat_ongoing and can_start_combat:
		can_start_combat = false
		combat_ongoing = true
		start_turn()
	
	


func start_turn():
	if turn == precombat:
		turn = player_turn
		current_player.take_turn()
		
	elif turn == player_turn:
		current_player.take_turn()
		
	elif turn == enemy_turn: 
		current_enemy.take_turn()
