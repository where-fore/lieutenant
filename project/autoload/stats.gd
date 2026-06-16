extends Node

const health:StringName = &"Max Health"
const attack:StringName = &"Attack"

const strength:StringName = &"Strength"
const agility:StringName = &"Agility"
const mind:StringName = &"Mind"
const fortitude:StringName = &"Fortitude"

const attributes:Array[StringName] = [
	strength,
	agility,
	mind,
	fortitude
]

const strength_per_attack:int = 20
const strength_per_health:int = 2

const agility_per_attack:int = 10
const agility_per_health:int = 4

const mind_per_shield_per_turn:int = 10

const fortitude_per_health:int = 1

#make sure to check entropy system implementation before using
#const crit_chance:StringName = &"Crit Chance"
#const crit_multi:StringName = &"Crit Multiplier"
#const base_crit_multi:int = 200
