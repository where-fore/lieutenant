extends Combatant

func _init() -> void:
	combatant_id = "tutorial_wolf" # "generic_enemy"
	combatant_name = "Hollow-hide Wolf" # "Generic Combatant"
	combatant_texture = load("res://sprites/wolf.png")
	extra_tooltip = "A wild canine with little strength left" # "Generic flavourful description"
	combatant_categories = {
	}

	base_health = BalanceData.tutorial_base_health
	base_attack = BalanceData.tutorial_base_attack

#overwrite scaling function
func scale_stats(_power:int) -> void:
	scaled_health = base_health
	scaled_attack = base_attack
