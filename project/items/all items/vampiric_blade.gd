extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = 8
var healing_per_attack:int = 4


func setup_basic_item_data() -> void:
	item_id = "vampiric_blade" # "generic_item"
	item_name = "Vampiric Blade" # "Generic Item"
	item_sprite = load("res://sprites/vamp_blade.png")
	extra_tooltip = "Enjoy %s health on bloodshed" % healing_per_attack # "Generic flavourful description"
	item_categories = [ItemCategories.rare_item]
	
	#optional special visible aura
	custom_aura_template = null # load("res://items/all items/crashing_waves.tres")
	aura_application_time = Item.ApplyType.ON_COMBAT_START


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage

func on_attack(source:Combatant) -> void:
	source.take_damage(healing_per_attack * -1)

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by item_base.gd--
