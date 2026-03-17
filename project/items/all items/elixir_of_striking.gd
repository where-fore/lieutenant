extends Item

#whatever the item does, doesn't do anything until you do something with it


func setup_basic_item_data() -> void:
	item_id = "elixir_of_striking" # "generic_item"
	item_name = "Elixir of Striking" # "Generic Item"
	item_sprite = load("res://sprites/potion.png")
	extra_tooltip = "You strike twice over, briefly" # "Generic flavourful description"
	item_categories = [ItemCategories.rare_item]
	
	#optional special visible aura
	custom_aura_template = load("res://items/all items/striking.tres")
	aura_application_time = Item.ApplyType.ON_COMBAT_START


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by item_base.gd--
