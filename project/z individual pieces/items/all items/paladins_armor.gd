extends Item

#whatever the item does, doesn't do anything until you do something with it
var health_multi:int = 200

func setup_basic_item_data() -> void:
	item_id = "paladins_armor" # "generic_item"
	item_name = "Fallen Paladin's Armor" # "Generic Item"
	item_sprite = load("res://sprites/armor.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#optional special visible aura
	custom_aura_template = null#load("res://z individual pieces/items/all items/paladins_armor.tres")
	aura_application_time = Item.ApplyType.ON_EQUIP


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	multiplicative_stat_dictionary[Stats.health] = health_multi

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by item_base.gd--
