extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = 2
var combat_log_message:String = "The tide ebbs."


func setup_basic_item_data() -> void:
	#optional special visible aura
	custom_aura_template = load("res://z individual pieces/auras/item auras/crashing_waves_aura.gd")
	aura_application_time = Item.ApplyType.ON_COMBAT_START
	
	
	item_id = "crashing_waves" # "generic_item"
	item_name = "Crashing Waves" # "Generic Item"
	item_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "Power surges by %s every attack" % get_custom_aura().attack_per_turn # "Generic flavourful description"
	item_categories = [ItemCategories.rare_item]
	
	


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
