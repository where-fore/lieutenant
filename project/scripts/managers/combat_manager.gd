extends Node2D

@onready var current_player = $"Player Combatant"
@onready var current_enemy = $"Enemy Combatant"

var player_turn = "Player"
var enemy_turn = "Enemy"
var precombat = "Precombat"
var turn = precombat
var turn_number = 1
var turn_finished = false

var can_start_combat = true

var opener_turn_delay = 1
var middle_turn_delay = 0.2
var near_end_delay = 1

var step_mode = "step mode"
var play_mode = "play mode"
var turn_mode = step_mode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.turn_finished.connect(finish_turn)
	HudEvents.send_combatant_base_stats.connect(set_combatant_stats)
	CombatEvents.combatant_died.connect(stop_combat)
	HudEvents.combat_button_pressed.connect(start_combat)
	HudEvents.change_to_combat_screen.connect(pre_combat)
	CombatEvents.pause_button_pressed.connect(pause_button_pressed)
	CombatEvents.step_button_pressed.connect(step_button_pressed)
	CombatEvents.play_button_pressed.connect(play_button_pressed)
	
	#wait for everything else to load
	await owner.ready
	pre_combat()


func pause_button_pressed():
	turn_mode = step_mode

func step_button_pressed():
	turn_mode = step_mode
	if turn == precombat:
		start_turn()
	else:
		next_turn()

func play_button_pressed():
	turn_mode = play_mode
	if turn == precombat:
		start_turn()
	else:
		next_turn()


func handle_attack(attacker, amount):
	if attacker.is_the_player():
		current_enemy.take_damage(amount)
	else:
		current_player.take_damage(amount)


func finish_turn():
	turn_finished = true
	if turn_mode == play_mode:
		await turn_animation()
		next_turn()
	

func next_turn():
	if turn_finished == true:
		turn_finished = false
		
		#swap turns
		if turn == player_turn: turn = enemy_turn
		elif turn == enemy_turn: turn = player_turn
		turn_number += 1
		
		
		if CombatEvents.combat_ongoing:
			start_turn()


func turn_animation():
	var near_end = (current_enemy.health <= 1* current_player.attack) or (current_player.health <= 1* current_enemy.attack)
	
	var slow_opener = turn_number <= 2 as bool
	if slow_opener:
		return get_tree().create_timer(opener_turn_delay).timeout
		
	elif not slow_opener and not near_end:
		return get_tree().create_timer(middle_turn_delay).timeout
	
	elif near_end: 
		return get_tree().create_timer(near_end_delay).timeout


func stop_combat(combatant_who_died):
	CombatEvents.combat_ongoing = false
	if combatant_who_died.is_the_player(): HudEvents.combat_lost.emit()
	elif not combatant_who_died.is_the_player(): HudEvents.combat_won.emit()


func pre_combat():
	get_combatant_stats()
	turn = precombat
	CombatEvents.combat_ongoing = false
	can_start_combat = true
	#reset turn counter
	turn_number = 1
	

func get_combatant_stats():
	HudEvents.ask_for_combatant_base_stats.emit()


func set_combatant_stats(player_stat_array, enemy_stat_array):
	current_player.initialize_stats(player_stat_array[0], player_stat_array[1])
	current_enemy.initialize_stats(enemy_stat_array[0], enemy_stat_array[1])


func start_combat():
	if not CombatEvents.combat_ongoing and can_start_combat:
		can_start_combat = false
		CombatEvents.combat_ongoing = true


func start_turn():
	if turn == precombat:
		turn = player_turn
		current_player.take_turn()
		
	elif turn == player_turn:
		current_player.take_turn()
		
	elif turn == enemy_turn: 
		current_enemy.take_turn()
