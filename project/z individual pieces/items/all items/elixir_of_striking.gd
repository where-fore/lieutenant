extends Item

#basic setup
func setup_item_stats() -> void:	
	reward_name = "Elixir of Striking" # "Generic Item"
	reward_sprite = load("res://sprites/potion.png")
	extra_tooltip = "You strike with frightening vigour for {multiplier}% attack, briefly".format({"multiplier":  str(striking_aura_template.my_public_multiplier)}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#custom stuff
var striking_aura_template:Aura = load("res://z individual pieces/auras/item auras/striking.gd").new()

func on_combat_start() -> void:
	add_to_custom_auras(striking_aura_template.create_aura())
