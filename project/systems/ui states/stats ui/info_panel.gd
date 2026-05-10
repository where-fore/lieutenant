extends Panel
class_name InfoPanel

@onready var my_item_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Items
@onready var my_aura_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Auras
@onready var my_title_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var my_portrait:TextureRect = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/Portrait

@onready var my_health_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var my_attack_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttackLabel
@onready var my_strength_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/StrengthLabel2
@onready var my_dexterity_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/DexterityLabel3
@onready var my_intelligence_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/IntelligenceLabel

var my_combatant:Combatant

func connect_signals() -> void:
	visibility_changed.connect(update_title_stats)

func update_title_stats() -> void:
	my_title_label.text = my_combatant.combatant_name
	my_portrait.texture = my_combatant.combatant_texture
	my_health_label.text = str(my_combatant.current_stats.get(Stats.health, 0))
	my_attack_label.text = str(my_combatant.current_stats.get(Stats.attack, 0))
	my_strength_label.text = str(my_combatant.current_stats.get(Stats.strength, 0))
	my_dexterity_label.text = str(my_combatant.current_stats.get(Stats.dexterity, 0))
	my_intelligence_label.text = str(my_combatant.current_stats.get(Stats.intelligence, 0))
