extends Node

var player_base_strength:int = 10
var player_base_dexterity:int = 10
var player_base_intelligence:int = 0

var basic_stat:int = 10
var basic_stat_scaling:int = 25
var basic_health:int = 20
var basic_attack:int = 5

var rest_hp:int = 20
var sharpen_attack:int = 5

var enemy_stat_scaling_per_day:float = 1.30
var enemy_normal_stat_budget:int = 40
var enemy_rare_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget * 5 / 2
var enemy_boss_stat_budget:int = enemy_normal_stat_budget * 3

var enemy_tutorial_easy_stat_budget:int = enemy_normal_stat_budget * 1 / 4
var enemy_tutorial_hard_stat_budget:int = enemy_normal_stat_budget * 2 / 3

#var enemy_health_scaling_per_power:int = 100 #percentage points
#var enemy_attack_scaling_per_power:int = 50 #percentage points
#var enemy_beginning_health_scaling:int = 100 #percentage points

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
