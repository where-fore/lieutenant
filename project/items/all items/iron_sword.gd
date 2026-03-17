extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = 4


func setup_basic_item_data() -> void:
	item_id = "iron_sword" # "generic_item"
	item_name = "Iron Sword" # "Generic Item"
	item_sprite = load("res://sprites/sword.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = [ItemCategories.common_item]
	
	#optional special visible aura
	custom_aura_template = null # load("res://items/all items/paladin's armor/paladins_might.tres")
	aura_application_time = ApplyType.ON_EQUIP


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by item_base.gd--
