extends Node2D

var current_enemy:Combatant
@export var random_enemy_selection:Array[GDScript]

var current_player:Combatant
var player_combatant:Combatant
var player_template_id:String = "basic_player_fighter"

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
	MapEvents.enter_combat_in.connect(pre_combat)
	CombatEvents.pause_button_pressed.connect(pause_button_pressed)
	CombatEvents.step_button_pressed.connect(step_button_pressed)
	CombatEvents.play_button_pressed.connect(play_button_pressed)
	CombatEvents.play_fast_button_pressed.connect(play_fast_button_pressed)
	HudEvents.game_paused.connect(pause_button_pressed)
	CombatEvents.combat_ongoing = false

func create_player_combatant() -> Combatant:
	return Database.get_combatant_by_id(player_template_id)

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
	if turn == precombat:
		start_turn()
	elif turn_finished == true:
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

func finish_turn(_source:Combatant) -> void:
	if CombatEvents.combat_ongoing:
		
		if turn_mode != step_mode:
			await turn_animation()
		
		turn_finished = true
		
		if turn_mode == play_mode:
			next_turn()
	else:
		turn_finished = true
		stop_combat()

func next_turn() -> void:
	if turn == player_turn: turn = enemy_turn
	elif turn == enemy_turn: turn = player_turn
	elif turn == precombat: push_error("somehow tried to take the next turn when it's still precombat")
	
	if CombatEvents.combat_ongoing:
		start_turn()

func turn_animation() -> void:
	if not play_speed:
		set_speed(speed_normal)
	
	var player_near_death:bool = current_player.get_damaged_health() <= 1* current_enemy.current_stats[Stats.attack]
	var enemy_near_death:bool = current_enemy.get_damaged_health() <= 1* current_player.current_stats[Stats.attack]
	var near_end:bool = player_near_death or enemy_near_death
	
	var slow_opener:bool = turn_number <= 2
	var failsafe:float = 0.2
	
	var animation_timer:Timer = Timer.new()
	add_child(animation_timer)
	#this is different from get_tree().create_timer - it's local to this guy
	#so i can delete this node and all the timers cleanly stop
	var timer_duration:float
	
	if slow_opener:
		timer_duration = opener_turn_delay
		
	elif not slow_opener and not near_end:
		timer_duration = middle_turn_delay
	
	elif near_end:
		timer_duration = near_end_delay
	
	else:
		push_warning("no turn animation state chosen; using failsafe")
		timer_duration = failsafe
	
	animation_timer.start(timer_duration)
	await animation_timer.timeout
	animation_timer.queue_free()

func handle_perishing_combatant(combatant_who_died:Combatant) -> void:
	combatant_who_died.on_end_combat_functions()
	
	if combatant_who_died.is_the_player:
		CombatEvents.combat_ongoing = false
	
	elif combatant_who_died.is_an_enemy:
		combatants.erase(combatant_who_died)
		combatant_who_died.queue_free()
		
		var remaining_enemies:int = 0
		for combatant:Combatant in combatants:
			if combatant.is_an_enemy: remaining_enemies += 1
		if remaining_enemies == 0:
			CombatEvents.combat_ongoing = false
			player_victorious = true
			

func stop_combat() -> void:
	CombatEvents.combat_ongoing = false
	
	for combatant:Combatant in combatants:
		combatant.on_end_combat_functions()
	
	CombatEvents.combat_finished.emit(combatants)
	
	if player_victorious:
		HudEvents.combat_won.emit()
	else:
		HudEvents.combat_lost.emit()
	
	player_victorious = false
	
	for combatant:Combatant in combatants:
		if combatant.dead:
			combatant.queue_free()
		else:
			combatant.unsetup()
	combatants.clear()

func pre_combat(map_tile:MapTile) -> void:
	if not current_player:
		current_player = setup_combatant(create_player_combatant(), true)
		add_child(current_player)
	else:
		current_player = setup_combatant(current_player, true)
	combatants.append(current_player)
	
	current_enemy = setup_combatant(map_tile.tile_data.enemy)
	combatants.append(current_enemy)
	
	current_player.current_target = current_enemy
	current_enemy.current_target = current_player

	AuraEvents.initalize_combat_stats.emit()
	turn = precombat
	CombatEvents.combat_ongoing = false
	turn_finished = true
	reset_turn_counter()
	
	var players:Array[Combatant] = []
	var enemies:Array[Combatant] = []
	for combatant:Combatant in combatants:
		if combatant.is_the_player:
			players.append(combatant)
		if not combatant.is_the_player:
			enemies.append(combatant)
	
	can_start_combat = true

func setup_combatant(new_combatant:Combatant, is_the_player:bool = false) -> Combatant:	
	if is_the_player: new_combatant.setup(true)
	else: new_combatant.setup(false)
	
	return new_combatant

func start_combat() -> void:
	if not CombatEvents.combat_ongoing and can_start_combat:
		can_start_combat = false
		CombatEvents.combat_ongoing = true
		
		for combatant:Combatant in combatants:
			combatant.on_start_combat_functions()
		
		CombatEvents.combat_started.emit(combatants)
	
		#auto start, with last chosen speed
		match HudEvents.last_combat_speed_chosen:
			HudEvents.CombatSpeedNames.STEP: step_button_pressed()
			HudEvents.CombatSpeedNames.PLAY: play_button_pressed()
			HudEvents.CombatSpeedNames.PLAY_FAST: play_fast_button_pressed()
			_: push_error("not sure what last combat speed was")

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
