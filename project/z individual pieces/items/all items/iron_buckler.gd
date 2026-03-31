extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_health:int = BalanceData.shield_health * 2


func setup_basic_item_data() -> void:
	item_id = "iron_buckler" # "generic_item"
	item_name = "Iron Buckler" # "Generic Item"
	item_sprite = load("res://sprites/small_buckler.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	#optional special visible aura
	custom_aura_template = null # load("res://z individual pieces/items/all items/paladin's armor/paladins_might.tres")
	aura_application_time = ApplyType.ON_EQUIP


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.health] = my_health
