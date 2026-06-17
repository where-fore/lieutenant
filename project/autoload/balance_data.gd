extends Node

func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	CombatEvents.party_member_added.connect(func(_unused_data) -> void: increase_enemy_stat_budget())
	TimingEvents.restarting_game.connect(reset_enemy_stat_budget)

var common_stat_budget:int = 40
var rare_stat_budget:int = common_stat_budget * 3 / 2
var common_multiplicative_stat_budget:int = 25
var rare_multiplicative_stat_budget:int = common_multiplicative_stat_budget * 3 / 2
var basic_health:int = 20
var basic_attack:int = 5

var player_base_strength:int = common_stat_budget
var player_base_agility:int = common_stat_budget
var player_base_mind:int = 0
var player_base_fortitude:int = common_stat_budget

var flower_basic_stat:int = common_stat_budget
var flower_basic_split_stat:int = flower_basic_stat / 2

var _base_enemy_stat_scaling_per_day_base:float = 1.15
var _base_enemy_normal_stat_budget:int = common_stat_budget * 5 / 2
var enemy_stat_scaling_per_day:float = _base_enemy_stat_scaling_per_day_base
var enemy_normal_stat_budget:int = _base_enemy_normal_stat_budget
func increase_enemy_stat_budget() -> void:
	enemy_normal_stat_budget *= 2
	enemy_stat_scaling_per_day += 0.25
func reset_enemy_stat_budget() -> void:
	enemy_stat_scaling_per_day = _base_enemy_stat_scaling_per_day_base
	enemy_normal_stat_budget = _base_enemy_normal_stat_budget

var enemy_rare_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_stat_budget:int = enemy_normal_stat_budget * 3

var enemy_normal_health_stat_budget:int = common_stat_budget * 5
var enemy_rare_health_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_mythic_health_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_health_stat_budget:int = enemy_normal_stat_budget * 10

var enemy_tutorial_easy_stat_budget:int = enemy_normal_stat_budget / 2
var enemy_tutorial_hard_stat_budget:int = enemy_normal_stat_budget

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
