extends Node

var sword_damage:int = 6
var shield_health:int = 30

var player_base_health:int = 20
var player_base_attack:int = 1
var tutorial_base_health:int = 6
var tutorial_base_attack:int = 2

var rest_hp:int = 20
var sharpen_attack:int = 5

var enemy_base_health:int = 40
var enemy_base_attack:int = 4

var enemy_health_scaling_per_power:int = 100 #percentage points
var enemy_attack_scaling_per_power:int = 50 #percentage points
var enemy_beginning_health_scaling:int = 100 #percentage points

#note this probably doesn't work like you think - control-shift-f
var max_party_size:int = 4
