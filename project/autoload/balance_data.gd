extends Node


var common_stat_budget:int = 20
var rare_stat_budget:int = common_stat_budget * 2
var common_multiplicative_stat_budget:int = 25
var rare_multiplicative_stat_budget:int = common_multiplicative_stat_budget * 2
var basic_health:int = 20
var basic_attack:int = 5

var player_base_strength:int = common_stat_budget
var player_base_agility:int = common_stat_budget
var player_base_mind:int = 0
var player_base_fortitude:int = common_stat_budget

var flower_basic_stat:int = common_stat_budget
var flower_basic_split_stat:int = flower_basic_stat * 1 / 2
var rest_hp:int = 20
var sharpen_attack:int = 5

var enemy_stat_scaling_per_day:float = 1.50
var enemy_normal_stat_budget:int = common_stat_budget * 10
var enemy_rare_stat_budget:int = enemy_normal_stat_budget
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget
var enemy_boss_stat_budget:int = enemy_normal_stat_budget * 3

var enemy_tutorial_easy_stat_budget:int = enemy_normal_stat_budget * 1 / 5
var enemy_tutorial_hard_stat_budget:int = enemy_normal_stat_budget * 1 / 2

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
