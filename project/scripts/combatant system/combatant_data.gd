extends Resource
class_name CombatantData

@export var name:String = "Generic Combatant"
@export var base_health:int = 1337
@export var health_scaling:int = 1337
@export var base_attack:int = 80085
@export var attack_scaling:int = 80085
@export var texture:Texture2D
@export var base_script:GDScript = preload("res://scripts/combatant system/combatant.gd")
