extends Node

var sword_damage:int = 6
var shield_health:int = 30

var player_base_strength:int = 10
var player_base_dexterity:int = 5

var rest_hp:int = 20
var sharpen_attack:int = 5

var enemy_normal_stat_budget:int = 40
var enemy_tutorial_stat_budget:int = enemy_normal_stat_budget / 4
var enemy_rare_stat_budget:int = enemy_normal_stat_budget * 3 / 2
var enemy_mythic_stat_budget:int = enemy_normal_stat_budget * 2
var enemy_boss_stat_budget:int = enemy_mythic_stat_budget * 3 /2

#var enemy_health_scaling_per_power:int = 100 #percentage points
#var enemy_attack_scaling_per_power:int = 50 #percentage points
#var enemy_beginning_health_scaling:int = 100 #percentage points

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
