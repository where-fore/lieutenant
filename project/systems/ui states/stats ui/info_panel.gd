extends Panel
class_name InfoPanel

@onready var my_item_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Items
@onready var my_aura_panel:StatPanel = $VBoxContainer/Body/MarginContainer/HBoxContainer/Auras
@onready var my_title_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/Label

@onready var my_health_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var my_attack_label:Label = $VBoxContainer/Portrait/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/AttackLabel

var my_combatant:Combatant

func connect_signals() -> void:
	visibility_changed.connect(update_title_stats)

func update_title_stats() -> void:
	my_title_label.text = my_combatant.combatant_name
	my_health_label.text = str(my_combatant.current_stats[Stats.health])
	my_attack_label.text = str(my_combatant.current_stats[Stats.attack])
