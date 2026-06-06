extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Guiding Light" # "Generic Item"
	reward_sprite = load("res://sprites/penta_ruby_ring.png")
	extra_tooltip = "After attacking, heal your allies for {percent}% of your lowest attribute".format({"percent": percent_of_stat_to_heal}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#custom stuff
var amount_to_heal:int
var percent_of_stat_to_heal:int = 25

func on_attack(_source:Combatant, _target:Combatant) -> void:
	amount_to_heal = (parent_combatant.current_stats[find_lowest_attribute()] * percent_of_stat_to_heal / 100)
	
	for ally:Combatant in parent_combatant.allies:
		ally.heal(amount_to_heal)

func find_lowest_attribute() -> StringName:
	var current_lowest:StringName
	
	for attribute:StringName in Stats.attributes:
		if not current_lowest:
			current_lowest = attribute
			continue
		
		if parent_combatant.current_stats[attribute] < parent_combatant.current_stats[current_lowest]:
			current_lowest = attribute
	
	return current_lowest
