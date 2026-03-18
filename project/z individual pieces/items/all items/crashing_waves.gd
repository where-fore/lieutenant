extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = 2
var attack_per_turn:int = 3
var combat_log_message:String = "The tide ebbs."


func setup_basic_item_data() -> void:
	item_id = "crashing_waves" # "generic_item"
	item_name = "Crashing Waves" # "Generic Item"
	item_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "Power surges by %s every attack" % attack_per_turn # "Generic flavourful description"
	item_categories = [ItemCategories.rare_item]
	
	#optional special visible aura
	custom_aura_template = load("res://z individual pieces/items/all items/crashing_waves.tres")
	aura_application_time = Item.ApplyType.ON_COMBAT_START


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage

func on_attack(_source:Combatant) -> void:
	var my_aura:Aura = self.get_custom_aura()
	if not my_aura.additive_stat_dictionary.has(Stats.attack):
		my_aura.additive_stat_dictionary[Stats.attack] = 0
	my_aura.additive_stat_dictionary[Stats.attack] += attack_per_turn
	my_aura.update_aura()
	
	CombatLogEvents.custom_message.emit(combat_log_message)

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	var my_aura:Aura = self.get_custom_aura()
	my_aura.additive_stat_dictionary[Stats.attack] = 0
	my_aura.update_aura()

#--end of functions called by item_base.gd--
