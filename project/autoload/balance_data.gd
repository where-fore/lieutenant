extends Node

func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	CombatEvents.party_member_added.connect(func(_unused_data) -> void: increase_enemy_stat_budget())

var common_stat_budget:int = 20
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
var flower_basic_split_stat:int = flower_basic_stat * 1 / 2

var enemy_stat_scaling_per_day:float = 1.50

var enemy_normal_stat_budget:int = common_stat_budget * 2
func increase_enemy_stat_budget() -> void:
	enemy_normal_stat_budget *= 2

var enemy_rare_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_stat_budget:int = enemy_normal_stat_budget * 4

var enemy_normal_health_stat_budget:int = common_stat_budget * 6
var enemy_rare_health_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_mythic_health_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_health_stat_budget:int = enemy_normal_stat_budget * 4

var enemy_tutorial_easy_stat_budget:int = enemy_normal_stat_budget
var enemy_tutorial_hard_stat_budget:int = enemy_normal_stat_budget * 4 / 3

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
