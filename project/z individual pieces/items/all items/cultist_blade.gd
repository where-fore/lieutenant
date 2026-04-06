extends Item

var percent_of_damage_taken_gained_as_attack:int = 20
var healing_per_attack_multiplier:int = 25
var buff_aura:Aura
var buff_aura_name:String = "Blood Glee"

func setup_basic_item_data() -> void:
	item_id = "cultist_blade" # "generic_item"
	item_name = "Cultist Blade" # "Generic Item"
	item_sprite = load("res://sprites/curved_dagger.png")
	extra_tooltip = "Increase attack by {val}% of damage taken every time you bleed".format({"val": percent_of_damage_taken_gained_as_attack}) # "Generic flavourful description"
	extra_tooltip += "\nHeal for {val}% of attack when tasting blood".format({"val": healing_per_attack_multiplier}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()

func on_attack(source:Combatant, _target:Combatant) -> void:
	var healing:int = source.current_stats[Stats.attack] * healing_per_attack_multiplier / 100
	source.heal(healing)

func on_damage_taken(_source:Combatant, amount_taken:int) -> void:
	var attack_to_gain:int = amount_taken * percent_of_damage_taken_gained_as_attack / 100
	
	if not buff_aura:
		initialize_aura()
	
	if not buff_aura.additive_stat_dictionary.has(Stats.attack):
		buff_aura.additive_stat_dictionary[Stats.attack] = 0
	buff_aura.additive_stat_dictionary[Stats.attack] += attack_to_gain
	buff_aura.update_aura()

func on_combat_end() -> void:
	if buff_aura: clear_my_aura()

func clear_my_aura() -> void:
	AuraEvents.remove_aura_from_player.emit(buff_aura)
	buff_aura = null

func initialize_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	AuraEvents.give_aura_to_player.emit(buff_aura)
