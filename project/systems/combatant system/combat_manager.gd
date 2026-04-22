extends Node2D

@export var random_enemy_selection:Array[GDScript]

var player_combatant:Combatant
var player_template_id:String = "basic_player_fighter"

var player_combatants:Array[Combatant]
var enemy_combatants:Array[Combatant]

var current_combatant_turn:Combatant:
	set(value):
		current_combatant_turn = value
		if current_combatant_turn:
			HudEvents.combatant_turn_next.emit(current_combatant_turn)

var round_number:int = 0
var turn_finished:bool = false
var player_victorious:bool = false
var player_lost:bool = false

var can_start_combat:bool = true

var play_speed:StringName
var speed_normal:StringName = &"normal"
var speed_fast:StringName = &"fast"
var opener_turn_delay:float
var middle_turn_delay:float
var near_end_delay:float

var normal_opener_turn_delay:float = 0.8
var normal_middle_turn_delay:float = 0.8
var normal_near_end_delay:float = 1.2

var fast_opener_turn_delay:float = 0.3
var fast_middle_turn_delay:float = 0.15
var fast_near_end_delay:float = 0.4


var step_mode:StringName = &"step mode"
var play_mode:StringName = &"play mode"
var turn_mode:StringName = step_mode


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.combatant_turn_ended.connect(finish_turn)
	CombatEvents.combatant_died.connect(handle_perishing_combatant)
	HudEvents.combat_button_pressed.connect(start_combat)
	CombatEvents.prepare_combat_with_enemy.connect(pre_combat)
	CombatEvents.pause_button_pressed.connect(pause_button_pressed)
	CombatEvents.step_button_pressed.connect(step_button_pressed)
	CombatEvents.play_button_pressed.connect(play_button_pressed)
	CombatEvents.play_fast_button_pressed.connect(play_fast_button_pressed)
	HudEvents.game_paused.connect(pause_button_pressed)
	CombatEvents.combat_ongoing = false
	
	create_player_combatant()
	var add_test_characters:int = 3
	while add_test_characters > 0:
		var new_player:Combatant = setup_combatant(Database.get_combatant_by_id("basic_player_rogue"), true)
		add_child(new_player)
		HudEvents.send_player_combatants_to_ui.emit(new_player)
		player_combatants.append(new_player)
		
		add_test_characters -= 1

func create_player_combatant() -> void:
	var new_player:Combatant = setup_combatant(Database.get_combatant_by_id(player_template_id), true)
	add_child(new_player)
	HudEvents.send_player_combatants_to_ui.emit(new_player)
	player_combatants.append(new_player)

func pause_button_pressed() -> void:
	if CombatEvents.combat_ongoing:
		turn_mode = step_mode

func step_button_pressed() -> void:
	if CombatEvents.combat_ongoing:
		turn_mode = step_mode
		proceed()

func play_button_pressed() -> void:
	if CombatEvents.combat_ongoing:
		turn_mode = play_mode
		set_speed(speed_normal)
		proceed()

func play_fast_button_pressed() -> void:
	if CombatEvents.combat_ongoing:
		turn_mode = play_mode
		set_speed(speed_fast)
		proceed()

func proceed() -> void:
	if not current_combatant_turn or turn_finished == true:
		next_turn()

func set_speed(speed:StringName) -> void:
	if speed == speed_normal:
		play_speed = speed_normal
		opener_turn_delay = normal_opener_turn_delay
		middle_turn_delay = normal_middle_turn_delay
		near_end_delay = normal_near_end_delay
	elif speed == speed_fast:
		play_speed = speed_fast
		opener_turn_delay = fast_opener_turn_delay
		middle_turn_delay = fast_middle_turn_delay
		near_end_delay = fast_near_end_delay
	else:
		push_error("tried to set combat speed to unrecognized speed: " + str(speed))

func handle_attack(_attacker:Combatant, amount:int, target:Combatant) -> void:
	target.take_damage(amount)

func finish_turn(source:Combatant) -> void:
	if CombatEvents.combat_ongoing:
		
		if turn_mode != step_mode:
			await turn_animation()
		
		turn_finished = true
		
		if turn_mode == play_mode:
			next_turn(source)
	else:
		turn_finished = true
		stop_combat()

func next_turn(finished_combatant:Combatant = null) -> void:
	if finished_combatant and not (finished_combatant == current_combatant_turn):
		push_error("combat manager thought it was the turn of: " + current_combatant_turn.combatant_name + ", but heard the turn finished signal for: " + finished_combatant.combatant_name)
		current_combatant_turn = finished_combatant
	
	var player_turn:bool = player_combatants.find(current_combatant_turn) != -1
	var enemy_turn:bool = enemy_combatants.find(current_combatant_turn) != -1
	
	if player_turn:
		var finished_index:int = player_combatants.find(current_combatant_turn)
		if finished_index >= player_combatants.size() - 1:
			current_combatant_turn = enemy_combatants[0]
		else:
			current_combatant_turn = player_combatants[finished_index + 1]
		
	elif enemy_turn:
		var finished_index:int = enemy_combatants.find(current_combatant_turn)
		if finished_index >= enemy_combatants.size() - 1:
			round_number += 1
			current_combatant_turn = player_combatants[0]
		else:
			current_combatant_turn = enemy_combatants[finished_index + 1]
		
	else:
		current_combatant_turn = player_combatants[0]
	
	if CombatEvents.combat_ongoing:
		turn_finished = false
		current_combatant_turn.take_turn()

func turn_animation() -> void:
	if not play_speed:
		set_speed(speed_normal)

	var slow_opener:bool = round_number <= 1
	var failsafe:float = 0.2
	
	var animation_timer:Timer = Timer.new()
	add_child(animation_timer)
	#this is different from get_tree().create_timer - it's local to this guy
	#so i can delete this node and all the timers cleanly stop
	var timer_duration:float
	
	if slow_opener:
		timer_duration = opener_turn_delay
		
	elif not slow_opener:
		timer_duration = middle_turn_delay
	
	else:
		push_warning("no turn animation state chosen; using failsafe")
		timer_duration = failsafe
	
	animation_timer.start(timer_duration)
	await animation_timer.timeout
	animation_timer.queue_free()

func handle_perishing_combatant(combatant_who_died:Combatant) -> void:	
	if combatant_who_died.is_a_player:
		var living_players:int = 0
		for player:Combatant in player_combatants:
			if not player.dead: living_players += 1
		if living_players == 0:
			CombatEvents.combat_ongoing = false
			player_victorious = false
	
	elif combatant_who_died.is_an_enemy:
		var living_enemies:int = 0
		for enemy:Combatant in enemy_combatants:
			if not enemy.dead: living_enemies += 1
		if living_enemies == 0:
			CombatEvents.combat_ongoing = false
			player_victorious = true

func stop_combat() -> void:
	CombatEvents.combat_ongoing = false
	
	for combatant:Combatant in player_combatants + enemy_combatants:
		combatant.on_end_combat_functions()
	
	CombatEvents.combat_finished.emit(player_combatants + enemy_combatants)
	
	if player_victorious:
		HudEvents.combat_won.emit()
	else:
		HudEvents.combat_lost.emit()
	
	player_victorious = false
	
	for combatant:Combatant in enemy_combatants:
		combatant.queue_free()
	enemy_combatants.clear()

func pre_combat(enemy_template:Combatant) -> void:
	HudEvents.combatant_turn_next.emit(player_combatants[0])
	
	var enemy1:Combatant = setup_combatant(enemy_template.duplicate())
	add_child(enemy1)
	enemy_combatants.append(enemy1)
	var enemy2:Combatant = setup_combatant(enemy_template.duplicate())
	add_child(enemy2)
	enemy_combatants.append(enemy2)
	HudEvents.send_enemy_combatants_to_ui.emit(enemy_combatants)
	
	for ally:Combatant in player_combatants:
		ally.possible_targets = enemy_combatants.duplicate()
	for enemy:Combatant in enemy_combatants:
		enemy.possible_targets = player_combatants.duplicate()
	
	current_combatant_turn = null
	CombatEvents.combat_ongoing = false
	turn_finished = true
	reset_turn_counter()
	
	can_start_combat = true

func setup_combatant(new_combatant:Combatant, is_a_player:bool = false) -> Combatant:
	if is_a_player: new_combatant.setup(true)
	elif not is_a_player: new_combatant.setup(false)
	
	return new_combatant

func start_combat() -> void:
	if not CombatEvents.combat_ongoing and can_start_combat:
		can_start_combat = false
		CombatEvents.combat_ongoing = true
		
		for combatant:Combatant in player_combatants + enemy_combatants:
			combatant.on_start_combat_functions()
		
		CombatEvents.combat_started.emit(player_combatants + enemy_combatants)
	
		#auto start, with last chosen speed
		match HudEvents.last_combat_speed_chosen:
			HudEvents.CombatSpeedNames.STEP: step_button_pressed()
			HudEvents.CombatSpeedNames.PLAY: play_button_pressed()
			HudEvents.CombatSpeedNames.PLAY_FAST: play_fast_button_pressed()
			_: push_error("not sure what last combat speed was: " + str(HudEvents.last_combat_speed_chosen))


func reset_turn_counter() -> void:
	round_number = 0
