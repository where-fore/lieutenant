extends Panel
class_name InfoPanel

@export var my_item_panel:StatPanel
@export var my_aura_panel:StatPanel
@export var my_title_label:Label
@export var my_portrait:TextureRect

@export var my_health_label:Label
@export var my_attack_label:Label
@export var my_strength:DisplayStat
@export var my_agility:DisplayStat
@export var my_mind:DisplayStat
@export var my_fortitude:DisplayStat

var my_combatant:Combatant

func connect_signals() -> void:
	visibility_changed.connect(update_title_stats)

func update_title_stats() -> void:
	my_title_label.text = my_combatant.combatant_name
	my_portrait.texture = my_combatant.combatant_texture
	
	my_health_label.text = str(my_combatant.current_stats.get(Stats.health, 0))
	my_attack_label.text = str(my_combatant.current_stats.get(Stats.attack, 0))
	
	var current_strength:int = my_combatant.current_stats.get(Stats.strength, 0)
	my_strength.my_label.text = str(current_strength)
	my_strength.tooltip_text = str("Attack increased by ", current_strength/Stats.strength_per_attack, ", Health increased by ", current_strength/Stats.strength_per_health)
	my_strength.tooltip_text += str("\n", Stats.strength_per_attack, " ", Stats.strength, " = 1 attack", "\n", + Stats.strength_per_health, " ", Stats.strength, " = 1 health")
	
	var current_agility:int = my_combatant.current_stats.get(Stats.agility, 0)
	my_agility.my_label.text = str(current_agility)
	my_agility.tooltip_text = str("Attack increased by ", current_agility/Stats.agility_per_attack, ", Health increased by ", current_agility/Stats.agility_per_health)
	my_agility.tooltip_text += str("\n", Stats.agility_per_attack, " ", Stats.agility, " = 1 attack", "\n", + Stats.agility_per_health, " ", Stats.agility, " = 1 health")
	
	var current_mind:int = my_combatant.current_stats.get(Stats.mind, 0)
	my_mind.my_label.text = str(current_mind)
	my_mind.tooltip_text = str("Shielding every turn for ", current_mind/Stats.mind_per_shield_per_turn)
	my_mind.tooltip_text += str("\n", Stats.mind_per_shield_per_turn, " ", Stats.mind, " = 1 shield per turn")
	
	var current_fortitude:int = my_combatant.current_stats.get(Stats.fortitude, 0)
	my_fortitude.my_label.text = str(current_fortitude)
	my_fortitude.tooltip_text = str("Health increased by ", current_fortitude/Stats.fortitude_per_health)
	my_fortitude.tooltip_text += str("\n", Stats.fortitude_per_health, " ", Stats.fortitude, " = 1 health")
