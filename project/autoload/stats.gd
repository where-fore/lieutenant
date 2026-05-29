extends Node

const health:StringName = &"Health"
const attack:StringName = &"Attack"

const strength:StringName = &"Strength"
const dexterity:StringName = &"Dexterity"
const intelligence:StringName = &"Intelligence"

const attributes:Array[StringName] = [
	strength,
	dexterity,
	intelligence,
]

const strength_per_attack:int = 10
const strength_per_health:int = 1

const dexterity_per_attack:int = 5
const dexterity_per_health:int = 2

const intelligence_per_shield_per_turn:int = 10

#make sure to check entropy system implementation before using
#const crit_chance:StringName = &"Crit Chance"
#const crit_multi:StringName = &"Crit Multiplier"
#const base_crit_multi:int = 200
