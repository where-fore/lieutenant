extends Node


var basic_stat:int = 20
var basic_stat_scaling:int = 25
var basic_health:int = 20
var basic_attack:int = 5

var player_base_strength:int = basic_stat
var player_base_agility:int = basic_stat
var player_base_mind:int = 0
var player_base_fortitude:int = basic_stat

var flower_basic_stat:int = basic_stat
var flower_basic_split_stat:int = flower_basic_stat * 1 / 2
var rest_hp:int = 20
var sharpen_attack:int = 5

var enemy_stat_scaling_per_day:float = 1.30
var enemy_normal_stat_budget:int = basic_stat * 6
var enemy_rare_stat_budget:int = enemy_normal_stat_budget * 3 / 2 
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_stat_budget:int = enemy_normal_stat_budget * 3

var enemy_tutorial_easy_stat_budget:int = enemy_normal_stat_budget * 1 / 5
var enemy_tutorial_hard_stat_budget:int = enemy_normal_stat_budget * 1 / 2

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
