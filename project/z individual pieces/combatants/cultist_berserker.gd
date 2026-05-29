extends Combatant

var turns_dormant:int = 3

var debuff_name:String = "Dormant"
#var buff_message:String = "The cultist's pupils dilate as they enter a fury."

func _init() -> void:
	combatant_name = "The Vein" # "Generic Combatant"
	combatant_texture = load("res://sprites/transformed_cultist.png")
	extra_tooltip = "Gathering power..." # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	starting_stats[Stats.strength] = BalanceData.enemy_mythic_stat_budget
	starting_stats[Stats.agility] = BalanceData.enemy_mythic_stat_budget * 2 / 3

#called by Combatant
func on_start_combat() -> void:
	go_dormant()

func go_dormant() -> void:
	var buff_aura:Aura = Aura.new().create_aura(debuff_name)
	
	buff_aura.duration_type = AuraNames.DurationType.TURNS
	buff_aura.base_duration = turns_dormant
	buff_aura.additive_stat_dictionary[Stats.attack] = -1 * current_stats[Stats.attack]
	
	apply_aura_or_item(buff_aura)
