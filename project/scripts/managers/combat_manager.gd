extends Node2D

var current_enemy:Combatant
@export var combatant_base_scene:PackedScene
@export var random_enemy_selection:EnemyCollection

var current_player:Combatant
@export var player_base_scene:PackedScene
@export var player_base_stats:CombatantData

var combatants:Array[Combatant]

var player_turn:StringName = &"Player"
var enemy_turn:StringName = &"Enemy"
var precombat:StringName = &"Precombat"
var turn:StringName = precombat
var turn_number:int = 0
var turn_finished:bool = false
var player_victorious:bool = false
var player_lost:bool = false

var can_start_combat:bool = true

#animation data
var opener_turn_delay:float = 1
var middle_turn_delay:float = 0.15
var near_end_delay:float = 0.8

var step_mode:StringName = &"step mode"
var play_mode:StringName = &"play mode"
var turn_mode:StringName = step_mode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.turn_finished.connect(finish_turn)
	CombatEvents.combatant_died.connect(handle_perishing_combatant)
	HudEvents.combat_button_pressed.connect(start_combat)
	HudEvents.change_to_combat_screen.connect(pre_combat)
	CombatEvents.pause_button_pressed.connect(pause_button_pressed)
	CombatEvents.step_button_pressed.connect(step_button_pressed)
	CombatEvents.play_button_pressed.connect(play_button_pressed)
	TimingEvents.everythings_ready.connect(pre_combat)


func pause_button_pressed() -> void:
	turn_mode = step_mode

func step_button_pressed() -> void:
	turn_mode = step_mode
	if turn == precombat:
		start_turn()
	elif turn_finished == true:
		next_turn()

func play_button_pressed() -> void:
	turn_mode = play_mode
	if turn == precombat:
		start_turn()
	elif turn_finished == true:
		next_turn()

func handle_attack(attacker:Combatant, amount:int) -> void:
	if attacker.is_the_player:
		current_enemy.take_damage(amount)
	else:
		current_player.take_damage(amount)

func finish_turn(_source:Combatant) -> void:
	if CombatEvents.combat_ongoing:
		#animate, unless step mode where you skip animations
		if turn_mode != step_mode:
			await turn_animation()
		
		turn_finished = true
		
		if turn_mode == play_mode:
			next_turn()
	else:
		turn_finished = true
		stop_combat()

func next_turn() -> void:
	#swap turns
	if turn == player_turn: turn = enemy_turn
	elif turn == enemy_turn: turn = player_turn
	elif turn == precombat: push_error("somehow tried to take the next turn when it's still precombat")
	
	if CombatEvents.combat_ongoing:
		start_turn()

func turn_animation() -> Signal:
	var player_near_death:bool = current_player.get_damaged_health() <= 1* current_enemy.current_stats[Stats.attack]
	var enemy_near_death:bool = current_enemy.get_damaged_health() <= 1* current_player.current_stats[Stats.attack]
	var near_end:bool = player_near_death or enemy_near_death
	
	var slow_opener:bool = turn_number <= 2
	var failsafe:float = 0.2
	
	if slow_opener:
		return get_tree().create_timer(opener_turn_delay).timeout
		
	elif not slow_opener and not near_end:
		return get_tree().create_timer(middle_turn_delay).timeout
	
	elif near_end:
		return get_tree().create_timer(near_end_delay).timeout
	
	else:
		push_warning("no turn animation state chosen; using failsafe")
		return get_tree().create_timer(failsafe).timeout

func handle_perishing_combatant(combatant_who_died:Combatant) -> void:
	if combatant_who_died.is_the_player:
		CombatEvents.combat_ongoing = false
	
	elif combatant_who_died.is_an_enemy:
		combatants.erase(combatant_who_died)
		var remaining_enemies:int = 0
		for combatant:Combatant in combatants:
			if combatant.is_an_enemy: remaining_enemies += 1
		if remaining_enemies == 0:
			CombatEvents.combat_ongoing = false
			player_victorious = true
			

func stop_combat() -> void:
	CombatEvents.combat_ongoing = false
	CombatEvents.combat_finished.emit()
	
	if player_victorious:
		HudEvents.combat_won.emit()
	else:
		HudEvents.combat_lost.emit()
	
	player_victorious = false
	combatants.clear()

func pre_combat() -> void:
	current_player = spawn_player()
	combatants.append(current_player)
	current_enemy = choose_enemy()
	combatants.append(current_enemy)
	#this is a bit dangerous - i'm now assuming enemies and players are spawned. would love some sort of call back?
	#can't put it in the setup function since that fires before this function reaches await()
	
	AuraEvents.initalize_combat_stats.emit()
	turn = precombat
	CombatEvents.combat_ongoing = false
	can_start_combat = true
	turn_finished = true
	reset_turn_counter()

func choose_enemy() -> Combatant:
	#pick data
	var new_enemy_data:CombatantData = random_enemy_selection.enemies.pick_random()
	#create a lil memory boi
	var new_enemy_node:Combatant = combatant_base_scene.instantiate()
	#assign data to our boi
	new_enemy_node.baseData = new_enemy_data
	#make our boi into real boy
	add_child(new_enemy_node)
	#call function on our real boy
	new_enemy_node.setup()
	
	return new_enemy_node

func spawn_player() -> Combatant:
	#create a lil memory boi
	var new_player_node:Combatant = player_base_scene.instantiate()
	#assign data to our boi
	new_player_node.baseData = player_base_stats
	#make our boi into real boy
	add_child(new_player_node)
	#call function on our real boy
	#(noting it is true they are the player)
	new_player_node.setup(true)
	
	return new_player_node

func start_combat() -> void:
	if not CombatEvents.combat_ongoing and can_start_combat:
		can_start_combat = false
		CombatEvents.combat_ongoing = true
		CombatEvents.combat_started.emit(combatants)

func start_turn() -> void:
	turn_finished = false
	turn_number += 1
	
	if turn == precombat:
		turn = player_turn
		current_player.take_turn()
		
	elif turn == player_turn:
		current_player.take_turn()
		
	elif turn == enemy_turn:
		current_enemy.take_turn()

func reset_turn_counter() -> void:
	turn_number = 0
