extends Combatant

var attack_per_turn:int = BalanceData.enemy_base_attack / 2
var buff_aura_name:String = "Growing Impatience"
var buff_aura:Aura

func _init() -> void:
	combatant_id = "skeleton_behemoth" # "generic_enemy"
	combatant_name = "The Marrow" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_shattered.png")
	extra_tooltip = "Monstrously tough and imposingly large\nGrows in strength through combat" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	base_health = BalanceData.enemy_base_health * 3
	base_attack = BalanceData.enemy_base_attack * 1

#called by Combatant
func on_start_combat() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	AuraEvents.give_aura_to_enemy.emit(buff_aura)

func on_after_attack() -> void:
	if not buff_aura.additive_stat_dictionary.has(Stats.attack):
		buff_aura.additive_stat_dictionary[Stats.attack] = 0
	buff_aura.additive_stat_dictionary[Stats.attack] += attack_per_turn
	buff_aura.update_aura()
	
	CombatLogEvents.custom_message.emit(self.name + "'s roars")
