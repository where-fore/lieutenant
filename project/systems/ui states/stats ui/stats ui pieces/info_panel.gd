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

var my_combatant:Combatant

func connect_signals() -> void:
	visibility_changed.connect(update_title_stats)

func update_title_stats() -> void:
	my_title_label.text = my_combatant.combatant_name
	my_portrait.texture = my_combatant.combatant_texture
	
	my_health_label.text = str(my_combatant.current_stats.get(Stats.health, 0))
	my_attack_label.text = str(my_combatant.current_stats.get(Stats.attack, 0))
	
	my_strength.my_label.text = str(my_combatant.current_stats.get(Stats.strength, 0))
	my_strength.tooltip_text = str(Stats.strength_per_attack) + " strength = 1 attack" + "\n" + str(Stats.strength_per_health) + " strength = 1 health"
	my_strength.tooltip_text = str(Stats.strength_per_attack, " ", Stats.strength, " = 1 attack", "\n", + Stats.strength_per_health, " ", Stats.strength, " = 1 health")
	
	my_agility.my_label.text = str(my_combatant.current_stats.get(Stats.agility, 0))
	my_agility.tooltip_text = str(Stats.agility_per_attack, " ", Stats.agility, " = 1 attack", "\n", + Stats.agility_per_health, " ", Stats.agility, " = 1 health")
	
	my_mind.my_label.text = str(my_combatant.current_stats.get(Stats.mind, 0))
	my_mind.tooltip_text = str(Stats.mind_per_shield_per_turn, " ", Stats.mind, " = 1 shield per turn")
