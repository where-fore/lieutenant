extends Item


#basic setup
func setup_item_stats() -> void:
	reward_name = "Vampiric Blade" # "Generic Item"
	reward_sprite = load("res://sprites/vamp_blade.png")
	extra_tooltip = "Heal for {val}% of attack when tasting blood".format({"val": healing_per_attack_multiplier}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.rare_stat_budget / 2
	additive_stat_dictionary[Stats.agility] = BalanceData.rare_stat_budget / 2


#custom stuff
var healing_per_attack_multiplier:int = 15

func on_attack(source:Combatant, _target:Combatant) -> void:
	var healing:int = source.current_stats[Stats.attack] * healing_per_attack_multiplier / 100
	source.heal(healing)
