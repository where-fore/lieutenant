extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = BalanceData.sword_damage * 2
var healing_per_attack_multiplier:int = 15


func setup_basic_item_data() -> void:
	item_id = "vampiric_blade" # "generic_item"
	reward_name = "Vampiric Blade" # "Generic Item"
	reward_sprite = load("res://sprites/vamp_blade.png")
	extra_tooltip = "Heal for {val}% of attack when tasting blood".format({"val": healing_per_attack_multiplier}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage

func on_attack(source:Combatant, _target:Combatant) -> void:
	var healing:int = source.current_stats[Stats.attack] * healing_per_attack_multiplier / 100
	source.heal(healing)
