extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = BalanceData.sword_damage / 2
var aura_template:Aura = load("res://z individual pieces/auras/item auras/crashing_waves_aura.gd").new()

func setup_basic_item_data() -> void:
	reward_name = "Crashing Waves" # "Generic Item"
	reward_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "Power surges by %s every attack" % aura_template.attack_per_turn # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage

func on_combat_start() -> void:
	add_to_custom_auras(aura_template.create_aura())
