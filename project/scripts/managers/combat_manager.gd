extends Node2D

@export var combatant_base_scene:PackedScene
@onready var current_player = $StatManager/PlayerCombatant
var current_enemy
@export var random_enemy_selection:EnemyCollection

var player_turn = "Player"
var enemy_turn = "Enemy"
var precombat = "Precombat"
var turn = precombat
var turn_number = 0
var turn_finished = false

var can_start_combat = true

var opener_turn_delay = 1
var middle_turn_delay = 0.2
var near_end_delay = 0.8

var step_mode = "step mode"
var play_mode = "play mode"
var turn_mode = step_mode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.turn_finished.connect(finish_turn)
	CombatEvents.combatant_died.connect(stop_combat)
	HudEvents.combat_button_pressed.connect(start_combat)
	HudEvents.change_to_combat_screen.connect(pre_combat)
	CombatEvents.pause_button_pressed.connect(pause_button_pressed)
	CombatEvents.step_button_pressed.connect(step_button_pressed)
	CombatEvents.play_button_pressed.connect(play_button_pressed)
	TimingEvents.everythings_ready.connect(pre_combat)


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
		
		
		if CombatEvents.combat_ongoing:
			start_turn()


func turn_animation():
	var near_end = (current_enemy.current_stats[Stats.health] <= 1* current_player.current_stats[Stats.attack]) or (current_player.current_stats[Stats.health] <= 1* current_enemy.current_stats[Stats.attack])
	
	var slow_opener = turn_number <= 2 as bool
	if slow_opener:
		return get_tree().create_timer(opener_turn_delay).timeout
		
	elif not slow_opener and not near_end:
		return get_tree().create_timer(middle_turn_delay).timeout
	
	elif near_end: 
		return get_tree().create_timer(near_end_delay).timeout


func stop_combat(combatant_who_died):
	CombatEvents.combat_ongoing = false
	if combatant_who_died.is_the_player():
		HudEvents.combat_lost.emit()
		
	elif not combatant_who_died.is_the_player():
		HudEvents.combat_won.emit()
		#delete the old loser from memory
		combatant_who_died.queue_free()


func pre_combat():
	choose_enemy()
	
	#now i wait for the enemy to be created, so i can continue
	#this is a dangerous idea - this could cause the program to hang forever if somehow this fails
	#await CombatEvents.enemy_ready
	#alright so hopefully we're all good...
	
	StatEvents.initalize_combat_stats.emit()
	turn = precombat
	CombatEvents.combat_ongoing = false
	can_start_combat = true
	reset_turn_counter()

func choose_enemy():
	#pick data
	var new_enemy_data = random_enemy_selection.enemies.pick_random()
	#create a lil memory boi
	var new_enemy_node = combatant_base_scene.instantiate()
	#assign data to our boi
	new_enemy_node.baseData = new_enemy_data
	#make our boi into real thing
	add_child(new_enemy_node)
	#call function on our real thing
	new_enemy_node.setup()
	
	current_enemy = new_enemy_node

func start_combat():
	if not CombatEvents.combat_ongoing and can_start_combat:
		can_start_combat = false
		CombatEvents.combat_ongoing = true


func start_turn():
	turn_number += 1
	
	if turn == precombat:
		turn = player_turn
		current_player.take_turn()
		
	elif turn == player_turn:
		current_player.take_turn()
		
	elif turn == enemy_turn: 
		current_enemy.take_turn()

func reset_turn_counter():
	turn_number = 0
