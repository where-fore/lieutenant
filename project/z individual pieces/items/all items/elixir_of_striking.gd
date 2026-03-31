extends Item

#whatever the item does, doesn't do anything until you do something with it

func setup_basic_item_data() -> void:
	#optional special visible aura
	custom_aura_template = load("res://z individual pieces/auras/item auras/striking.gd")
	aura_application_time = Item.ApplyType.ON_COMBAT_START
	
	item_id = "elixir_of_striking" # "generic_item"
	item_name = "Elixir of Striking" # "Generic Item"
	item_sprite = load("res://sprites/potion.png")
	extra_tooltip = "You strike with frightening vigour, briefly" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
