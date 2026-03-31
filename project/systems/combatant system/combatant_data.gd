extends Resource
class_name CombatantData

var id:String
var name:String
var texture:Texture2D
var categories:Dictionary[StringName, int]
var extra_tooltip:String

var base_health:int
var base_attack:int

var scaled_health:int:
	get:
		if not scaled_health: return base_health
		else: return scaled_health
var scaled_attack:int:
	get:
		if not scaled_attack: return base_attack
		else: return scaled_attack


var base_script:GDScript = preload("res://systems/combatant system/combatant.gd")

func _init() -> void:
	setup_stats()

#this is copied from aura_base.gd
func get_tooltip() -> String:
	var tooltip_text:String = name
	
	var to_add:String
	to_add = "Health:" + str(scaled_health)
	tooltip_text += "\n" + to_add
	to_add = "Attack:" + str(scaled_attack)
	tooltip_text += "\n" + to_add
	
	if extra_tooltip: tooltip_text += "\n" + extra_tooltip
	return tooltip_text


#derived subclasses hook onto these functions
func on_start_combat() -> void:
	pass

func on_start_turn() -> void:
	pass

func on_after_attack() -> void:
	pass

func on_damage_taken(_amount_taken:int) -> void:
	pass

func on_end_turn() -> void:
	pass

func on_combat_end() -> void:
	pass

func setup_stats() -> void:
	pass

func scale_stats(_power:int) -> void:
	pass
