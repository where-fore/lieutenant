extends Panel
class_name InfoPanel

@onready var my_item_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Items
@onready var my_aura_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Auras
@onready var my_title_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var my_portrait:TextureRect = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/Portrait

@onready var my_health_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var my_attack_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttackLabel
@onready var my_strength:DisplayStat = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Strength
@onready var my_dexterity:DisplayStat = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Dexterity
@onready var my_intelligence:DisplayStat = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Intelligence

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
	
	my_dexterity.my_label.text = str(my_combatant.current_stats.get(Stats.dexterity, 0))
	my_dexterity.tooltip_text = str(Stats.dexterity_per_attack) + " dexterity = 1 attack"
	
	my_intelligence.my_label.text = str(my_combatant.current_stats.get(Stats.intelligence, 0))
	my_intelligence.tooltip_text = "intelligence doesn't meaningfully contribute to your life"
