extends Item

var percent_of_damage_taken_gained_as_attack:int = 30
var buff_aura:Aura
var buff_aura_name:String = "Blood Glee"

func setup_basic_item_data() -> void:
	item_id = "cultist_blade" # "generic_item"
	item_name = "Cultist Blade" # "Generic Item"
	item_sprite = load("res://sprites/sword.png")
	extra_tooltip = "Increase attack by {val}% of damage taken".format({"val": percent_of_damage_taken_gained_as_attack}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	
	#optional special visible aura
	custom_aura_template = null # load("res://z individual pieces/items/all items/crashing_waves.tres")
	aura_application_time = Item.ApplyType.ON_COMBAT_START


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item doesfunc on_start_combat() -> void:
func on_combat_start() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	AuraEvents.give_aura_to_player.emit(buff_aura)

func on_damage_taken(_source:Combatant, amount_taken:int) -> void:
	var attack_to_gain:int = (amount_taken*percent_of_damage_taken_gained_as_attack)/100
	
	if not buff_aura.additive_stat_dictionary.has(Stats.attack):
		buff_aura.additive_stat_dictionary[Stats.attack] = 0
	buff_aura.additive_stat_dictionary[Stats.attack] += attack_to_gain
	buff_aura.update_aura()
