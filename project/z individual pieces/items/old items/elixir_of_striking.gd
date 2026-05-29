extends Item

#whatever the item does, doesn't do anything until you do something with it
var striking_aura_template:Aura = load("res://z individual pieces/auras/item auras/striking.gd").new()

func setup_basic_item_data() -> void:	
	reward_name = "Elixir of Striking" # "Generic Item"
	reward_sprite = load("res://sprites/potion.png")
	extra_tooltip = "You strike with frightening vigour for {multiplier}% attack, briefly".format({"multiplier":  str(striking_aura_template.multiplier)}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does

func on_combat_start() -> void:
	add_to_custom_auras(striking_aura_template.create_aura())
